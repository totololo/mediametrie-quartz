/*
* @author: YH 
* @date: 13/01/2022
* @ Description Batch pour  la suppression des évènements du mois M-1
* @TestClass:
* @Coverage:  %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class Batch0013_Delete_Evenement implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    public integer count = 0;

    //Added for email notification - END
    global Database.QueryLocator start(Database.BatchableContext bc){
        DATE i=System.today();
        date lastm=i.addMonths(-1);
        
        String query = 'Select id , CreatedDate from Evenement__c  where CreatedDate < :lastm';
                

        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Evenement__c> scope){
        
        
        
        if (scope.size()>0){
            try{
                
                Database.DeleteResult[] ds = Database.delete(scope);
				for(database.DeleteResult d : ds){
        				if(d.issuccess()){
            			count++;
        		}		
        
    		}
            }
            Catch(exception ex){
                system.debug('evenement Exception Error:'+ex.getmessage());
                //Added for notification
                errorTxt += 'Erreur durant suppression des évènements : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
        }
        

        
    }
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B0013_ToAddress.split(';');
     
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B0013_SenderName);
        mail.setSubject(System.Label.BatchNotif_B0013_Subject);
        
        String emailBody = 'L\'exécution du batch Batch013_Delete_Evenements s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.\n';
            emailBody +='le nombre d\'enregistrements supprimés est :'  +count;
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        //Added for notifications - END
    }
}