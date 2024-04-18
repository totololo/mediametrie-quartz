/*
* @date: 21/09/2021
* @ Description Class qui teste Batch011_CreationRequeteWelcomeCal 
* @version 1.00   
* pourcentage : 97%
* @Auteur Ayoub Ghammaz EIT
*/
@isTest
public class Batch011_CreationRequeteWelcomeCal_Test {
    @isTest static void testWelcome(){
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        /*------------------------------- test ne pas cloturer la requete : tt date debut detection < 7 jours*/
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest1');
        insert(foyer1);
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest1',RecordTypeId=recordTypeIdPanelAIP,
                                                               Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel,
                                                               Date_de_creation__c=Date.today());
        insert(paneliste1);
        Test.startTest();
        Batch011_CreationRequeteWelcomeCal bccfb = new Batch011_CreationRequeteWelcomeCal();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select id  from case where Sous_type__c=:Label.CAS_Sous_type_WelcomeCall].size());
    } 
    @isTest static void testWelcome2(){
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        /*------------------------------- test  cloturer la requete :  date debut detection = 7 jours*/
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest1');
        insert(foyer1);
        //creer foyer paneliste aip Date.newInstance(2021, 7, 17)
        date d = Date.today();
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest1',RecordTypeId=recordTypeIdPanelAIP,
                                                               Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel,
                                                              Date_de_creation__c=d.addDays(-integer.valueOf(Label.Batch011_NBJours7)));
        insert(paneliste1);
        Test.startTest();
        Batch011_CreationRequeteWelcomeCal bccfb = new Batch011_CreationRequeteWelcomeCal();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select id  from case where Sous_type__c=:Label.CAS_Sous_type_WelcomeCall].size());
    } 
      @isTest static void testWelcome3(){
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        /*------------------------------- test  cloturer la requete :  date debut detection > 7 jours*/
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest1');
        insert(foyer1);
        //creer foyer paneliste aip Date.newInstance(2021, 7, 17)
        date d = Date.today();
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest1',RecordTypeId=recordTypeIdPanelAIP,
                                                               Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel,
                                                              Date_de_creation__c=d.addDays(-9));
        insert(paneliste1);
        Test.startTest();
        Batch011_CreationRequeteWelcomeCal bccfb = new Batch011_CreationRequeteWelcomeCal();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
       // System.assertEquals(1, [select id  from case where Sous_type__c=:Label.CAS_Sous_type_WelcomeCall].size());
    } 
}