/*
* @author: YH
* @date: 17/07/2023
* @ Description Class pour mettre à jour à inactif les etiquettes dont la date est dépassée
* History
* <Date of modification>   <Author>    <Description of modification>
* 		
*/


global class Batch025_MAJ_Etiquette implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts  {

    global String errorTxt = '';
    	global Boolean containsErrors = false;
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        
        string statut_actif =label.ETI_Statut_Actif;
        String query = 'select id,Date_de_fin__c,Statut__c from Etiquette__c where Statut__c =: statut_actif';
      
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext bc, List<Etiquette__c> scope ){
        list<Etiquette__c> EtiquToUpdate = new list<Etiquette__c>();
        for (Etiquette__c et: scope){
            
            if (et.Date_de_fin__c<=system.today()){
                
                et.Statut__c=label.ETI_Statut_Inactif;
                EtiquToUpdate.add(et);
            }
        }
        if (EtiquToUpdate.size()>0 && EtiquToUpdate.size()!=null){
            try{
                database.update(EtiquToUpdate,false);
            }catch(exception ex){
            errorTxt += 'Erreur durant la mise à jour des etiquettes : ' + ex.getMessage() + '\n' +scope;
            containsErrors = true;
        }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B025_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B0025_SenderName);
        mail.setSubject(System.Label.BatchNotif_B0025_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch025_MAJ_Etiquette s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        mail.setPlainTextBody(emailBody);
        
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //Added for notifications - END
    }
}