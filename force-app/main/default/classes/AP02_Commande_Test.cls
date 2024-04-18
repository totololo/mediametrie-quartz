/*
* @date: 19/10/2021
* @ Description Class qui teste AP02_Commande 
* @version 1.00   
* pourcentage : 95%
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> <Author> 	<Description of modification>
26/04/2022              Téoman Sertçelik   @coverage 93%
*/
@isTest
public class AP02_Commande_Test {
    @isTest
    static void AP02_SendOrder(){
        
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
        List<Boolean> resp = AP02_Commande.getOrder(listOrderId);
        Test.stopTest();
    }
    
    @isTest
    static void sendOrderTestTrigger(){
       
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelMediamatPame;
        foyerPaneliste.Foyer__c = testAccount.Id;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
       
        
        //Create Requête
        List<Case> listRequeteToInsert = new List<Case>();
        //Requête avec plusieurs commandes/produits commandés
        Case requeteMulti1 = Test_Utils.createCase(testAccount.Id);
        requeteMulti1.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti1.Subject = 'requeteMulti1';
        requeteMulti1.Status = Label.CAS_Statut_En_cours;
        requeteMulti1.Type = Label.CAS_Type_Anomalie_Materiel;
        listRequeteToInsert.add(requeteMulti1);
        
        Case requeteMulti2 = Test_Utils.createCase(testAccount.Id);
        requeteMulti2.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti2.Subject = 'requeteMulti2';
        requeteMulti2.Status = Label.CAS_Statut_En_cours;
        requeteMulti2.Type = Label.CAS_Type_Anomalie_Materiel;
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
        requeteCloture.Type = Label.CAS_Type_Anomalie_Materiel;
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
        
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
        AP02_Commande.sendOrderTrigger(listCommandeToInsert);
        Test.stopTest();
    }
    
        @isTest
    static void sendOrderChuteTestTrigger(){
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelMediamatPame;
        foyerPaneliste.Foyer__c = testAccount.Id;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
       
        
        //Create Requête
        List<Case> listRequeteToInsert = new List<Case>();
        //Requête avec plusieurs commandes/produits commandés
        Case requeteMulti1 = Test_Utils.createCase(testAccount.Id);
        requeteMulti1.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti1.Subject = 'requeteMulti1';
        requeteMulti1.Status = Label.CAS_Statut_En_cours;
        requeteMulti1.Type = Label.CAS_Type_Chute;
        requeteMulti1.Motif_de_chute__c = 'Ondes';
        requeteMulti1.Chute_confirmee__c = true;
        listRequeteToInsert.add(requeteMulti1);
        
        Case requeteMulti2 = Test_Utils.createCase(testAccount.Id);
        requeteMulti2.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti2.Subject = 'requeteMulti2';
        requeteMulti2.Status = Label.CAS_Statut_En_cours;
        requeteMulti2.Type = Label.CAS_Type_Anomalie_Materiel;
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
        requeteCloture.Type = Label.CAS_Type_Anomalie_Materiel;
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
        commandeMulti11.Type=label.Ord_Type_PackChute;
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
        
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
        AP02_Commande.sendOrderTrigger(listCommandeToInsert);
        Test.stopTest();
    }
}