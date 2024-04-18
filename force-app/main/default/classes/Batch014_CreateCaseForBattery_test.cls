/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 20/07/2021
* @Classe: Batch014_CreateCaseForBattery
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*		11/01/2022			Ayoub GHAMMAZ			ajout de la methode testBatchCreationControle2 & creation d'une requete controle AIP dans la methode testBatchCreationControle (ligne 105)
*/
@isTest
public class Batch014_CreateCaseForBattery_test {
    
    @isTest static void testBatchCreationControle() {
        user u = [select id from user where isactive =true and  name like 'admin%' limit 1];
        u.Bypass_flows__c=true;
        update u;
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        system.runas(u){
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyerList.add(foyer2);
        
        Account foyer3 = new Account();
        foyer3.Name = 'foyer3';
        foyerList.add(foyer3);
        
        Account foyer4 = new Account();
        foyer4.Name = 'foyer4';
        foyerList.add(foyer4);
        
        Account foyer5 = new Account();
        foyer5.Name = 'foyer5';
        foyerList.add(foyer5);
        
        insert foyerList;
        
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste11);
        
        
        
        Foyer_paneliste__c foyerPaneliste12 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste12.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste12.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste12);
        
        Foyer_paneliste__c foyerPaneliste21 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste21.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste21.Foyer__c = foyer3.Id;
        foyerPanelisteList.add(foyerPaneliste21);
        
        Foyer_paneliste__c foyerPaneliste4 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste4.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste4.Foyer__c = foyer4.Id;
        foyerPanelisteList.add(foyerPaneliste4);        
        
        Foyer_paneliste__c foyerPaneliste5 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste5.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste5.Foyer__c = foyer5.Id;
        foyerPanelisteList.add(foyerPaneliste5); 
        
        /*
Foyer_paneliste__c foyerPaneliste22 = Test_Utils.createFoyerPaneliste();
foyerPaneliste22.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste22.Foyer__c = foyer2.Id;
foyerPanelisteList.add(foyerPaneliste22);

Foyer_paneliste__c foyerPaneliste23 = Test_Utils.createFoyerPaneliste();
foyerPaneliste23.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste23.Foyer__c = foyer2.Id;
foyerPanelisteList.add(foyerPaneliste23);

Foyer_paneliste__c foyerPaneliste31 = Test_Utils.createFoyerPaneliste();
foyerPaneliste31.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste31.Foyer__c = foyer3.Id;
foyerPanelisteList.add(foyerPaneliste31);

Foyer_paneliste__c foyerPaneliste32 = Test_Utils.createFoyerPaneliste();
foyerPaneliste32.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste32.Foyer__c = foyer3.Id;
foyerPanelisteList.add(foyerPaneliste32);

Foyer_paneliste__c foyerPaneliste41 = Test_Utils.createFoyerPaneliste();
foyerPaneliste41.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste41.Foyer__c = foyer4.Id;
foyerPanelisteList.add(foyerPaneliste41);

Foyer_paneliste__c foyerPaneliste42 = Test_Utils.createFoyerPaneliste();
foyerPaneliste42.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste42.Foyer__c = foyer4.Id;
foyerPanelisteList.add(foyerPaneliste42);

Foyer_paneliste__c foyerPaneliste43 = Test_Utils.createFoyerPaneliste();
foyerPaneliste43.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste43.Foyer__c = foyer4.Id;
foyerPanelisteList.add(foyerPaneliste43);

Foyer_paneliste__c foyerPaneliste51 = Test_Utils.createFoyerPaneliste();
foyerPaneliste51.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste51.Foyer__c = foyer5.Id;
foyerPanelisteList.add(foyerPaneliste51);

Foyer_paneliste__c foyerPaneliste52 = Test_Utils.createFoyerPaneliste();
foyerPaneliste52.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste52.Foyer__c = foyer5.Id;
foyerPanelisteList.add(foyerPaneliste52);*/
        
        insert foyerPanelisteList;
        
