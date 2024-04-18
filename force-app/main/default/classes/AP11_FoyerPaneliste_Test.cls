/*
* @date: 08/08/2023
* @ Description Class qui teste AP11_FoyerPaneliste 
* @version 1.00   
* pourcentage : %
* @Auteur Claire VEHRLE
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP11_FoyerPaneliste_Test {

    @isTest
    static void AP11_FoyerPaneliste() {
        
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();        
        Id recordTypeIdFoyerPanelisteMMTPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        
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
        insert foyerPaneliste11;
        
        List<Equipements_du_foyer__c> eqtFoyerToInsert = new List<Equipements_du_foyer__c>();
        Equipements_du_foyer__c eqtFoyer1 = new Equipements_du_foyer__c();
        eqtFoyer1.recordTypeId = recordTypeIdeqtFoyerPoste;
        eqtFoyer1.Connectable_a_internet__c = true;
        eqtFoyer1.foyer__c = foyer1.Id;
        eqtFoyerToInsert.add(eqtFoyer1);
        
        Equipements_du_foyer__c eqtFoyer2 = new Equipements_du_foyer__c();
        eqtFoyer2.recordTypeId = recordTypeIdeqtFoyerDevice;
        eqtFoyer2.foyer__c = foyer1.Id;
        eqtFoyer2.Type__c = Label.EQF_Type_Smartphone;
        eqtFoyerToInsert.add(eqtFoyer2);
        
        
        Equipements_du_foyer__c eqtFoyer3 = new Equipements_du_foyer__c();
        eqtFoyer3.recordTypeId = recordTypeIdeqtFoyerPoste;
        eqtFoyer3.foyer__c = foyer1.Id;
        eqtFoyerToInsert.add(eqtFoyer3);
        
        insert eqtFoyerToInsert;
        
        foyerPaneliste11.statut_foyer_paneliste__c = Label.PAN_Statut_Panel;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPaneliste11.id)); 
        update foyerPaneliste11;
        List<Statut_Device_Equipement_Mesure__c> statutDeviceList =  new List<Statut_Device_Equipement_Mesure__c>();
        statutDeviceList = [SELECT Id FROM Statut_Device_Equipement_Mesure__c];
        System.assertEquals(3, statutDeviceList.size());
        Test.stopTest();
    }
}