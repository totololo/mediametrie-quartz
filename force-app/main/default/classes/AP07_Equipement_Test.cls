/*
* @date: 04/08/2023
* @ Description Class qui teste AP07_Equipement 
* @version 1.00   
* pourcentage : %
* @Auteur Claire VEHRLE
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP07_Equipement_Test {
    
    @isTest
    static void AP07_RemplissageAsset(){
        Id recordTypeIdStreamingMeter = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Streaming_Meter).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMTPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyer2.foyer_stock__c = true;
        foyerToInsert.add(foyer2);
        insert foyerToInsert;
        
        Referentiel_panel__c mesurePlateforme = new referentiel_panel__c();
        mesurePlateforme.name = Label.RFP_Nom_Mesure_Plateforme;
        mesurePlateforme.Type_de_panel__c = Label.RFP_TypePanel_Mesure_Plateforme;
        insert mesurePlateforme;
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteMMTPaME;
        foyerPaneliste11.Referentiel_Panel__c = mesurePlateforme.Id;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        foyerPaneliste11.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        insert foyerPaneliste11;
        
        list<Asset> listAssetToInsert = new list<Asset>();
        Asset asset11 = Test_Utils.createEquipement(foyer2.Id);
        asset11.RecordTypeId = recordTypeIdStreamingMeter;
        asset11.Type_de_materiel__c = Label.ASS_TypeMateriel_Streaming_Meter;
        asset11.Audimetre__c = '243EAA'; 
        listAssetToInsert.add(asset11);
        
        insert listAssetToInsert;
        
        List<Equipements_du_foyer__c> eqtFoyerToInsert = new List<Equipements_du_foyer__c>();
        Equipements_du_foyer__c eqtFoyer1 = new Equipements_du_foyer__c();
        eqtFoyer1.recordTypeId = recordTypeIdeqtFoyerPoste;
        eqtFoyer1.foyer__c = foyer1.Id;
        eqtFoyerToInsert.add(eqtFoyer1);
        
        Equipements_du_foyer__c eqtFoyer2 = new Equipements_du_foyer__c();
        eqtFoyer2.recordTypeId = recordTypeIdeqtFoyerDevice;
        eqtFoyer2.foyer__c = foyer1.Id;
        eqtFoyer2.Type__c = Label.EQF_Type_Smartphone;
        eqtFoyerToInsert.add(eqtFoyer2);
        
        insert eqtFoyerToInsert;
        
        
        List<Asset> listAssetToUpdate = new list<Asset>();
        asset11.AccountId = foyer1.Id;
        asset11.Foyer_paneliste__c = foyerPaneliste11.Id; 
        listAssetToUpdate.add(asset11);
        
        
        MembreFoyerCallout_Mock fakeSendAsset11 = new MembreFoyerCallout_Mock(asset11.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeSendAsset11);
        Update listAssetToUpdate;
        Test.stopTest();
    }
}