/*
* @date: 05/10/2021
* @ Description : tester la classe AP05_FoyerPaneliste
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @Coverage: 88%
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP05_FoyerPaneliste_Test {
    @isTest static void testMajSatutAsset() {// tester la methode FoyerPAnelisteChute
        Id recordTypeIdAssetAip =Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        // Créer un foyer pour l'insérer dans le panel
        Account foyerTest = new Account(Name='testPanel');
        insert foyerTest;
        
        //Référentiel Panel
        List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
        
        Referentiel_Panel__c refPanelAIP = Test_Utils.createRefPanel(Label.RFP_Nom_AIP, Label.RFP_Nom_AIP);
        listReferentielPanelToInsert.add(refPanelAIP);
        
        insert listReferentielPanelToInsert;
        
        // Créer un panel Aip  PAN_Statut_Panel_Chute_definitive
        List<Foyer_paneliste__c> testPanelAip = new List<Foyer_paneliste__c>(); 
        testPanelAip.add(new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip',Foyer__c=foyerTest.id,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel,
                                                Statut_Audimetrique__c = Label.PAN_Statut_Audimetrique_nonRepondant, referentiel_panel__c = refPanelAIP.Id));
        System.debug('-->'+testPanelAip);
        insert testPanelAip;
        //creer equipements
        List<Asset> assetToInsert = new list<Asset>();
        assetToInsert.add(new asset(recordtypeid=recordTypeIdAssetAip,Name='test12 equi',Foyer_paneliste__c=testPanelAip[0].id,AccountId=foyerTest.id,
                                    status=LAbel.ASS_Statut_Valide,localisation__c=label.ASS_Localisation_Foyer));
        
        insert assetToInsert;
        
        testPanelAip[0].Statut_Foyer_paneliste__c=Label.PAN_Statut_Panel_Chute_definitive;
        testPanelAip[0].Date_de_chute__c= Date.today();
        testPanelAip[0].Date_de_chute_temporaire__c=date.today();
        update testPanelAip;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerTest.id));  
        System.assertEquals(1,[select id , status from asset where status=:Label.ASS_Statut_Perdu].size());
        Test.stopTest();
    }
    
}