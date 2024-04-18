/*
* @author: YH
* @date: 01/2022
* @ Description Batch POUR LES cases des foyers anonymisés
* @TestClass: 
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*/

global class Batch_delete_case_FoyerAnonym implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query = 'select  id ,Nom_de_famille__c from Account  where Nom_de_famille__c like \'nom\\_%\'    ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
       
        List<case> listcasetodelete = [select id from case where AccountId in:scope];

        system.debug('scope size'+scope.size());
        system.debug('scope'+scope);

       
        system.debug('case'+listcasetodelete.size());
        delete(listcasetodelete);
           

    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}