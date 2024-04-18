/*
* @author: 
* @date: 01/06/2022  
* @ Description Batch pour 
* @TestClass: 
* @Coverage:  %
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 

global class batch0017_ShareNote implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    list<ContentDocumentLink> NoteToShare = new list<ContentDocumentLink>();
    global String errorTxt = '';
    global Boolean containsErrors = false;
    global Database.QueryLocator start(Database.BatchableContext bc){
      
        string query = 'select id,FileType from ContentDocument where CreatedDate = TODAY ';
        return Database.getQueryLocator(query);
	}
    
    global void execute(Database.BatchableContext bc, list<ContentDocument> scope){
        
        for (ContentDocument note :scope){
            		
            if(note.FileType =='SNOTE'){
                system.debug('scope'+scope);
            	ContentDocumentLink conDocLnk = new ContentDocumentLink();
                conDocLnk.ContentDocumentId = note.Id;
                conDocLnk.LinkedEntityId = Label.PRM_group; 
               	conDocLnk.ShareType = 'C';
                NoteToShare.add(conDocLnk);
            }
        	
        }
        try{
            database.insert(NoteToShare,false);
        }
        catch (exception ex){
                system.debug('evenement Exception Error:'+ex.getmessage());
                //Added for notification
                errorTxt += 'Erreur durant le partage de la note : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B0017_ToAddress.split(';');
     
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B0017_SenderName);
        mail.setSubject(System.Label.BatchNotif_B0017_Subject);
        
        String emailBody = 'L\'exécution du  batch0017_ShareNote s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.\n';
            
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}