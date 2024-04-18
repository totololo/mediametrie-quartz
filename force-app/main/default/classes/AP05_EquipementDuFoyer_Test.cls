/*
* @date: 16/08/2023
* @ Description Class qui teste AP02_Statut_Device
* @version 1.00   
* pourcentage : %
* @Auteur Claire VEHRLE
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP05_EquipementDuFoyer_Test {

    @isTest
    static void creationEqtFoyer() {
        Id recordTypeIdStreamingMeter = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Streaming_Meter).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMTPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
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
        
        foyerPaneliste11.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        Update foyerPaneliste11;
        
        Equipements_du_foyer__c eqtFoyer3 = new Equipements_du_foyer__c();
        eqtFoyer3.recordTypeId = recordTypeIdeqtFoyerDevice;
        eqtFoyer3.foyer__c = foyer1.Id;
        eqtFoyer3.Type__c = Label.EQF_Type_Tablette;
        
        MembreFoyerCallout_Mock fakeSendAsset11 = new MembreFoyerCallout_Mock(foyerPaneliste11.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeSendAsset11);
        insert eqtFoyer3;
        List<Statut_Device_Equipement_Mesure__c> statutDeviceList = new List<Statut_Device_Equipement_Mesure__c>();
        statutDeviceList = [SELECT Id FROM Statut_Device_Equipement_Mesure__c];
        System.assertEquals(3, statutDeviceList.size());
        Test.stopTest();
    }
}