        // ajouter par AYoub pour tester les modifications du 11/01/2022 
        Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        List<Case> caseToInsert = new List<Case>();
        case newCase = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
                                Foyer_paneliste__c=foyerPaneliste12.id,
                                AccountId=foyer2.Id,
                                type=Label.CTRL_LL_Type_Controle_Beacon,
                                Sous_type__c=Label.CAS_SousType_TousBeaconsInactifs,
                                Status =label.CAS_Statut_Nouveau
                               );
        
        caseToInsert.add(newCase);
        
        case newCase2 = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
                                 Foyer_paneliste__c=foyerPaneliste4.id,
                                 AccountId=foyer4.Id,
                                 type=Label.CTRL_LL_Type_Controle_Beacon,
                                 Sous_type__c=Label.CAS_SousType_TousBeaconsInactifs,
                                 Status =label.CAS_Statut_Nouveau
                                );        
        caseToInsert.add(newCase2);
        insert caseToInsert;
        /*Asset asset12 = Test_Utils.createEquipement(foyer1.Id);
asset12.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset12.Batterie__c = 0;
asset12.Foyer_paneliste__c = foyerPaneliste12.Id;
asset12.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset12.Date_de_derniere_detection__c = Date.today() - 42;
equipementDuFoyerList.add(asset12);

Asset asset21 = Test_Utils.createEquipement(foyer2.Id);
asset21.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset21.Batterie__c = 96;
asset21.Foyer_paneliste__c = foyerPaneliste21.Id;
asset21.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset21.Date_de_derniere_detection__c = Date.today() - 35;
equipementDuFoyerList.add(asset21);

Asset asset22 = Test_Utils.createEquipement(foyer2.Id);
asset22.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset22.Batterie__c = 50;
asset22.Foyer_paneliste__c = foyerPaneliste22.Id;
asset22.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset22.Date_de_derniere_detection__c = Date.today() - 14;
equipementDuFoyerList.add(asset22);

Asset asset23 = Test_Utils.createEquipement(foyer2.Id);
asset23.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset23.Batterie__c = 0;
asset23.Foyer_paneliste__c = foyerPaneliste22.Id;
asset23.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset23.Date_de_derniere_detection__c = Date.today() - 61;
equipementDuFoyerList.add(asset23);


Asset asset24 = Test_Utils.createEquipement(foyer2.Id);
asset24.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset24.Batterie__c = 50;
asset24.Foyer_paneliste__c = foyerPaneliste23.Id;
asset24.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset24.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset24);

Asset asset31 = Test_Utils.createEquipement(foyer3.Id);
asset31.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset31.Batterie__c = 19;
asset31.Foyer_paneliste__c = foyerPaneliste31.Id;
asset31.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset31.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset31);

Asset asset32 = Test_Utils.createEquipement(foyer3.Id);
asset32.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset32.Batterie__c = 12;
asset32.Foyer_paneliste__c = foyerPaneliste32.Id;
asset32.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset32.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset32);

Asset asset41 = Test_Utils.createEquipement(foyer4.Id);
asset41.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset41.Batterie__c = 16;
asset41.Foyer_paneliste__c = foyerPaneliste41.Id;
asset41.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset41.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset41);

Asset asset42 = Test_Utils.createEquipement(foyer4.Id);
asset42.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset42.Batterie__c = 38;
asset42.Foyer_paneliste__c = foyerPaneliste42.Id;
asset42.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset42.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset42);

Asset asset43 = Test_Utils.createEquipement(foyer4.Id);
asset43.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset43.Batterie__c = 66;
asset43.Foyer_paneliste__c = foyerPaneliste43.Id;
asset43.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset43.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset43);

Asset asset51 = Test_Utils.createEquipement(foyer5.Id);
asset51.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset51.Batterie__c = 78;
asset51.Foyer_paneliste__c = foyerPaneliste51.Id;
asset51.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset51.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset51);

Asset asset52 = Test_Utils.createEquipement(foyer5.Id);
asset52.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset52.Batterie__c = 43;
asset52.Foyer_paneliste__c = foyerPaneliste52.Id;
asset52.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset52.Date_de_derniere_detection__c = Date.today();
equipementDuFoyerList.add(asset52);*/
        
        List<Product2> listProduitToInsert = new List<Product2>();
        Product2 produit1 = Test_Utils.createproduct();
        produit1.Name = 'Produit1';
        produit1.IsActive = True;
        produit1.Type_de_produit__c = label.Pro_type_Beacon;
        produit1.Code_article_prestataire__c=label.PROD_Code_article_prestataire_Beacon_V1;
        listProduitToInsert.add(produit1);

   		Product2 produit1Pager = Test_Utils.createproduct();
        produit1Pager.Name = 'Produit1Pager';
        produit1Pager.IsActive = True;
        produit1Pager.Type_de_produit__c = label.Pro_type_Pager;
        listProduitToInsert.add(produit1Pager);
        
        Product2 produit2 = Test_Utils.createproduct();
        produit2.Name = 'Produit2';
        produit2.IsActive = True;
        produit2.Type_de_produit__c = label.Pro_type_Beacon;
        produit2.Code_article_prestataire__c=label.PROD_Code_article_prestataire_Beacon_V2;
        listProduitToInsert.add(produit2);
        
        Product2 produit2Pager = Test_Utils.createproduct();
        produit2Pager.Name = 'Produit2Pager';
        produit2Pager.IsActive = True;
        produit2Pager.Type_de_produit__c = label.Pro_type_Pager;
        listProduitToInsert.add(produit2Pager);
        
        Product2 produit3 = Test_Utils.createproduct();
        produit3.Name = 'Produit3';
        produit3.IsActive = True;
        produit3.Type_de_produit__c = label.Pro_type_Beacon;
        produit3.Code_article_prestataire__c=label.PROD_Code_article_prestataire_Beacon_V2;
        listProduitToInsert.add(produit3);
        
        Product2 produit3Pager = Test_Utils.createproduct();
        produit3Pager.Name = 'Produit3Pager';
        produit3Pager.IsActive = True;
        produit3Pager.Type_de_produit__c = label.Pro_type_Pager;
        listProduitToInsert.add(produit3Pager);
        
        Product2 produit4 = Test_Utils.createproduct();
        produit4.Name = 'Produit4';
        produit4.IsActive = True;
        produit4.Type_de_produit__c = label.Pro_type_Beacon;
        produit4.Code_article_prestataire__c=label.PROD_Code_article_prestataire_Beacon_V1;
        listProduitToInsert.add(produit4);
        
         Product2 produit4Pager = Test_Utils.createproduct();
        produit4Pager.Name = 'produit4Pager';
        produit4Pager.IsActive = True;
        produit4Pager.Type_de_produit__c = label.Pro_type_Pager;
        listProduitToInsert.add(produit4Pager);
        
        Product2 produit5 = Test_Utils.createproduct();
        produit5.Name = 'Produit5';
        produit5.IsActive = True;
        produit5.Type_de_produit__c = label.Pro_type_Beacon;
        produit5.Code_article_prestataire__c=label.PROD_Code_article_prestataire_Beacon_V1;
        listProduitToInsert.add(produit5);
        
        Product2 produit5Pager = Test_Utils.createproduct();
        produit5Pager.Name = 'produit5Pager';
        produit5Pager.IsActive = True;
        produit5Pager.Type_de_produit__c = label.Pro_type_Pager;
        listProduitToInsert.add(produit5Pager);
        
        insert listProduitToInsert;
        
        List<PricebookEntry> listPricebookEntryToInsert = new List<PricebookEntry>();
        PricebookEntry standardPbEntry1 = new PricebookEntry();
        standardPbEntry1.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry1.UnitPrice = 10;
        standardPbEntry1.Product2Id = produit1.id;
        listPricebookEntryToInsert.add(standardPbEntry1);
        
        PricebookEntry standardPbEntry1pager = new PricebookEntry();
        standardPbEntry1pager.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry1pager.UnitPrice = 10;
        standardPbEntry1pager.Product2Id = produit1Pager.id;
        listPricebookEntryToInsert.add(standardPbEntry1pager);
        
        PricebookEntry standardPbEntry2 = new PricebookEntry();
        standardPbEntry2.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry2.UnitPrice = 10;
        standardPbEntry2.Product2Id = produit2.id;
        listPricebookEntryToInsert.add(standardPbEntry2);
        
         PricebookEntry standardPbEntry2Pager = new PricebookEntry();
        standardPbEntry2Pager.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry2Pager.UnitPrice = 10;
        standardPbEntry2Pager.Product2Id = produit2Pager.id;
        listPricebookEntryToInsert.add(standardPbEntry2Pager);
        
        PricebookEntry standardPbEntry3 = new PricebookEntry();
        standardPbEntry3.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry3.UnitPrice = 10;
        standardPbEntry3.Product2Id = produit3.id;
        listPricebookEntryToInsert.add(standardPbEntry3);
        
		PricebookEntry standardPbEntry3Pager = new PricebookEntry();
        standardPbEntry3Pager.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry3Pager.UnitPrice = 10;
        standardPbEntry3Pager.Product2Id = produit3Pager.id;
        listPricebookEntryToInsert.add(standardPbEntry3Pager);
        
        PricebookEntry standardPbEntry4 = new PricebookEntry();
        standardPbEntry4.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry4.UnitPrice = 10;
        standardPbEntry4.Product2Id = produit4.id;
        listPricebookEntryToInsert.add(standardPbEntry4);
        
		PricebookEntry standardPbEntry4Pager = new PricebookEntry();
        standardPbEntry4Pager.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry4Pager.UnitPrice = 10;
        standardPbEntry4Pager.Product2Id = produit4Pager.id;
        listPricebookEntryToInsert.add(standardPbEntry4Pager);
        
        PricebookEntry standardPbEntry5 = new PricebookEntry();
        standardPbEntry5.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry5.UnitPrice = 10;
        standardPbEntry5.Product2Id = produit5.id;
        listPricebookEntryToInsert.add(standardPbEntry5);
        
		PricebookEntry standardPbEntry5Pager = new PricebookEntry();
        standardPbEntry5Pager.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry5Pager.UnitPrice = 10;
        standardPbEntry5Pager.Product2Id = produit5Pager.id;
        listPricebookEntryToInsert.add(standardPbEntry5Pager);
                
        insert listPricebookEntryToInsert;
        
        List<Order> listCommandeToInsert = new List<Order>();
        Order commandeMulti11 = Test_Utils.createOrder(foyer1.Id);
        //commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti11.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti11.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti11.EffectiveDate = Date.Today() - 10;
        commandeMulti11.Date_d_expedition__c = Date.Today() - 4;
        commandeMulti11.Foyer_paneliste__c = foyerPaneliste11.Id;
        listCommandeToInsert.add(commandeMulti11);
        
        Order commandeMulti12 = Test_Utils.createOrder(foyer2.Id);
        //commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti12.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti12.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti12.EffectiveDate = Date.Today() - 10;
        commandeMulti12.Date_d_expedition__c = Date.Today() - 4;
        commandeMulti12.Foyer_paneliste__c = foyerPaneliste12.Id;
        listCommandeToInsert.add(commandeMulti12);
        
        Order commandeMulti3 = Test_Utils.createOrder(foyer3.Id);
        //commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti3.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti3.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti3.EffectiveDate = Date.Today() - 10;
        commandeMulti3.Date_d_expedition__c = Date.Today() - 4;
        commandeMulti3.Foyer_paneliste__c = foyerPaneliste21.Id;
        listCommandeToInsert.add(commandeMulti3);
        
        Order commandeMulti4 = Test_Utils.createOrder(foyer4.Id);
        //commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti4.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti4.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti4.EffectiveDate = Date.Today() - 10;
        commandeMulti4.Date_d_expedition__c = Date.Today() - 4;
        commandeMulti4.Foyer_paneliste__c = foyerPaneliste4.Id;
        listCommandeToInsert.add(commandeMulti4);
        
        Order commandeMulti5 = Test_Utils.createOrder(foyer5.Id);
        //commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti5.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti5.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti5.EffectiveDate = Date.Today() - 10;
        commandeMulti5.Date_d_expedition__c = Date.Today() - 4;
        commandeMulti5.Foyer_paneliste__c = foyerPaneliste5.Id;
        listCommandeToInsert.add(commandeMulti5);
        
        insert listCommandeToInsert;
        
        
        List<OrderItem> listProduitCommandeToInsert = new List<OrderItem>();
        OrderItem orderItemA = Test_Utils.createOrderItem();
        orderItemA.orderId = commandeMulti11.Id;
        orderItemA.Product2Id = produit1.Id;
        orderItemA.Quantity = 1;
        orderItemA.UnitPrice = 10;
        orderItemA.pricebookEntryId = standardPbEntry1.Id;
        listProduitCommandeToInsert.add(orderItemA);
        
        OrderItem orderItemB = Test_Utils.createOrderItem();
        orderItemB.orderId = commandeMulti12.Id;
        orderItemB.Product2Id = produit2.Id;
        orderItemB.Quantity = 1;
        orderItemB.UnitPrice = 10;
        orderItemB.pricebookEntryId = standardPbEntry2.Id;
        listProduitCommandeToInsert.add(orderItemB);
        
        OrderItem orderItemC = Test_Utils.createOrderItem();
        orderItemC.orderId = commandeMulti3.Id;
        orderItemC.Product2Id = produit3.Id;
        orderItemC.Quantity = 1;
        orderItemC.UnitPrice = 10;
        orderItemC.pricebookEntryId = standardPbEntry3.Id;
        listProduitCommandeToInsert.add(orderItemC);
        
        OrderItem orderItemD = Test_Utils.createOrderItem();
        orderItemD.orderId = commandeMulti4.Id;
        orderItemD.Product2Id = produit4.Id;
        orderItemD.Quantity = 1;
        orderItemD.UnitPrice = 10;
        orderItemD.pricebookEntryId = standardPbEntry4.Id;
        listProduitCommandeToInsert.add(orderItemD);
        
        OrderItem orderItemE = Test_Utils.createOrderItem();
        orderItemE.orderId = commandeMulti5.Id;
        orderItemE.Product2Id = produit5.Id;
        orderItemE.Quantity = 1;
        orderItemE.UnitPrice = 10;
        orderItemE.pricebookEntryId = standardPbEntry5.Id;
        listProduitCommandeToInsert.add(orderItemE);
        insert listProduitCommandeToInsert;
        
        List<Asset> equipementDuFoyerList = new List<Asset>();
        Asset asset11 = Test_Utils.createEquipement(foyer1.Id);
        asset11.Name='asset11';
        asset11.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset11.Batterie__c = 10;
        asset11.Audimetre__c = '123';
        asset11.Foyer_paneliste__c = foyerPaneliste11.Id;
        asset11.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset11.Date_de_derniere_detection__c = Date.today() - 33;
        asset11.Product2Id = produit1.Id;
        asset11.Produit_commande__c= orderItemA.Id;
        asset11.Date_d_affectation__c = Date.Today() - 4;
        
        Asset asset11pager = Test_Utils.createEquipement(foyer1.Id);
        asset11pager.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset11pager.Batterie__c = 10;
        asset11pager.Name='11';
        asset11pager.Audimetre__c = '123pager';
        asset11pager.Foyer_paneliste__c = foyerPaneliste11.Id;
        asset11pager.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset11pager.Date_de_premiere_collecte_d_audience__c  = Date.today() - 33;
        asset11pager.Product2Id = produit1.Id;
        asset11pager.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset11);
        equipementDuFoyerList.add(asset11pager);
        
        Asset asset12 = Test_Utils.createEquipement(foyer2.Id);
        asset12.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset12.Batterie__c = 10;
        asset12.Name='12';
        asset12.Audimetre__c = '1233';
        asset12.Foyer_paneliste__c = foyerPaneliste12.Id;
        asset12.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset12.Date_de_derniere_detection__c = Date.today() - 33;
        asset12.Product2Id = produit2.Id;
        asset12.Produit_commande__c= orderItemB.Id;
        asset12.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset12);
        
         Asset asset12Pager = Test_Utils.createEquipement(foyer2.Id);
        asset12Pager.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset12Pager.Batterie__c = 10;
        asset12Pager.Name='123';
        asset12Pager.Audimetre__c = '1233Pager';
        asset12Pager.Foyer_paneliste__c = foyerPaneliste12.Id;
        asset12Pager.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset12Pager.Date_de_premiere_collecte_d_audience__c  = Date.today() - 33;
        asset12Pager.Date_de_derniere_detection__c = Date.today() - 33;
        asset12Pager.Product2Id = produit2Pager.Id;
        asset12Pager.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset12Pager);
        
        
        Asset asset13 = Test_Utils.createEquipement(foyer3.Id);
        asset13.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset13.Batterie__c = 13;
        asset13.Name='asset13';
        asset13.Audimetre__c = '12133';
        asset13.Foyer_paneliste__c = foyerPaneliste21.Id;
        asset13.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset13.Date_de_derniere_detection__c = Date.today() - 1096;
        asset13.Product2Id = produit3.Id;
        asset13.Produit_commande__c= orderItemC.Id;
        asset13.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset13);
        
         Asset asset13Pager = Test_Utils.createEquipement(foyer3.Id);
        asset13Pager.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset13Pager.Batterie__c = 10;
        asset13Pager.Name='asset13Pager';
        asset13Pager.Audimetre__c = '12133Pager';
        asset13Pager.Foyer_paneliste__c = foyerPaneliste21.Id;
        asset13Pager.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset13Pager.Date_de_premiere_collecte_d_audience__c  = Date.today() - 33;
        asset13Pager.Date_de_derniere_detection__c = Date.today() - 33;
        asset13Pager.Product2Id = produit3Pager.Id;
        asset13Pager.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset13Pager);
        
        Asset asset4 = Test_Utils.createEquipement(foyer4.Id);
        asset4.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset4.Batterie__c = 27;
        asset4.Name='asset4';
        asset4.Audimetre__c = '121333';
        asset4.Foyer_paneliste__c = foyerPaneliste4.Id;
        asset4.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset4.Date_de_derniere_detection__c = Date.today() - 366;
        asset4.Product2Id = produit4.Id;
        asset4.Produit_commande__c= orderItemD.Id;
        asset4.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset4);
        
         Asset asset14Pager = Test_Utils.createEquipement(foyer4.Id);
        asset14Pager.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset14Pager.Batterie__c = 10;
        asset14Pager.Name='asset14Pager';
        asset14Pager.Audimetre__c = '121333Pager';
        asset14Pager.Foyer_paneliste__c = foyerPaneliste4.Id;
        asset14Pager.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset14Pager.Date_de_premiere_collecte_d_audience__c  = Date.today() - 33;
        asset14Pager.Date_de_derniere_detection__c = Date.today() - 33;
        asset14Pager.Product2Id = produit4Pager.Id;
        asset14Pager.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset14Pager);

        Asset asset5 = Test_Utils.createEquipement(foyer5.Id);
        asset5.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset5.Batterie__c = 0;
        asset5.Name='asset5';
        asset5.Audimetre__c = '12133333';
        asset5.Foyer_paneliste__c = foyerPaneliste5.Id;
        asset5.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset5.Date_de_derniere_detection__c = Date.today() - 70;
        asset5.Product2Id = produit5.Id;
        asset5.Produit_commande__c= orderItemE.Id;
        asset5.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset5);
        
         Asset asset15Pager = Test_Utils.createEquipement(foyer4.Id);
        asset15Pager.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset15Pager.Batterie__c = 10;
            asset15Pager.Name='asset15Pager';
        asset15Pager.Audimetre__c = '12133333Pager';
        asset15Pager.Foyer_paneliste__c = foyerPaneliste5.Id;
        asset15Pager.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset15Pager.Date_de_premiere_collecte_d_audience__c  = Date.today() - 33;
        asset15Pager.Date_de_derniere_detection__c = Date.today() - 33;
        asset15Pager.Product2Id = produit5Pager.Id;
        asset15Pager.Date_d_affectation__c = Date.Today() - 4;
        
        equipementDuFoyerList.add(asset15Pager);  
        
        insert equipementDuFoyerList;
        
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id)); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer2.id)); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer3.id)); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer4.id)); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer5.id));
        Batch014_CreateCaseForBattery bccfb = new Batch014_CreateCaseForBattery();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        
        
        List<Controle__c> controleList = [SELECT Id, foyer__c, Sous_type_de_controle__c FROM Controle__c];
        //System.assertEquals(4, controleList.size());
        for(Controle__c controle:controleList) {
            if (controle.foyer__c == foyer1.Id) {
                System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Moins_20, controle.Sous_type_de_controle__c);
            }
            else if (controle.foyer__c == foyer2.Id) {
                System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Moins_20, controle.Sous_type_de_controle__c);
            }
            else if (controle.foyer__c == foyer3.Id) {
                System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Inactifs, controle.Sous_type_de_controle__c);
            }
            else if (controle.foyer__c == foyer4.Id) {
                System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Inactifs, controle.Sous_type_de_controle__c);
            }
            else if (controle.foyer__c == foyer5.Id) {
                System.assertEquals(Label.CTRL_SousType_Au_Moins_Un_Beacon_Inactif, controle.Sous_type_de_controle__c);
            }
        }
    }
    
    /*@isTest static void testBatchCreationControle2() {

Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();

List<Account> foyerList = new List<Account>();

Account foyer1 = new Account();
foyer1.Name = 'Foyer1';
foyerList.add(foyer1);

Account foyer2 = new Account();
foyer2.Name = 'Foyer2';
foyerList.add(foyer2);

insert foyerList;


List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste11.Foyer__c = foyer1.Id;
foyerPaneliste11.Date_de_premiere_collecte__c =date.newInstance(2021, 05, 28);
foyerPanelisteList.add(foyerPaneliste11);


Foyer_paneliste__c foyerPaneliste12 = Test_Utils.createFoyerPaneliste();
foyerPaneliste12.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
foyerPaneliste12.Foyer__c = foyer2.Id;
foyerPaneliste12.Date_de_premiere_collecte__c =date.newInstance(2021, 05, 28);
foyerPanelisteList.add(foyerPaneliste12);


insert foyerPanelisteList;

// ajouter par AYoub pour tester les modifications du 11/01/2022 
Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
List<Case> caseToInsert = new List<Case>();
case newCase = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
Foyer_paneliste__c=foyerPaneliste12.id,
AccountId=foyer2.Id,
type=Label.CTRL_LL_Type_Controle_Beacon,
Sous_type__c=Label.CAS_SousType_TousBeaconsInactifs,
Status =label.CAS_Statut_Nouveau
);

caseToInsert.add(newCase);

List<Product2> listProduitToInsert = new List<Product2>();
Product2 produit1 = Test_Utils.createproduct();
produit1.Name = 'Produit1';
produit1.IsActive = True;
produit1.Type_de_produit__c = label.Pro_type_Beacon;
produit1.Version__c = Label.PROD_Version_V1;
listProduitToInsert.add(produit1);

Product2 produit2 = Test_Utils.createproduct();
produit2.Name = 'Produit2';
produit2.IsActive = True;
produit2.Type_de_produit__c = label.Pro_type_Beacon;
produit2.Version__c = Label.PROD_Version_V2;
listProduitToInsert.add(produit2);

Product2 produit3 = Test_Utils.createproduct();
produit3.Name = 'Produit3';
produit3.IsActive = True;
produit3.Type_de_produit__c = label.Pro_type_Beacon;
produit3.Version__c = Label.PROD_Version_V2;
listProduitToInsert.add(produit3);

Product2 produit4 = Test_Utils.createproduct();
produit4.Name = 'Produit4';
produit4.IsActive = True;
produit4.Type_de_produit__c = label.Pro_type_Beacon;
produit4.Version__c = Label.PROD_Version_V1;
listProduitToInsert.add(produit4);

Product2 produit5 = Test_Utils.createproduct();
produit5.Name = 'Produit5';
produit5.IsActive = True;
produit5.Type_de_produit__c = label.Pro_type_Beacon;
produit5.Version__c = Label.PROD_Version_V1;
listProduitToInsert.add(produit5);

insert listProduitToInsert;

List<Asset> equipementDuFoyerList = new List<Asset>();
Asset asset11 = Test_Utils.createEquipement(foyer1.Id);
asset11.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset11.Batterie__c = 10;
asset11.Audimetre__c = '123';
asset11.Foyer_paneliste__c = foyerPaneliste11.Id;
asset11.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset11.Date_de_derniere_detection__c = Date.today() - 33;
asset11.Product2Id = produit1.Id;
asset11.Date_d_affectation__c = Date.Today() - 10;

equipementDuFoyerList.add(asset11);


Asset asset12 = Test_Utils.createEquipement(foyer2.Id);
asset12.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
asset12.Batterie__c = 10;
asset12.Audimetre__c = '1233';
asset12.Foyer_paneliste__c = foyerPaneliste12.Id;
asset12.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
asset12.Date_de_derniere_detection__c = Date.today() - 33;
asset12.Product2Id = produit2.Id;
asset12.Date_d_affectation__c = Date.Today() - 10;

equipementDuFoyerList.add(asset12);




insert equipementDuFoyerList;

List<PricebookEntry> listPricebookEntryToInsert = new List<PricebookEntry>();
PricebookEntry standardPbEntry1 = new PricebookEntry();
standardPbEntry1.Pricebook2Id = Test.getStandardPricebookId();
standardPbEntry1.UnitPrice = 10;
standardPbEntry1.Product2Id = produit1.id;
listPricebookEntryToInsert.add(standardPbEntry1);

PricebookEntry standardPbEntry2 = new PricebookEntry();
standardPbEntry2.Pricebook2Id = Test.getStandardPricebookId();
standardPbEntry2.UnitPrice = 10;
standardPbEntry2.Product2Id = produit2.id;
listPricebookEntryToInsert.add(standardPbEntry2);

insert listPricebookEntryToInsert;

List<Order> listCommandeToInsert = new List<Order>();
Order commandeMulti11 = Test_Utils.createOrder(foyer1.Id);
//commandeMulti11.Requete__c = requeteMulti1.Id;
commandeMulti11.Status = Label.Ord_Status_VersionPreliminaire;
commandeMulti11.Pricebook2Id = Test.getStandardPricebookId();
commandeMulti11.EffectiveDate = Date.Today() - 10;
commandeMulti11.Date_d_expedition__c = Date.Today() - 10;
commandeMulti11.Foyer_paneliste__c = foyerPaneliste11.Id;
listCommandeToInsert.add(commandeMulti11);

Order commandeMulti12 = Test_Utils.createOrder(foyer2.Id);
//commandeMulti11.Requete__c = requeteMulti1.Id;
commandeMulti12.Status = Label.Ord_Status_VersionPreliminaire;
commandeMulti12.Pricebook2Id = Test.getStandardPricebookId();
commandeMulti12.EffectiveDate = Date.Today() - 10;
commandeMulti12.Date_d_expedition__c = Date.Today() - 10;
commandeMulti12.Foyer_paneliste__c = foyerPaneliste12.Id;
listCommandeToInsert.add(commandeMulti12);


insert listCommandeToInsert;


List<OrderItem> listProduitCommandeToInsert = new List<OrderItem>();
OrderItem orderItemA = Test_Utils.createOrderItem();
orderItemA.orderId = commandeMulti11.Id;
orderItemA.Product2Id = produit1.Id;
orderItemA.Quantity = 1;
orderItemA.UnitPrice = 10;
orderItemA.pricebookEntryId = standardPbEntry1.Id;
listProduitCommandeToInsert.add(orderItemA);

OrderItem orderItemB = Test_Utils.createOrderItem();
orderItemB.orderId = commandeMulti12.Id;
orderItemB.Product2Id = produit2.Id;
orderItemB.Quantity = 1;
orderItemB.UnitPrice = 10;
orderItemB.pricebookEntryId = standardPbEntry2.Id;
listProduitCommandeToInsert.add(orderItemB);

insert listProduitCommandeToInsert;



Test.startTest(); 
Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id)); 
Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer2.id));

Batch014_CreateCaseForBattery bccfba = new Batch014_CreateCaseForBattery();
Id batchId2 = Database.executeBatch(bccfba);

Batch014_CreateCaseForBattery bccfb = new Batch014_CreateCaseForBattery();
Id batchId = Database.executeBatch(bccfb);
Test.stopTest();



List<Controle__c> controleList = [SELECT Id, foyer__c, Sous_type_de_controle__c FROM Controle__c];
System.debug('bastien : ' + controleList.size());
System.assertEquals(2, controleList.size());
for(Controle__c controle:controleList) {
if (controle.foyer__c == foyer1.Id) {
System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Moins_20, controle.Sous_type_de_controle__c);
}
else if (controle.foyer__c == foyer2.Id) {
System.assertEquals(Label.CTRL_SousType_Tous_Beacons_Moins_20, controle.Sous_type_de_controle__c);
}

}*/
}
}