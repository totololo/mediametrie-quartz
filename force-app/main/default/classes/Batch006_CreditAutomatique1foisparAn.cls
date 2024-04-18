/*
* @author: Joyce Saidy 
* @date: 24/09/2020
* @ Description Batch pour le credit automatique des fidelisation 1 fois par An le 1er janvier - Corrigé pour être lancé chaque mois
* @TestClass: Batch004_CreditAutomatique_Test
* @Coverage: 85 %
* History
* <Date of modification>   <Author>    <Description of modification>
*   01/06/2021				 MZ			Corrections faites pour pouvoir lancer le batch chaque mois (ticket MEDIAMETRIE-203)
    10/08/2021               ER         Corrections faites pour pouvoir lancer le batch avec les foyer équipés seulement (ticket MEDIAMETRIE-261)
*/ 
global class Batch006_CreditAutomatique1foisparAn implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    //Added by MZ for MEDIAMETRIE-203 - START
    global Boolean isChristmas = (Date.Today().month() == 1); //Le bonus Noël est uniquement accordé en Janvier
    //Added by MZ for MEDIAMETRIE-203 - END
    
    //////////////////// ONLY FOR TEST PURPOSE /////////////////////////////
    public Batch006_CreditAutomatique1foisparAn(boolean isChristmas){
            this.isChristmas = isChristmas ;
        }
    ///////////////////////////////////////////////////////////////////////	
	
    public Batch006_CreditAutomatique1foisparAn(){
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeIdNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId(); //Added by ER for MEDIAMETRIE-261
        String query = 'Select Id,Freeze__c, Date_d_installation__c,Statut_du_foyer__c,  RecordTypeId from account where Date_d_installation__c!=null and Statut_du_foyer__c!=\'5\' and  RecordTypeId!=: recordTypeIdNonEquipe'; //Changed by ER for MEDIAMETRIE-261
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<account> scope){
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        list<Fidelisation__c> listFIDtoInsert = new  list<Fidelisation__c>();
        for(Account Acc :scope)
        {
            if (acc.Freeze__c==false){
            system.debug('GetyearsBetween(acc.Date_d_installation__c)#### ' + GetyearsBetween(acc.Date_d_installation__c));
            system.debug('IsAnniversaryMonth(acc.Date_d_installation__c)#### ' + IsAnniversaryMonth(acc.Date_d_installation__c));
          /*  if(acc.Date_d_installation__c!=null && (IsAnniversaryMonth(acc.Date_d_installation__c))) //&& (GetyearsBetween(acc.Date_d_installation__c) > =1))  //Changed by MZ for MEDIAMETRIE-203
            {
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_AnniversaireFoyer,integer.valueof(Label.FID_NbrPoints_100)));
            }
		  */
            
            if(isChristmas) { 
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Noel,integer.valueof(Label.FID_NbrPoints_50)));
            }
            }
            // YH 340
            else{
                /* if(acc.Date_d_installation__c!=null && (IsAnniversaryMonth(acc.Date_d_installation__c))) //&& (GetyearsBetween(acc.Date_d_installation__c) > =1))  //Changed by MZ for MEDIAMETRIE-203
            {
                listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_AnniversaireFoyer,integer.valueof(Label.FID_NbrPoints_0)));
            }*/
            
            if(isChristmas) { 
                listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Noel,integer.valueof(Label.FID_NbrPoints_0)));
            }
            }
        }
        if(listFIDtoInsert!=null && listFIDtoInsert.size()>0)
        {
            try{ 
               database.insert(listFIDtoInsert, false);
            }Catch(exception ex){
                system.debug('Insert FID Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des fidélisations : ' + ex.getMessage() + '\n';
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
         global static Fidelisation__c NewFID_freez(ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement,String MotifCredit,Integer NbrsPoints)
    {
        Fidelisation__c FID = new Fidelisation__c();
        if(TypeMouvement!=null && MotifCredit!=null && NbrsPoints!=null)
        {
            FID.Type_de_mouvement__c=TypeMouvement;
            FID.Motif_de_credit__c=MotifCredit;
            FID.Points_credites__c=NbrsPoints;
            FID.Commentaire__c='Aucun bonus mensuel car le foyer est freeze';
            FID.RecordTypeId = recordTypeIdFIDcredit;
            FID.Foyer__c=AccounId;
        }
        return FID;
    } 
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B006_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B006_SenderName);
        mail.setSubject(System.Label.BatchNotif_B006_Subject+'-'+date.today().format());
        
            
        
        String emailBody = 'L\'exécution du batch Batch006_CreditAutomatique1foisparAn s\'est terminée.\n';
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
    
    //Added by MZ for MEDIAMETRIE-203 - START
    public static Boolean IsAnniversaryMonth(date dateInstallation) {
        if(dateInstallation != null) {
            return ((dateInstallation.month() == date.today().month() - 1) && (dateInstallation.year() < date.today().year()));
        } else {
            return false;
        }
    }
    //Added by MZ for MEDIAMETRIE-203 - END
    
    public static decimal GetyearsBetween(date duedate )
    {
        decimal YearsBetweenDates = 0;
        
        if(duedate!=null && duedate < = Date.Today())
        { 
            YearsBetweenDates = (duedate.daysBetween(Date.Today())) / 365;
            system.debug('YearsBetweenDates###'+YearsBetweenDates);
            return YearsBetweenDates;
        }
        else{
            return null;
        }
    }
}