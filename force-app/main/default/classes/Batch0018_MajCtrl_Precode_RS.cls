global class Batch0018_MajCtrl_Precode_RS implements Database.Batchable<sObject>, Database.Stateful {
		
    
    	//Added for email notification - START
    	global String errorTxt = '';
    	global Boolean containsErrors = false;
    
    	//Added for email notification - END
    	
    date Jminus3 = system.today().adddays(-3);
   	global Database.QueryLocator start(Database.BatchableContext bc) {
  
         String query ='select id,tech_date_precodage__c from controle__c where tech_date_precodage__c =:Jminus3 ';
         return Database.getQueryLocator(query);
    }
    
    
    
    global void execute(Database.BatchableContext bc, List<Controle__c> scope){
        system.debug('scope '+scope);
        
        for (controle__c c:scope){
            c.Statut__c='Actif';
            c.Libelle_de_pre_codage__c='';
            c.tech_reconnecte__c=true;
        }
        
        try {
            update scope;
        }
        catch(exception ex){
            errorTxt += 'Erreur durant la mise à jour de controle : ' + ex.getMessage() + '\n' +scope;
            containsErrors = true;
        }
    }

    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B0018_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B0018_SenderName);
        mail.setSubject(System.Label.BatchNotif_B0018_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch0018_MajCtrl_Precode_RS s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //Added for notifications - END
    }
}