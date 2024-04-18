/*
* @author: Joyce Saidy 
* @date: 24/09/2020
* @ Description Batch pour le credit automatique des fidelisation 1 fois par An le 1er septembre
* @TestClass: Batch004_CreditAutomatique_Test
* @Coverage: 87 %
* History
* <Date of modification>   <Author>    <Description of modification>
    10/08/2021               ER         Corrections faites pour pouvoir lancer le batch avec les foyer équipés seulement (ticket MEDIAMETRIE-261)
*/ 
global class Batch005_CreditAutomatique1foisparAn implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeIdNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId(); //Added by ER for MEDIAMETRIE-261
        String query = 'Select id,Freeze__c ,Date_d_installation__c from account where  RecordTypeId !=: recordTypeIdNonEquipe AND Date_d_installation__c!=null  and (Statut_du_foyer__c=\'1\' or Statut_du_foyer__c=\'2\' or Statut_du_foyer__c=\'3\')' ; //Changed by ER for MEDIAMETRIE-261
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<account> scope){
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        list<Fidelisation__c> listFIDtoInsert = new  list<Fidelisation__c>();
        for(Account Acc :scope)
        {
            if (acc.Freeze__c==false){
            listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Rentree,integer.valueof(Label.FID_NbrPoints_50)));
       
            }
        // YH 340
        else {
            system.debug('frrez'+acc.id);
            listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Rentree,integer.valueof(Label.FID_NbrPoints_0)));

        	}
        }
         system.debug('ttttt'+listFIDtoInsert.size());
        if(listFIDtoInsert!=null && listFIDtoInsert.size()>0)
        {
             try{ 
                database.insert(listFIDtoInsert, false);
                 system.debug('aaaa'+listFIDtoInsert);
            }Catch(exception ex){
                system.debug('Insert FID Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des requêtes : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }  
        }
    }
    global static Fidelisation__c NewFID(Id AccounId,Id recordTypeIdFIDcredit,String TypeMouvement,String MotifCredit,Integer NbrsPoints)
    {
        Fidelisation__c FID = new Fidelisation__c();
        if(TypeMouvement!=null && MotifCredit!=null && NbrsPoints!=null)
        {
            FID.Type_de_mouvement__c=TypeMouvement;
            FID.Motif_de_credit__c=MotifCredit;
            FID.Points_credites__c=NbrsPoints;
            FID.RecordTypeId = recordTypeIdFIDcredit;
            FID.Foyer__c=AccounId;
        }
        return FID;
    }
    // YH 340
           Global static Fidelisation__c NewFID_freez(ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement,String MotifCredit,Integer NbrsPoints)
    {
        Fidelisation__c FID = new Fidelisation__c();
        if(TypeMouvement!=null && MotifCredit!=null && NbrsPoints!=null)
        {
            FID.Type_de_mouvement__c=TypeMouvement;
            FID.Motif_de_credit__c=MotifCredit;
            FID.Points_credites__c=NbrsPoints;
            FID.Commentaire__c='Aucun bonus annuel car le foyer est freeze';
            FID.RecordTypeId = recordTypeIdFIDcredit;
            FID.Foyer__c=AccounId;
            system.debug('fiiid');
        }
        return FID;
        
    }
    
    global void finish(Database.BatchableContext bc){
        
        
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B005_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B005_SenderName);
        mail.setSubject(System.Label.BatchNotif_B005_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch005_CreditAutomatique1foisparAn s\'est terminée.\n';
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