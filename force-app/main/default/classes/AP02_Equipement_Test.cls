/*
* @date: 19/10/2021
* @ Description Class qui teste AP02_Equipement 
* @version 1.00   
* pourcentage : 95%
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP02_Equipement_Test {
    @isTest
    static void AP02_SendAsset(){
        
        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        u.Bypass_flows__c = true;
        update u;
        
         System.runAs(u){
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyer2.foyer_stock__c = true;
        foyerToInsert.add(foyer2);
        insert foyerToInsert;
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        insert foyerPaneliste11;
        
        list<Asset> listAssetToInsert = new list<Asset>();
        Asset asset11 = Test_Utils.createEquipement(foyer1.Id);
        asset11.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset11.Batterie__c = 0;
        asset11.Foyer_paneliste__c = foyerPaneliste11.Id;
        asset11.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset11.Date_de_derniere_detection__c = Date.today() - 33;
        asset11.Audimetre__c = '243EAA'; 
        asset11.ASS_ExtId_Ocom__c='0011j000012iqI3AAI';
        listAssetToInsert.add(asset11);
        
        Asset asset2 = Test_Utils.createEquipement(foyer2.Id);
        asset2.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset2.Batterie__c = 0;
        asset2.Type_de_materiel__c = Label.ASS_Type_De_Materiel_Beacon;
        asset2.Date_de_derniere_detection__c = Date.today() - 33;
        asset2.Audimetre__c = '213EA'; 
        asset2.ASS_ExtId_Ocom__c='1234567'; 
        listAssetToInsert.add(asset2);
        
        insert listAssetToInsert;
        
        List<Asset> listAssetToUpdate = new list<Asset>();
        asset11.AccountId = foyer2.Id;
		asset11.Foyer_paneliste__c = null; 
        asset11.Audimetre__c = '243EA';  
        listAssetToUpdate.add(asset11);
        
        asset2.AccountId = foyer1.Id;
        asset2.Foyer_paneliste__c = foyerPaneliste11.Id;
        listAssetToUpdate.add(asset2);
        
        MembreFoyerCallout_Mock fakeSendAsset11 = new MembreFoyerCallout_Mock(asset11.Id);
        MembreFoyerCallout_Mock fakeSendAsset2 = new MembreFoyerCallout_Mock(asset2.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeSendAsset11);
        Test.setMock(HttpCalloutMock.class, fakeSendAsset2);
        Update listAssetToUpdate;
        Test.stopTest();
        
        /*String assId = '0011j000012iqI3AAI';
        
        List <String> ListAssExternalIds = new List <String>();
        ListAssExternalIds.add(assId);
        
        MembreFoyerCallout_Mock fakeSendAss = new MembreFoyerCallout_Mock(assId);
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, fakeSendAss);
        AP02_Equipement.DissocierEquipementOcom(ListAssExternalIds);
        AP02_Equipement.PutMeterConfMetier(ListAssExternalIds);
        AP02_Equipement.checkSendAssetToOcom(listAsset);
        Test.stopTest();*/
         }
    }
}