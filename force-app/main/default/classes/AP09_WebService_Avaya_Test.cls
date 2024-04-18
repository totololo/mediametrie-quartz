/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 11-21-2022
 * @last modified by  : Anes BOUZOUINA
**/
@isTest
public with sharing class AP09_WebService_Avaya_Test {

    // global HttpResponse respond(HTTPRequest req){
    //     HttpResponse res = new HttpResponse();
    //     res.setStatus('OK');
    //     res.setStatusCode(200);
    //     res.setBody('GREAT SCOTT');
    //     return res;
    //   }
    // @isTest
    // public static void AP09_AddNewCall_Test() {
    //     Test.startTest();

    //     Campaign campaign = Test_Utils.createCampaign();
    //     insert campaign;
    //     Contact contact = Test_Utils.createMembreFoyer('0011q0000167QfWAAU');
    //     insert contact;

    //     CampaignMember CampaignMember =new CampaignMember();
    //     CampaignMember.CampaignId=campaign.Id;
    //     CampaignMember.ContactId=contact.Id;
    //     insert CampaignMember;

    //     RestRequest req = new RestRequest(); 
    //     RestResponse res = new RestResponse();
    //     String Url = Label.URL_AVAYA+'/API/AddNewCall';

    //     req.requestURI = Url ;  //Request URL
    //     req.httpMethod = 'PUT';//HTTP Request Type
    //     req.addHeader('Content-Type', 'application/json');

    //     RestContext.request = req;
    //     RestContext.response= res;

    //     AP09_WebService_Avaya.AddNewCall();
    //   Test.stopTest();
    // }

    // @isTest
    // public static void GetTryInfo_Test() {
    // String tryId='20220906173855989D1023';
    // Test.startTest();

    // Test.setMock(HttpCalloutMock.class, new AP09_WebService_Avaya());
    // AP09_WebService_Avaya.GetTryInfo(tryId);
    // Test.stopTest();
    
    
  




    @isTest
    static  void GetTryInfo_Test() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('GetTryInfoRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String result = AP09_WebService_Avaya.GetTryInfo('123123123123');
        // Verify mock response is not null
        //System.assertNotEquals(null,result, 'The callout returned a null response.');
        // Verify status code
       // System.assertEquals(200,result.getStatusCode(), 'The status code is not 200.');
        // Verify content type   
       // System.assertEquals('application/json;charset=UTF-8', result.getHeader('Content-Type'),'The content type value is not expected.');  
        // Verify the array contains 3 items     
        Map<String, object> results = (Map<String, object>) JSON.deserializeUntyped(result);
        system.debug(results);
        // List<Object> animals = (List<Object>) results.get('animals');
         System.assertEquals('04102022172300', results.get('CampaignstartingDateTime'), 'Ok');          
      
}


@isTest
static  void AcceptetTry_Test() {
    // Create the mock response based on a static resource
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('AcceptTryRessource');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Associate the callout with a mock response
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
   AP09_WebService_Avaya.AcceptTry('123123123123');     
}

@isTest
static  void NotifyCallCleared_Test() {
    // Create the mock response based on a static resource
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('NotifyCallClearedRessource');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Associate the callout with a mock response
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
   AP09_WebService_Avaya.NotifyCallCleared('123123123123');
}


@isTest
static  void QualifyTry_Test() {
    // Create the mock response based on a static resource
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('QualifyTryRessource');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Associate the callout with a mock response
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
   AP09_WebService_Avaya.QualifyTry('123123123123','12344');
}

@isTest
static  void PrepareListOfCalls_Test() {
    // Create the mock response based on a static resource
    list<Appel__c> applst = new   list<Appel__c>();
    applst=Test_Utils.createAppels(5);
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('PrepareListOfCallsRessource');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
    // Associate the callout with a mock response
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
   AP09_WebService_Avaya.PrepareListOfCalls(appLst,'Active');
}
    
}