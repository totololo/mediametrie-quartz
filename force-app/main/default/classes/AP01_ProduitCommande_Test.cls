/*
* @date: 28/03/2023
* @ Description Class qui teste AP01_ProduitCommande 
* @version 1.00   
* pourcentage : 
* @Auteur Bastien Pinard
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP01_ProduitCommande_Test {
    @isTest
    static void creerCommandePackRemplacementMaterielTest(){
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
      
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
        

        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Nouvelle Intervention foyer panéliste';
        foyerPaneliste.RecordTypeId = recordTypeIdPanelAIP;
        foyerPaneliste.Foyer__c = testAccount.Id;
        foyerPaneliste.Nombre_de_beacons__c =1;
        foyerPaneliste.Nombre_de_set_meters__c = 1;
        foyerPaneliste.Referentiel_Panel__c = refPanAIP.Id;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
        
        
        
        //Create Requête
        List<Case> listRequeteToInsert = new List<Case>();
        //Requête avec plusieurs commandes/produits commandés
        Case requeteMulti1 = Test_Utils.createCase(testAccount.Id);
        requeteMulti1.Foyer_paneliste__c = foyerPaneliste.Id;
        requeteMulti1.Subject = 'requeteMulti1';
        requeteMulti1.Status = Label.CAS_Statut_En_cours;
        requeteMulti1.Type = Label.CAS_Type_RemplacementMateriel;
        listRequeteToInsert.add(requeteMulti1);
        
        insert listRequeteToInsert;
        
        //Create Produit
        List<Product2> listProduitToInsert = new List<Product2>();
        Product2 produit1 = Test_Utils.createproduct();
        produit1.Name = 'Produit1';
        produit1.IsActive = True;
        produit1.Remplacement_materiel__c = True;
        produit1.Type_de_produit__c=Label.Pro_type_Beacon;
        produit1.Family=label.PRO_Family_AIP;
        listProduitToInsert.add(produit1);
        
        Product2 produit2 = Test_Utils.createproduct();
        produit2.Name = 'usb';
        produit2.IsActive = True;
        produit2.Remplacement_materiel__c = True;
        produit2.Type_de_produit__c=Label.Pro_type_SetMeter;
        produit2.Family=label.PRO_Family_AIP;
        listProduitToInsert.add(produit2);
        
        Product2 produit3 = Test_Utils.createproduct();
        produit3.Name = 'prod';
        produit3.IsActive = True;
        produit3.Remplacement_materiel__c = True;
        produit3.Family=label.PRO_Family_AIP;
        listProduitToInsert.add(produit3);
        
        Product2 produit4 = Test_Utils.createproduct();
        produit4.Name = 'cordon cou';
        produit4.IsActive = True;
        produit4.Remplacement_materiel__c = True;
        produit4.Family=label.PRO_Family_AIP;
        listProduitToInsert.add(produit4);
        
        insert listProduitToInsert;
        //Create PricebookEntry
        List<PricebookEntry> listPricebookEntryToInsert = new List<PricebookEntry>();
        PricebookEntry standardPbEntry1 = new PricebookEntry();
        standardPbEntry1.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry1.UnitPrice = 10;
        standardPbEntry1.Product2Id = produit1.id;
        standardPbEntry1.IsActive=true;
        listPricebookEntryToInsert.add(standardPbEntry1);
        
        PricebookEntry standardPbEntry2 = new PricebookEntry();
        standardPbEntry2.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry2.UnitPrice = 30;
        standardPbEntry2.Product2Id = produit2.id;
        standardPbEntry2.IsActive=true;
        listPricebookEntryToInsert.add(standardPbEntry2);
        
        PricebookEntry standardPbEntry3 = new PricebookEntry();
        standardPbEntry3.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry3.UnitPrice = 30;
        standardPbEntry3.Product2Id = produit3.id;
        standardPbEntry3.IsActive=true;
        listPricebookEntryToInsert.add(standardPbEntry3);
        
        PricebookEntry standardPbEntry4 = new PricebookEntry();
        standardPbEntry4.Pricebook2Id = Test.getStandardPricebookId();
        standardPbEntry4.UnitPrice = 30;
        standardPbEntry4.Product2Id = produit4.id;
        standardPbEntry4.IsActive=true;
        listPricebookEntryToInsert.add(standardPbEntry4);
        
        insert listPricebookEntryToInsert;
        //Create Commande
        Order commandeMulti11 = Test_Utils.createOrder(testAccount.Id);
        commandeMulti11.Requete__c = requeteMulti1.Id;
        commandeMulti11.Status = Label.Ord_Status_VersionPreliminaire;
        commandeMulti11.Pricebook2Id = Test.getStandardPricebookId();
        commandeMulti11.EffectiveDate = Date.Today() - 10;
        commandeMulti11.Type = Label.Ord_Type_PackRemplacementMateriel;
        commandeMulti11.Foyer_paneliste__c = foyerPaneliste.Id;
        insert commandeMulti11;
        
        List<String> listOrderId = new List<String>();
        listOrderId.add(commandeMulti11.Id);
        
        AP01_ProduitCommande.creerCommandePackRemplacementMateriel(listOrderId);
        
        
        List<OrderItem> listOrderItem = [
            SELECT Id
            From OrderItem
            WHERE OrderId = :commandeMulti11.Id
        ];
        
        
        System.assertNotEquals(0, listOrderItem.size());
        
    }
}