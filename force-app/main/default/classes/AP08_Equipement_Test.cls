/*
* @date: 09/08/2023
* @ Description Class qui teste AP08_Equipement 
* @version 1.00   
* pourcentage : %
* @Auteur Claire VEHRLE
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP08_Equipement_Test {
    
    @isTest
    static void AP08_Equipement() {
        Id recordTypeIdStreamingMeter = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Streaming_Meter).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMTPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
        
        Account IMS = new Account();
        IMS.Name = 'Station';
        foyerToInsert.add(IMS);
        
        insert foyerToInsert;
        
        Referentiel_panel__c mesurePlateforme = new referentiel_panel__c();
        mesurePlateforme.name = Label.RFP_Nom_Mesure_Plateforme;
        mesurePlateforme.Type_de_panel__c = Label.RFP_TypePanel_Mesure_Plateforme;
        insert mesurePlateforme;
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteMMTPaME;
        foyerPaneliste11.Referentiel_Panel__c = mesurePlateforme.Id;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        insert foyerPaneliste11;
        
        list<Asset> listAssetToInsert = new list<Asset>();
        Asset asset11 = new Asset();
        asset11.AccountId = foyer1.Id;
        asset11.RecordTypeId = recordTypeIdStreamingMeter;
        asset11.Type_de_materiel__c = Label.ASS_TypeMateriel_Streaming_Meter;
        asset11.status = Label.ASS_Statut_Installe;
        asset11.SerialNumber = '945602';
        asset11.Audimetre__c = '243EAA'; 
        listAssetToInsert.add(asset11);
        
        insert listAssetToInsert;
        
        List<Asset> listAssetToUpdate = new list<Asset>();
        asset11.status = Label.ASS_Statut_Desinstalle;
        listAssetToUpdate.add(asset11);
        
        
        MembreFoyerCallout_Mock fakeSendAsset11 = new MembreFoyerCallout_Mock(asset11.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeSendAsset11);
        Update listAssetToUpdate;
        Test.stopTest();
    }
    
    
}