@isTest

public class Batch022_CancelAvayaCalls_Test {
/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-21-2022
 * @last modified by  : Anes BOUZOUINA
**/

    @IsTest
    public static void  Batch022_CreateAvayaCalls_Test() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NotifyCallClearedRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
// Create test data
        Campaign testCampaign = new Campaign(Temps_dattente__c = 10,CampagneID_Avaya__c='ID1',Name='Anes Test');
        insert testCampaign;
        Account testAccount = new Account(Name = 'Test Account',Statut_du_foyer__c='0', Type_de_foyer__c='1',Numero_de_telephone_fixe__c='0123456789',Numero_de_portable__c='0123456789');
        insert testAccount;
        Appel__c testAppel1 = new Appel__c( Account__c = testAccount.Id, Campaign__c = testCampaign.Id, Status__c = 'Sended');
        Appel__c testAppel2 = new Appel__c( Account__c = testAccount.Id , Campaign__c = testCampaign.Id, Status__c = 'Sended');
        insert new List<Appel__c>{testAppel1, testAppel2};
        
        // Execute batch
        Test.startTest();
        Batch022_CancelAvayaCalls batch = new Batch022_CancelAvayaCalls();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify results
        List<Appel__c> updatedAppels = [SELECT Status__c FROM Appel__c WHERE Id IN :new List<Id>{testAppel1.Id, testAppel2.Id}];
        for (Appel__c updatedAppel : updatedAppels) {
            System.assertEquals('Canceled', updatedAppel.Status__c);
       
        Id batchCancel = Database.executeBatch(new Batch022_CancelAvayaCalls(), 30);
    }
}
}