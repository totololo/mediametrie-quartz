/*
* @author: Joyce Saidy
* @date: 10/09/2020
* @ Description Class that test Batch001_ControleAbandone  
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class Batch001_ControleAbandone_Test {
    public static testMethod void Batch001_ControleAbandoneTest(){
        Id recordTypeIdFoyerPanMMPaME  = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdFoyerPanAIP  = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        account testAccount2 = Test_Utils.createFoyer();
        testAccount2.Type_de_foyer__c = Label.ACC_Type_de_panel_AIP;
        testAccount2.Numero_de_portable__c = '0611111125';
        listFoyersToInsert.add(testAccount2);
        
        insert listFoyersToInsert; 
        
        Referentiel_Panel__c refPanTest = new Referentiel_Panel__c();
        refPanTest.Type_de_panel__c 	= Label.RFP_Nom_PaME;
        refPanTest.Name					= Label.RFP_Nom_PaME;
        insert refPanTest;
        
        Referentiel_Panel__c refPanTest2 = new Referentiel_Panel__c();
        refPanTest2.Type_de_panel__c 	= Label.RFP_Nom_AIP;
        refPanTest2.Name					= Label.RFP_Nom_AIP;
        insert refPanTest2;
        
        Foyer_paneliste__c foyerPanTest     = new Foyer_paneliste__c();
        foyerPanTest.foyer__c				= testAccount.id;
        foyerPanTest.Referentiel_Panel__c = refPanTest.id;
        foyerPanTest.Name = 'foyerPanTest';
        foyerPanTest.RecordTypeId = recordTypeIdFoyerPanMMPaME;
        insert foyerPanTest;
        
        Foyer_paneliste__c foyerPanTest2     = new Foyer_paneliste__c();
        foyerPanTest2.foyer__c				= testAccount2.id;
        foyerPanTest2.Referentiel_Panel__c = refPanTest2.id;
        foyerPanTest2.Name = 'foyerPanTest2';
        foyerPanTest2.RecordTypeId = recordTypeIdFoyerPanAIP;
        insert foyerPanTest2;
        
        //Create Case
        list<Case> listCaseToInsert = new list<Case>();
        Case testCase = Test_Utils.createCase(testAccount.id);
        testCase.Foyer_paneliste__c = foyerPanTest.Id;
        listCaseToInsert.add(testCase); 
        
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Case testCase2 = Test_Utils.createCase(testAccount2.id);
        testCase2.RecordTypeId=recordTypeIdControleAIP;
        testCase2.Foyer_paneliste__c = foyerPanTest2.Id;
        listCaseToInsert.add(testCase2); 
        insert listCaseToInsert; 
        
        //Create Controle
        list<Controle__c> listControleToInsert = new list<Controle__c>();
        Controle__c testCtrl = Test_Utils.createControle(testAccount.id,null,null,testCase.id,system.today()); 
        testCtrl.Statut__c=Label.CTRL_StatutActif;
        testCtrl.Foyer_Paneliste__c= foyerPanTest.Id;
        listControleToInsert.add(testCtrl);  
        
        Controle__c testCtrl2 = Test_Utils.createControle(testAccount2.id,null,null,testCase2.id,system.today()); 
        testCtrl2.Statut__c=Label.CTRL_StatutActif;
        testCtrl2.Foyer_Paneliste__c= foyerPanTest2.Id;
        listControleToInsert.add(testCtrl2);   
        
        insert listControleToInsert; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Batch001_ControleAbandone btch = new Batch001_ControleAbandone();
        database.executeBatch(btch);
        Test.stopTest(); 

		testCase2=[SELECT status from Case where Id=:testCase2.Id];
        System.debug('testCase2');
        System.debug(testCase2);
        
    }
}