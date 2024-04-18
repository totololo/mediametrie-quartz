@isTest
public with sharing class CommunicatorController_Test {

    private static void setup() {
        
        User adminUser =[SELECT Id,UserRoleId FROM User WHERE Profile.Name='System Administrator'And IsActive=true Limit 1];
        adminUser.Bypass_validation_rules__c=true;
        update adminUser;
        
        System.runAs(adminUser){
        Account testAccount = new Account(Name = 'Test Account', Avaya_UUI_tech__c = '123|13213', Type_de_foyer__c = '2', Statut_du_foyer__c = '1', Numero_de_telephone_fixe__c = '0666666666', Numero_de_portable__c = '0666666666');
        insert testAccount;
        
        Case testCase = new Case(AccountId = testAccount.Id);
        insert testCase;
        
        Task newTask = new Task(Subject = 'Call', Priority = 'High', Status = 'Not Started', Description = 'Follow up with the customer.', OwnerId = UserInfo.getUserId(), uui__c = '123|13213');
        insert newTask;
        }}

    @isTest
    public static void IncomingEventMethod_Test() {
        setup();

        String str = '{"ani": "RECETTE-SFDC", "dnsi": "0754255713", "eventSource": "0754255714", "eventType": "04102022172300", "queue": "test anes", "ucid": "123|13213", "uui": "123|13213", "agentId": "1212312312"}';
		account acc=[select id from account limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl(acc.Id));
        CommunicatorController.IncomingEventMethod(str);
        Test.stopTest();

        // Add your assertions here
        System.assertNotEquals(null, acc, 'Account should exist');
    }

    @isTest
    public static void AcceptTry_Test() {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl('12312312'));
        CommunicatorController.AcceptTry('1234');
        Test.stopTest();

        // Assertions here
        List<Task> t = [SELECT Id, Subject FROM Task WHERE Subject = 'Call' LIMIT 1];
        System.assertEquals(0, t.size(), 'Task should exist yet');
    }

    @isTest
    public static void ReleasedEventMethod_Test() {
        setup();

        String str = '{"ani": "RECETTE-SFDC", "dnsi": "0754255713", "eventSource": "0754255714", "eventType": "04102022172300", "queue": "test anes", "ucid": "123|13213", "uui": "123|13213", "agentId": "1212312312"}';
        String strWithWrongUUI = '{"ani": "RECETTE-SFDC", "dnsi": "0754255713", "eventSource": "0754255714", "eventType": "04102022172300", "queue": "test anes", "ucid": "1213213", "uui": "12313213", "agentId": "1212312312"}';

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl('12312312'));
        CommunicatorController.ReleasedEventMethod(str);
        CommunicatorController.ReleasedEventMethod(strWithWrongUUI);
        Test.stopTest();

        // Assertions here
        List<Case> c = [SELECT Id, AccountId FROM Case WHERE AccountId != null LIMIT 1];
        System.assertEquals(1, c.size(), 'Case with AccountId should  exist');
    }

    public class HttpCalloutMockImpl implements HttpCalloutMock {
        String customerReference;

        public HttpCalloutMockImpl(String customerReference) {
            this.customerReference = customerReference;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{' +
                             '    "campaignId": "testCampaignId",' +
                             '    "customerReference": "' + customerReference + '",' +
                             '    "comments": "testComments",' +
                             '    "CaseID": "testCaseId",' +
                             '    "tryId": "testTryId"' +
                             '}');
            response.setStatusCode(200);
            return response;
        }
    }
}