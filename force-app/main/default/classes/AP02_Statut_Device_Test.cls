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
public class AP02_Statut_Device_Test {
    
    @isTest
    static void autoIncrement() {
        Id recordTypeIdStreamingMeter = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Streaming_Meter).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMTPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceList = new List<Statut_Device_Equipement_Mesure__c>();
        
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
                
        MembreFoyerCallout_Mock fakeSendAsset11 = new MembreFoyerCallout_Mock(foyerPaneliste11.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeSendAsset11);
        foyerPaneliste11.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel;
        Update foyerPaneliste11;
        statutDeviceList = [SELECT Id, ExtID_partenaire__c FROM Statut_Device_Equipement_Mesure__c WHERE ExtID_partenaire__c != null];
        System.debug('***statutDeviceList: ' + statutDeviceList);
        System.assertEquals(2, statutDeviceList.size());
        Test.stopTest();
    }

}