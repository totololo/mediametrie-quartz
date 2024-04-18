/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-21-2022
 * @last modified by  : Anes BOUZOUINA
**/
@isTest
public with sharing class Batch022_CreateAvayaCalls_Test {
    @IsTest
    public static void  Batch022_CreateAvayaCalls_Test() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('NotifyCallClearedRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        List<Appel__c> app = Test_Utils.createAppels(20);
        insert app ;
       
        Id batchCreate = Database.executeBatch(new Batch022_CreateAvayaCalls(), 30);
        Id batchCancel = Database.executeBatch(new Batch022_CancelAvayaCalls(), 30);
    }
}