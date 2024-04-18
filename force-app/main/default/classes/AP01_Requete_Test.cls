/*
* @author: Joyce Saidy
* @date: 13/10/2020
* @ Description Class that test AP01_Requete . Associated Trigger : RequeteAfterInsert
* History
* <Date of modification>   <Author>    <Description of modification>
* 		28/09/2021   		Claire VEHRLE  		  Clôture des requêtes de type Remplacement de matériel dès la collecte d'audience du nouvel équipement (de remplacement) 
*/
@isTest 
public class AP01_Requete_Test {
    
    public static testMethod void NouvelleInterventionTest(){
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        u.Bypass_triggers__c = 'AP01_WorkOrder';
        update u;
        
        System.runAs(u){
        
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        testAccount.Nombre_TV__c='2';
        listFoyersToInsert.add(testAccount); 
        insert listFoyersToInsert;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Foyer__c = testAccount.id;
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelMediamatPame;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
        
        //Create Requete
        list<Case> listCaseToInsert = new list<Case>();
        Case testCase = Test_Utils.createCase(testAccount.id);
        testCase.Origin = Label.CAS_Origine_NouveauFoyer;
        testCase.Description = Label.CASE_Description_InstallationNouveauFoyer;
        testCase.Subject = 'Nouvelle Intervention';
        testCase.Foyer_paneliste__c = foyerPaneliste.Id;
        listCaseToInsert.add(testCase);  
        insert listCaseToInsert;
        
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        
   }
 }

    @isTest
    static void clotureRequeteTest() {
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        u.Bypass_triggers__c = 'AP01_WorkOrder';
        update u;
        
        System.runAs(u){
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        insert referentielPanelToInsert;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelMediamatPame;
        foyerPaneliste.Foyer__c = testAccount.Id;
        foyerPaneliste.Referentiel_Panel__c = refPanMMAT.Id;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
        
        //Create composition foyer
        List<Contact> ListCompositionFoyerToInsert = new List<Contact>();
        Contact compositionFoyer = Test_Utils.createMembreFoyer(testAccount.Id);
        compositionFoyer.Lien_parente__c = '5';
        compositionFoyer.LastName = 'Test';
        ListCompositionFoyerToInsert.add(compositionFoyer);
        insert ListCompositionFoyerToInsert;
        
        //Create Requête
        List<Case> listRequeteToInsert = new List<Case>();
        //Requête avec plusieurs commandes/produits commandés
        Case requeteMulti1 = Test_Utils.createCase(testAccount.Id);
        requeteMulti1.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti1.Subject = 'requeteMulti1';
        requeteMulti1.Status = Label.CAS_Statut_En_cours;
        requeteMulti1.Type = Label.CAS_Type_Anomalie;
        listRequeteToInsert.add(requeteMulti1);
        
        Case requeteMulti2 = Test_Utils.createCase(testAccount.Id);
        requeteMulti2.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti2.Subject = 'requeteMulti2';
        requeteMulti2.Status = Label.CAS_Statut_En_cours;
        requeteMulti2.Type = Label.CAS_Type_Anomalie;
        listRequeteToInsert.add(requeteMulti2);
        
        //Type diférent de remplacement de matériel
        Case requeteDiffType = Test_Utils.createCase(testAccount.Id);
        requeteDiffType.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteDiffType.Subject = 'requeteDiffType';
        requeteDiffType.Status = Label.CAS_Statut_En_cours;
        requeteDiffType.Type = Label.CAS_Type_Recrute;
        listRequeteToInsert.add(requeteDiffType);
        
        //Requête déjà cloturé
        Case requeteCloture = Test_Utils.createCase(testAccount.Id);
        requeteCloture.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteCloture.Subject = 'requeteCloture';
        requeteCloture.Status = Label.CAS_Statut_Cloture;
        requeteCloture.Type = Label.CAS_Type_Anomalie;
        listRequeteToInsert.add(requeteCloture);
        
        insert listRequeteToInsert;      
        
        //Create Produit
        List<Product2> listProduitToInsert = new List<Product2>();
        Product2 produit1 = Test_Utils.createproduct();
        produit1.Name = 'Produit1';
        produit1.IsActive = True;
        listProduitToInsert.add(produit1);
        
        Product2 produit2 = Test_Utils.createproduct();
        produit2.Name = 'produit2';
        produit2.IsActive = True;
        listProduitToInsert.add(produit2);
        
        insert listProduitToInsert;        
        
        //Create PricebookEntry
        List<PricebookEntry> listPricebookEntryToInsert = new List<PricebookEntry>();
        PricebookEntry standardPbEntry1 = new PricebookEntry();
        standardPbEntry1.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry1.UnitPrice = 10;
        standardPbEntry1.Product2Id = produit1.id;
        listPricebookEntryToInsert.add(standardPbEntry1);
        
        PricebookEntry standardPbEntry2 = new PricebookEntry();
        standardPbEntry2.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry2.UnitPrice = 30;
        standardPbEntry2.Product2Id = produit2.id;
        listPricebookEntryToInsert.add(standardPbEntry2);
        
        insert listPricebookEntryToInsert;        
        
        //Create Commande
        List<Order> listCommandeToInsert = new List<Order>();
        Order commandeMulti11 = Test_Utils.createOrder(testAccount.Id);
        commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti11.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti11.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti11.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeMulti11);
        
        Order commandeMulti12 = Test_Utils.createOrder(testAccount.Id);
        commandeMulti12.Requete__c = requeteMulti1.Id;
        commandeMulti12.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti12.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti12.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeMulti12);
        
