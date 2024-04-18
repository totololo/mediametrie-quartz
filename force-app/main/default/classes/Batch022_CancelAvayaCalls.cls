/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-24-2022
 * @last modified by  : Anes BOUZOUINA
**/
global class Batch022_CancelAvayaCalls  implements Database.Batchable<sObject>, Database.AllowsCallouts {
        global Database.QueryLocator start(Database.BatchableContext BC){
            system.debug('start');
            String query='select  Campagne_Id_Avaya__c, Telephone1__c, Telephone2__c,account__c,Campaign__r.Temps_dattente__c from appel__c WHERE Createddate= today and status__c=\'Sended\'';
           
            return Database.getQueryLocator(query);
        }
    
        global void execute(Database.BatchableContext BC, List<Appel__c> scope){
            system.debug(' execute');
            system.debug(' scope '+ scope);
            //limiter le scope a 100
            // le statu est active pour creer des nouvels appels
            AP09_WebService_Avaya.PrepareListOfCalls(scope,'CANCEL');
    
            for(appel__c appItr : scope){
                appItr.status__c='Canceled';
            }
            delete  scope;
           
        }
        
        global void finish(Database.BatchableContext BC){
        Id batchCreate = database.executebatch(new Batch022_CreateAppel(),100);
        }
    }