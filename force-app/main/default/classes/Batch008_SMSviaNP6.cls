/*
* @author: Joyce Saidy/Khaled Hammoudeh
* @date: 05/10/2020
* @ Description Batch pour la récuperation des rendez-vous planifié à J-1 de la début planifiée 
* @TestClass: Batch008_SMSviaNP6_Test
* @Coverage: 77 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
global class Batch008_SMSviaNP6 implements Database.Batchable<sObject>,    Database.AllowsCallouts, Database.Stateful{
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // ticket 51 : staut dispatché
        String statutRDVPlanifie = System.Label.RDV_Statut_Dispatche;
        
        String query = 'Select id,Sous_type_d_intervention__c, SchedStartTime, Contact.Email, Contact.MobilePhone,Account.Adresse_e_mail_principale__c,account.Numero_de_portable__c from ' +
            ' serviceAppointment where status = :statutRDVPlanifie AND SchedStartTime =TOMORROW and Sous_type_d_intervention__c !=\'Passage Improviste\' ';
        
        // query = 'Select id,Sous_type_d_intervention__c, SchedStartTime, Contact.Email, Contact.MobilePhone,Account.Adresse_e_mail_principale__c,account.Numero_de_portable__c from ' +
          //  'serviceAppointment where id =\'08p7T000001XAQ0QAO\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<serviceAppointment> scope){
        List <serviceAppointment> listRendezVous = new  List <serviceAppointment>();
        
        if(scope.size() > 0)
        {
            
           
               try{
                	AP01_SendSMS.sendSMSViaNP6(scope);
                system.debug('ttt'+scope);
                }
                catch(exception ex){
                system.debug(' SMS Sent Failed:'+ex.getmessage());
               //added for notification
                errorTxt += 'Erreur durant l\'envoie du sms : ' + ex.getMessage() + '\n';
                containsErrors = true;
                }
                
            
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B008_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B008_SenderName);
        mail.setSubject(System.Label.BatchNotif_B008_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch008_SMSviaNP6 s\'est terminée en Prep2.\n';
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