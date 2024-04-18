/*
* @author: Elissa Rafka 
* @date: 11/08/2021
* @ Description Batch pour mettre à jour le type d'enregistrement "équipé" des foyers existants sur prod et préprod (ticket MEDIAMETRIE-261)
* @TestClass: Batch010_MajFoyersExistants_Test
* @Coverage: 81 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
global class Batch010_MajFoyersExistants implements Database.Batchable<sObject>, Database.Stateful {
    
    global String errorTxt = '';
    global Boolean containsErrors = false;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Id rTFoyerNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId();
        String query = 'Select Id from account where RecordTypeId = null or RecordTypeId =: rTFoyerNonEquipe';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        Id recordTypeIdEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_Equipe).getRecordTypeId();
        for (Account acc : scope){
            acc.RecordTypeId = recordTypeIdEquipe;
        }
            try{ 
               database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Exception Error:'+ex.getmessage());
                errorTxt += 'Erreur durant la modification sur les foyers : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }  
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}