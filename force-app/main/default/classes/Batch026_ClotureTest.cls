/*
* @author: Mikael Chaaya
* @date: 20/07/2023
* @TestedClass: Batch026_ClotureCaseSansControle
* @Coverage: 94%
*/
@isTest
public class Batch026_ClotureTest {
    @isTest
    public static void testCreationRequete(){
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdControleAIP =Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        //creer des foyers
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);

        insert foyerList;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        Foyer_paneliste__c foyerPaneliste1 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPaneliste1.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteList.add(foyerPaneliste1);

        insert foyerPanelisteList;
        

        Case testCase1 = Test_Utils.createCase(foyer1.id);
        testCase1.foyer_paneliste__c = foyerPaneliste1.Id;
        testCase1.Status=Label.CAS_Statut_Nouveau;
        testCase1.Type=Label.CAS_Type_NonRepondantSetMeter;
        testCase1.RecordTypeId = recordTypeIdRequeteControleAIP;
        testCase1.Type_de_controle__c=Label.CAS_TypeControle_Non_Repondant;

        insert testCase1;

        Case testCase2 = Test_Utils.createCase(foyer1.id);
        testCase2.foyer_paneliste__c = foyerPaneliste1.Id;
        testCase2.Status=Label.CAS_Statut_Nouveau;
        testCase2.Type=Label.CAS_Type_Non_repondant;
        testCase2.RecordTypeId = recordTypeIdRequeteControleAIP;
        testCase2.Type_de_controle__c=Label.CAS_TypeControle_Non_Repondant;

        insert testCase2;

        List<controle__c> controleToInsert = new List<controle__c>();
        Controle__c ctrl1 = new controle__c();
        ctrl1.RecordTypeId = recordTypeIdControleAIP;
        ctrl1.foyer__c = foyer1.Id;
        ctrl1.Foyer_paneliste__c = foyerPaneliste1.Id;
        ctrl1.Requete__c = testCase1.Id;
        controleToInsert.add(ctrl1);
        
        insert controleToInsert;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id));
        Batch026_ClotureCaseSansControle bccfb = new Batch026_ClotureCaseSansControle();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<Case> testcases = [SELECT id FROM case WHERE Status=:Label.CAS_Statut_Cloture];
         System.assertEquals(1, testcases.size());
    }

}