        Order commandeMulti21 = Test_Utils.createOrder(testAccount.Id);
        commandeMulti21.Requete__c = requeteMulti2.Id;
        commandeMulti21.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti21.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti21.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeMulti21);
        
        Order commandeMulti22 = Test_Utils.createOrder(testAccount.Id);
        commandeMulti22.Requete__c = requeteMulti2.Id;
        commandeMulti22.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti22.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti22.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeMulti22);
        
        Order commandeDiffType = Test_Utils.createOrder(testAccount.Id);
        commandeDiffType.Requete__c = requeteDiffType.Id;
        commandeDiffType.Status = Label.Ord_Status_VersionPreliminaire;
        commandeDiffType.Pricebook2Id = Test.getStandardPricebookId();
        commandeDiffType.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeDiffType);
        
        Order commandeCloture = Test_Utils.createOrder(testAccount.Id);
        commandeCloture.Requete__c = requeteCloture.Id;
        commandeCloture.Status = Label.Ord_Status_VersionPreliminaire;
        commandeCloture.Pricebook2Id = Test.getStandardPricebookId();
        commandeCloture.EffectiveDate = Date.Today() - 10;
        listCommandeToInsert.add(commandeCloture);
        
        insert listCommandeToInsert;
        
        //Create Produit Commandé
        List<OrderItem> listProduitCommandeToInsert = new List<OrderItem>();
        OrderItem orderItemA = Test_Utils.createOrderItem();
        orderItemA.orderId = commandeMulti11.Id;
        orderItemA.Product2Id = produit1.Id;
        orderItemA.Quantity = 1;
        orderItemA.UnitPrice = 10;
        orderItemA.pricebookEntryId = standardPbEntry1.Id;
        listProduitCommandeToInsert.add(orderItemA);
        
        OrderItem orderItemB = Test_Utils.createOrderItem();
        orderItemB.orderId = commandeMulti11.Id;
        orderItemB.Product2Id = produit2.Id;
        orderItemB.Quantity = 1;
        orderItemB.UnitPrice = 10;
        orderItemB.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemB);
        
        OrderItem orderItemC = Test_Utils.createOrderItem();
        orderItemC.orderId = commandeMulti12.Id;
        orderItemC.Product2Id = produit1.Id;
        orderItemC.Quantity = 1;
        orderItemC.UnitPrice = 10;
        orderItemC.pricebookEntryId = standardPbEntry1.Id;
        listProduitCommandeToInsert.add(orderItemC);
        
        OrderItem orderItemD = Test_Utils.createOrderItem();
        orderItemD.orderId = commandeMulti12.Id;
        orderItemD.Product2Id = produit2.Id;
        orderItemD.Quantity = 1;
        orderItemD.UnitPrice = 10;
        orderItemD.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemD);
        
        OrderItem orderItemE = Test_Utils.createOrderItem();
        orderItemE.orderId = commandeMulti21.Id;
        orderItemE.Product2Id = produit1.Id;
        orderItemE.Quantity = 1;
        orderItemE.UnitPrice = 10;
        orderItemE.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemE);
        
        OrderItem orderItemF = Test_Utils.createOrderItem();
        orderItemF.orderId = commandeMulti21.Id;
        orderItemF.Product2Id = produit2.Id;
        orderItemF.Quantity = 1;
        orderItemF.UnitPrice = 10;
        orderItemF.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemF);
        
        OrderItem orderItemG = Test_Utils.createOrderItem();
        orderItemG.orderId = commandeMulti22.Id;
        orderItemG.Product2Id = produit1.Id;
        orderItemG.Quantity = 1;
        orderItemG.UnitPrice = 10;
        orderItemG.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemG);
        
        OrderItem orderItemH = Test_Utils.createOrderItem();
        orderItemH.orderId = commandeMulti22.Id;
        orderItemH.Product2Id = produit2.Id;
        orderItemH.Quantity = 1;
        orderItemH.UnitPrice = 10;
        orderItemH.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemH);
        
        OrderItem orderItemI = Test_Utils.createOrderItem();
        orderItemI.orderId = commandeDiffType.Id;
        orderItemI.Product2Id = produit2.Id;
        orderItemI.Quantity = 1;
        orderItemI.UnitPrice = 10;
        orderItemI.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemI);
        
        OrderItem orderItemJ = Test_Utils.createOrderItem();
        orderItemJ.orderId = commandeCloture.Id;
        orderItemJ.Product2Id = produit2.Id;
        orderItemJ.Quantity = 1;
        orderItemJ.UnitPrice = 10;
        orderItemJ.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemJ);
        
        insert listProduitCommandeToInsert;
        System.debug('listProduitCommandeToInsert  ' + listProduitCommandeToInsert);
        
        //Create équipement
        list<Asset> listEquipementToInsert = new list<Asset>();
        Asset equipementA = Test_Utils.createEquipement(testAccount.Id);
        equipementA.ContactId = compositionFoyer.Id;
        equipementA.Produit_commande__c = orderItemA.Id;
        equipementA.Audimetre__c = '211EA'; //
        equipementA.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 8;  
        listEquipementToInsert.add(equipementA);
        
        Asset equipementB = Test_Utils.createEquipement(testAccount.Id);
        equipementB.ContactId = compositionFoyer.Id;
        equipementB.Produit_commande__c = orderItemB.Id;
        equipementB.Audimetre__c = '222EEA'; //
        equipementB.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 1;
        listEquipementToInsert.add(equipementB);
        
        Asset equipementC = Test_Utils.createEquipement(testAccount.Id);
        equipementC.ContactId = compositionFoyer.Id;
        equipementC.Produit_commande__c = orderItemC.Id;
        equipementC.Audimetre__c = '232EDDA'; 
        equipementC.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 10;
        listEquipementToInsert.add(equipementC);
        
        Asset equipementD = Test_Utils.createEquipement(testAccount.Id);
        equipementD.ContactId = compositionFoyer.Id;
        equipementD.Produit_commande__c = orderItemD.Id;
        equipementD.Audimetre__c = '235EDFFA'; 
        equipementD.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 40;
        listEquipementToInsert.add(equipementD);
        
        Asset equipementE = Test_Utils.createEquipement(testAccount.Id);
        equipementE.ContactId = compositionFoyer.Id;
        equipementE.Produit_commande__c = orderItemE.Id;
        equipementE.Audimetre__c = '237ERFGA'; 
        equipementE.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 27;
        listEquipementToInsert.add(equipementE);
        
        Asset equipementF = Test_Utils.createEquipement(testAccount.Id);
        equipementF.ContactId = compositionFoyer.Id;
        equipementF.Produit_commande__c = orderItemF.Id;
        equipementF.Audimetre__c = '235EDFKBA'; 
        listEquipementToInsert.add(equipementF);
        
        Asset equipementG = Test_Utils.createEquipement(testAccount.Id);
        equipementG.ContactId = compositionFoyer.Id;
        equipementG.Produit_commande__c = orderItemG.Id;
        equipementG.Audimetre__c = '2388EDFA'; 
        listEquipementToInsert.add(equipementG);
        
        Asset equipementH = Test_Utils.createEquipement(testAccount.Id);
        equipementH.ContactId = compositionFoyer.Id;
        equipementH.Produit_commande__c = orderItemH.Id;
        equipementH.Audimetre__c = '235EDFIAA'; 
        listEquipementToInsert.add(equipementH);
        
        Asset equipementI = Test_Utils.createEquipement(testAccount.Id);
        equipementI.ContactId = compositionFoyer.Id;
        equipementI.Produit_commande__c = orderItemI.Id; 
        equipementI.Audimetre__c = '2311EDFMA'; 
        listEquipementToInsert.add(equipementI);
        
        Asset equipementJ = Test_Utils.createEquipement(testAccount.Id);
        equipementJ.ContactId = compositionFoyer.Id;
        equipementJ.Produit_commande__c = orderItemJ.Id;
        equipementJ.Audimetre__c = '237EDFMMA'; 
        listEquipementToInsert.add(equipementJ);
        
        insert listEquipementToInsert;
        System.debug('$$$Fin Insert');
        
        Test.startTest();        
        System.debug('$$$equipementA: ' + equipementA);
        System.debug('$$$Avant Cahngement');
        List<Asset> equipementClotureRequeteTestList = new List<Asset>();
        equipementA.Date_de_premiere_collecte_d_audience__c = Date.TODAY();
        equipementClotureRequeteTestList.add(equipementA);
        equipementF.Date_de_premiere_collecte_d_audience__c = Date.TODAY() -5;
        equipementClotureRequeteTestList.add(equipementF);
        equipementH.Date_de_premiere_collecte_d_audience__c = Date.TODAY();
        equipementClotureRequeteTestList.add(equipementH);
        equipementI.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 9;
        equipementClotureRequeteTestList.add(equipementI);
        equipementJ.Date_de_premiere_collecte_d_audience__c = Date.TODAY() - 5;
        equipementClotureRequeteTestList.add(equipementJ);
        System.debug('$$$Avant Update');
        
        update equipementClotureRequeteTestList;
            
         System.debug('Après Update equipementA: ' + equipementA);
        
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id));
        Test.stopTest();
        List<Case> requeteList = [SELECT Id, Subject, Status FROM Case];
        
        System.debug('requeteList: ' + requeteList);
         for (Case requete: requeteList) {
            if (requete.Subject == 'requeteMulti1') {
                System.assertEquals(Label.CAS_Statut_Cloture, requete.Status);
            }
            else if (requete.Subject == 'requeteDiffType') {
                System.assertEquals(Label.CAS_Statut_En_cours, requete.Status);
            }
            else if (requete.Subject == 'requeteCloture') {
                System.assertEquals(Label.CAS_Statut_Cloture, requete.Status);
            }
        }
        //System.assertEquals(Label.CAS_Statut_Cloture, requeteList[0].Status);
        
        }        
    }
    
    @isTest
    static void associerCaseContact() {
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        update u;
        
        System.runAs(u){
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        testAccount.Adresse_e_mail_principale__c = 'toto@toto.toto';
        listFoyersToInsert.add(testAccount);
        insert listFoyersToInsert;
        
        //Create composition foyer
        List<Contact> ListCompositionFoyerToInsert = new List<Contact>();
        Contact compositionFoyer = Test_Utils.createMembreFoyer(testAccount.Id);
        compositionFoyer.Lien_parente__c = '1';     
        compositionFoyer.Email = 'toto@toto.toto';
        ListCompositionFoyerToInsert.add(compositionFoyer);
        insert ListCompositionFoyerToInsert;
        
        //Create Requête
        List<Case> listRequeteToInsert = new List<Case>();
        //Requête avec plusieurs commandes/produits commandés
        Case requeteMulti1 = new Case();
        requeteMulti1.Subject = 'requeteMulti1'; 
        requeteMulti1.Status = Label.CAS_Statut_En_cours;
        requeteMulti1.Type = Label.CAS_Type_RemplacementMateriel;
        requeteMulti1.Origin = Label.CAS_Origine_Email;
        requeteMulti1.SuppliedEmail = 'toto@toto.toto';
        listRequeteToInsert.add(requeteMulti1);
                
        Case requeteMulti2 = new Case();
        requeteMulti2.Subject = 'requeteMulti2';
        requeteMulti2.Status = Label.CAS_Statut_En_cours;
        requeteMulti2.Type = Label.CAS_Type_RemplacementMateriel;
        requeteMulti2.Origin = Label.CAS_Origine_Email;
        requeteMulti2.SuppliedEmail = 'toto@toto.toto';
        listRequeteToInsert.add(requeteMulti2);               
        
        insert listRequeteToInsert;
        
        Test.startTest();         
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compositionFoyer.id));
        Test.stopTest();
    }
  } 
    public static testMethod void AP01_RequeteTest2(){
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount); 
        testAccount.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        insert listFoyersToInsert; 
        
        //create contact
        contact con = new contact();
        con.email='youssef.hamrouni@isimg.tn';
        con.Birthdate = date.newInstance(1993, 02, 25);
        con.LastName='youssef';
        con.Sexe__c='1';
        con.Lien_de_parente_stat__c='1';
		con.Lien_parente__c='1'; 
        con.Date_d_entree_individu__c=system.today();
        con.Type__c='1';
        con.Lettre__c='1';
        con.CSP42__c = '3';
        con.CON_ExtId_SIPanel__c = '1234';
        insert con;
        
        contact con1 = new contact();
        con1.email='youssef.hamrouni@isimg.tn';
        con1.LastName='maya';
        con1.Birthdate = date.newInstance(1993, 02, 25);
        con1.Sexe__c='2';
        con1.Lien_de_parente_stat__c='1';
		con1.Lien_parente__c='3'; 
        con1.Date_d_entree_individu__c=system.today();
        con1.Type__c='0';
        con1.Lettre__c='1';
        con1.CSP42__c = '5';
        con1.CON_ExtId_SIPanel__c = '5678';
        insert con1;
        
        
        List<Referentiel_Panel__c> refPanelList = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanelMMAT = new Referentiel_Panel__c();
        refPanelMMAT.Name = Label.RFP_Nom_MMAT;
        refPanelMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        refPanelList.add(refPanelMMAT);
        insert refPanelList;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelMediamatPame;
        foyerPaneliste.Referentiel_Panel__c = refPanelMMAT.Id;
        foyerPaneliste.Foyer__c = testAccount.Id;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
        
        //create case
        case cs= new case();
        cs.AccountId = testAccount.Id;
        cs.Foyer_paneliste__c = foyerPaneliste.Id;
        cs.Origin=	'Email entrant';
        cs.Status='Nouveau';
        insert cs;
         Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id));
    }
}