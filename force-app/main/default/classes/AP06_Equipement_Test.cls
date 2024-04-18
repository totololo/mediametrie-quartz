/*
* @author: Jérôme
* @date: 25/04/2022
* @ Description: Classe qui test MulesoftEquipementDeMesureProvisioning1 
* @TestClass: 
* @Coverage:
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
@isTest
public class AP06_Equipement_Test {
    
    @isTest
    static void provisionningTest(){
        
        User u = [select id from user where username =: Label.Mulesoft_integrationUser_username limit 1];
        system.runAs(u){
            
            Account foyerStock = new Account();
            foyerStock.Name = 'IMS';
            foyerStock.ShippingPostalCode = '98222';
            foyerStock.ShippingState = 'France';
            foyerStock.ShippingCountry = 'PHUKET';
            foyerStock.ShippingStreet = 'toto';
            foyerStock.ShippingCity = 'paname';
            foyerStock.foyer_stock__c = true;
            insert foyerStock;
            
            Account foyerReel = new Account();
            foyerReel.Name = 'FoyerReel';
            foyerReel.ShippingPostalCode = '98222';
            foyerReel.ShippingState = 'France';
            foyerReel.ShippingCountry = 'PHUKET';
            foyerReel.ShippingStreet = 'toto';
            foyerReel.ShippingCity = 'paname';
            foyerReel.foyer_stock__c = false;
            insert foyerReel;
            
            Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            
            List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
            refPanMMAT.Name = 'MMAT';
            refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
            referentielPanelToInsert.add(refPanMMAT);
            
            insert referentielPanelToInsert;
            
            Foyer_paneliste__c foyerPan = new Foyer_paneliste__c();
            foyerPan.RecordTypeId = recordTypeIdPanelMediamatPame;
            foyerPan.Name='testMMAT';
            foyerPan.Foyer__c = foyerReel.id;
            foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            foyerPan.Identifiant_foyer_pame__c = 12345;
            foyerPan.Referentiel_Panel__c = refPanMMAT.Id;
            insert foyerPan;
            
            Id recordTypeIdRouteur  = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Routeur).getRecordTypeId();

            List<Asset> equipementToInsert = new List<Asset>();
            Asset eqt1 = new Asset();
            eqt1.AccountId = foyerStock.id;
            eqt1.Name = 'assetTest';
            eqt1.Type_de_materiel__c = Label.Ass_TypeMateriel_RouteurGoogle;
            eqt1.Foyer_paneliste__c = foyerPan.Id;
            eqt1.RecordTypeId = recordTypeIdRouteur;
            eqt1.Reference_produit__c = 'ROA01V1';
            equipementToInsert.add(eqt1);
            
            insert equipementToInsert;
            
            List<Asset> equipementToUpdate = new List<Asset>();
            eqt1.AccountId = foyerReel.Id;
            equipementToUpdate.add(eqt1);
            
            IndividuPanelisteCallout_Mock fakeEqt1 = new IndividuPanelisteCallout_Mock(eqt1.Id);
           
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, fakeEqt1); 
            //List<MulesoftEquipementDeMesureProvisioning1.CalloutResponse> resp = MulesoftEquipementDeMesureProvisioning1.sendAssetToOCOM(listAssetIds);
            
            update equipementToUpdate;
            Test.stopTest();
        }
        
    }
    
    @isTest
    static void deprovisionningTest(){
        User u = [select id from user where username =: Label.Mulesoft_integrationUser_username limit 1];
        system.runAs(u){
            Account foyerStock = new Account();
            foyerStock.Name = 'IMS';
            foyerStock.ShippingPostalCode = '98222';
            foyerStock.ShippingState = 'France';
            foyerStock.ShippingCountry = 'PHUKET';
            foyerStock.ShippingStreet = 'toto';
            foyerStock.ShippingCity = 'paname';
            foyerStock.foyer_stock__c = true;
            insert foyerStock;
            
            Account foyerReel = new Account();
            foyerReel.Name = 'FoyerReel';
            foyerReel.ShippingPostalCode = '98222';
            foyerReel.ShippingState = 'France';
            foyerReel.ShippingCountry = 'PHUKET';
            foyerReel.ShippingStreet = 'toto';
            foyerReel.ShippingCity = 'paname';
            foyerReel.foyer_stock__c = false;
            insert foyerReel;
            
            Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            
            List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
            refPanMMAT.Name = 'MMAT';
            refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
            referentielPanelToInsert.add(refPanMMAT);
            
            insert referentielPanelToInsert;
            
            Foyer_paneliste__c foyerPan = new Foyer_paneliste__c();
            foyerPan.RecordTypeId = recordTypeIdPanelMediamatPame;
            foyerPan.Name='testMMAT';
            foyerPan.Foyer__c = foyerReel.id;
            foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            foyerPan.Referentiel_Panel__c = refPanMMAT.Id;
            insert foyerPan;
            
            Id recordTypeIdRouteur  = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Routeur).getRecordTypeId();
            List<Asset> equipementToInsert = new List<Asset>();            
            Asset eqt2 = new Asset();
            eqt2.AccountId = foyerReel.id;
            eqt2.Foyer_paneliste__c = foyerPan.Id;
            eqt2.Name = 'assetTest';
            eqt2.Type_de_materiel__c = Label.Ass_TypeMateriel_RouteurGoogle;                      
            eqt2.RecordTypeId = recordTypeIdRouteur;
            eqt2.Reference_produit__c = 'ROA01V1';
            equipementToInsert.add(eqt2);
            insert equipementToInsert;
            
            
            List<Asset> equipementToUpdate = new List<Asset>();
            eqt2.AccountId = foyerStock.Id;
            eqt2.Foyer_paneliste__c = null;
            equipementToUpdate.add(eqt2);
            
            
            IndividuPanelisteCallout_Mock fakeEqt2 = new IndividuPanelisteCallout_Mock(eqt2.Id);
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, fakeEqt2); 
            //List<MulesoftEquipementDeMesureProvisioning1.CalloutResponse> resp = MulesoftEquipementDeMesureProvisioning1.sendAssetToOCOM(listAssetIds);
            
            update equipementToUpdate;
            Test.stopTest();
        }
    }
    
}