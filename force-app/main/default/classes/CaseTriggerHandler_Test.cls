/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 11-17-2022
* @last modified by  : Anes BOUZOUINA
**/
@istest
public with sharing class CaseTriggerHandler_Test {
    @istest

    public static void CaseTriggerHandler() {
        User adminUser =[SELECT Id,UserRoleId FROM User WHERE (Profile.Name='System Administrator' OR Profile.Name='Administrateur Système') And IsActive=true Limit 1];
        adminUser.Bypass_validation_rules__c=true;
        update adminUser;
        
         System.runAs(adminUser){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('QualifyTryRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        Account acc= Test_Utils.createFoyer();
        insert acc; 
        case req = Test_Utils.createCase(acc.Id);
        req.Avaya_UUI_tech__c='131|20220906175345989D10D6';
        insert req;
        test.startTest();
        req.qualificationCase__c='CPRO';
        update req;
        test.stopTest();
    }
}
}