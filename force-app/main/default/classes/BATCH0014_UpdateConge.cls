/*
* @author: 
* @date: 22/10/2021  
* @ Description Batch pour mettre à jour le  congé principale du  contact et sur le foyer quotidiennement
* @TestClass: BATCH0014_UpdateConge_Test
* @Coverage: 81 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 

global class BATCH0014_UpdateConge implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
     //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    
    //Added for email notification - END
    List<Contact> contactsToUpdate = new List<Contact>();
    List<String> listAccountsExtIdsToProcess = new List<String>();
    List<String> listContactExtIdsToProcess = new List<String>();
    //id idUserInteg = label.Mulesoft_integrationUser_id;
    //user u = [select id from user where id=:idUserInteg];
     
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        String query = 'SELECT Id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c, isCongeEnCours__c,isCongePrincipalFoyer__c FROM Conge__c where Date_de_debut__c >= today and isCongePrincipalFoyer__c=false  '    ;
      
        return Database.getQueryLocator(query);
    }
    
   
    global void execute(Database.BatchableContext bc, List<Conge__c> scope){
        
        system.debug('nombre scope: ' + scope.size());
        system.debug(scope);
        
       try{
        //listContactExtIdsToProcess.addAll(AP01_Conge.determineCongePrincipalContactBatch2(scope)) ;
        //listAccountsExtIdsToProcess.addAll(AP01_Conge.determineCongePrincipalAccountBatch(scope))  ;
        }
        catch(exception ex){
            errorTxt += 'Erreur  : ' + ex.getMessage() + '\n';
            containsErrors = true;
            //throw new exception(errorTxt);
        }
        
    		
       // system.debug('size'+listAccountsExtIdsToProcess.size());
  
    }
    global void finish(Database.BatchableContext bc){
        system.debug('liste account size '+listAccountsExtIdsToProcess.size());
     try{  
            if( listContactExtIdsToProcess.size() > 0 ) {            
            //Database.executeBatch(new BATCH0015_ContactsToSiPanel(listContactExtIdsToProcess),20);
        } 
        if( listAccountsExtIdsToProcess.size() > 0 ) { 
            system.debug('send account batch0016');
           //Database.executeBatch(new BATCH0016_AccountsToSiPanel(listAccountsExtIdsToProcess),20);
            system.debug('callout limit'+Limits.getCallouts());


       }   
           }
        catch (exception ex){
            system.debug('catch asyncexcep');
            errorTxt += 'Erreur  : ' + ex.getMessage() + '\n';
            containsErrors = true;
        }
         //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B0014_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B0014_SenderName);
        mail.setSubject(System.Label.BatchNotif_B0014_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batchBATCH0014_UpdateConge s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n'+errorTxt;
           
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //Added for notifications - END
    }
     
}