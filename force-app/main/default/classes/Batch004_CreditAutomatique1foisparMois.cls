/*
* @author: Joyce Saidy 
* @date: 24/09/2020
* @ Description Batch pour le credit automatique des fidelisation 1 fois par mois
* @TestClass: Batch004_CreditAutomatique_Test
* @Coverage: 84 %
* History
* <Date of modification>   <Author>    <Description of modification>
   10/08/2021                ER         Corrections faites pour considérer les types d'enregistrement lors du lancement du batch (ticket MEDIAMETRIE-261)
*/ 
global class Batch004_CreditAutomatique1foisparMois implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select id,Freeze__c ,Date_d_installation__c,RecordTypeId,Date_de_recensement__c from account where Statut_du_foyer__c!=\'5\' and   Date_d_installation__c!=null'; //Changed by ER for MEDIAMETRIE-261
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<account> scope){
        system.debug('$$$ Scope ' + scope);
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        list<Fidelisation__c> listFIDtoInsert = new  list<Fidelisation__c>();
        map<string, Account> mapIdFoyerFoyer = new map<string, account>([Select id, name,
                                                                         (Select id from Fid_lisations__r
                                                                          Where   Motif_de_credit__c= :Label.FID_Motifcredit_BonusInstallation)
                                                                         From Account 
                                                                         Where ID IN: scope]); 
        Id recordTypeIdNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId(); //Added by ER for MEDIAMETRIE-261
        for(Account acc:scope)
        {
            if (acc.Freeze__c==false){
            if(mapIdFoyerFoyer.containskey(acc.id) && mapIdFoyerFoyer.get(acc.id).Fid_lisations__r.size()==0 && (GetMonthsBetween(acc.Date_d_installation__c) == 1 ) && acc.RecordTypeId != recordTypeIdNonEquipe) //Changed by ER for MEDIAMETRIE-261
            {
                system.debug('$$$ in 1');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_100)));
            }
            if(acc.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(acc.Date_d_installation__c) && acc.RecordTypeId != recordTypeIdNonEquipe) //Changed by ER for MEDIAMETRIE-261
            {
                system.debug('$$$ in 2');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_30)));
            }
            if(acc.Date_de_recensement__c!=null && (GetMonthsBetween(acc.Date_de_recensement__c) == 1 ))
            {
                system.debug('$$$ in 3');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_100)));
            } 
        }
            // YH 340
            else IF (acc.Freeze__c==true) {
            if(mapIdFoyerFoyer.containskey(acc.id) && mapIdFoyerFoyer.get(acc.id).Fid_lisations__r.size()==0 && (GetMonthsBetween(acc.Date_d_installation__c) == 1 ) && acc.RecordTypeId != recordTypeIdNonEquipe) //Changed by ER for MEDIAMETRIE-261
            {
                system.debug('$$$ in 1');
                listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_0)));
            }
            if(acc.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(acc.Date_d_installation__c) && acc.RecordTypeId != recordTypeIdNonEquipe) //Changed by ER for MEDIAMETRIE-261
            {
                system.debug('$$$ in 2');
                listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_0)));
            }
            if(acc.Date_de_recensement__c!=null && (GetMonthsBetween(acc.Date_de_recensement__c) == 1 ))
            {
                system.debug('$$$ in 3');
                listFIDtoInsert.add(NewFID_freez(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_0)));
            } 
            }
        }
        system.debug('ttttt'+listFIDtoInsert.size());
        if(listFIDtoInsert!=null && listFIDtoInsert.size()>0)
        {
            try{ 
                system.debug('im here');
               database.insert(listFIDtoInsert,true);
                system.debug('im heeere'+listFIDtoInsert);
            }catch(exception ex){
                //system.debug('Insert FID Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des fidélisation : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }  
        }
    }
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B004_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B004_SenderName);
        mail.setSubject(System.Label.BatchNotif_B004_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch004_CreditAutomatique1foisparMois s\'est terminée.\n';
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
    
    public static Fidelisation__c NewFID(ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement,String MotifCredit,Integer NbrsPoints)
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
       public static Fidelisation__c NewFID_freez(ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement,String MotifCredit,Integer NbrsPoints)
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
                                    
    public static integer GetMonthsBetween(date duedate )
    {
        decimal monthsBetweenDates = 0;
        
        if(duedate!=null && duedate <= Date.Today())
        {
            integer DaysBetween = duedate.monthsbetween(Date.Today()); 
            return DaysBetween;
        }
        else{
            return null;
        }
    }
    
    //Added by MZ for MEDIAMETRIE-203 - START
    public static Boolean IsInstalledForMoreThanAMonth(date dateInstallation) {
        if(dateInstallation != null) {
            return (GetMonthsBetween(dateInstallation) > 1) || ((dateInstallation.month() == date.today().month() - 1) && (dateInstallation.day() == date.today().day()) && (dateInstallation.year() == date.today().year()));
        } else {
            return false;
        }
    }
    //Added by MZ for MEDIAMETRIE-203 - END
    
}