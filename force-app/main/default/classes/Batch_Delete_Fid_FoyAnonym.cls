/*
* @author: YH
* @date: 12/2021
* @ Description Batch POUR supprimer LES fidélisations des foyers anonymisés
* @TestClass: 
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class Batch_Delete_Fid_FoyAnonym implements Database.Batchable<sObject>, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string query = 'select  id ,Nom_de_famille__c from Account  where Nom_de_famille__c like \'nom\\_%\'    ';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<fidelisation__c> listfidtodelete = [select id from fidelisation__c where Foyer__c in:scope];
        
        system.debug('scope size'+scope.size());
        system.debug('scope'+scope);

        system.debug('fide'+listfidtodelete.size());
       
        
        delete(listfidtodelete);
        delete(scope);

    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}