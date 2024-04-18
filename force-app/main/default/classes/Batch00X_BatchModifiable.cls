/*
* @author: Maribelle ZARAZIR 
* @date: 27/05/2021
* @Description : Batch utilisé pour les Tickets de TMA
* @TestClass: 
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
* 		27/05/2021			 MZ			Used as Batch004_CreditAutomatique1foisparMois - Ticket MEDIAMETRIE-187
*										Fidélisations mois d'Avril 2021
*/ 

global class Batch00X_BatchModifiable implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'Select id ,Date_d_installation__c,Date_de_recensement__c from account where Freeze__c=false and (Date_de_recensement__c!=null OR Date_d_installation__c!=null)';
        return Database.getQueryLocator(query);
    }
    
        global void execute(Database.BatchableContext bc, List<account> scope) {
        system.debug('$$$ Scope ' + scope);
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        list<Fidelisation__c> listFIDtoInsert = new  list<Fidelisation__c>();
        map<string, Account> mapIdFoyerFoyer = new map<string, account>([Select id, name, 
                                                                         (Select id from Fid_lisations__r
                                                                          Where   Motif_de_credit__c= :Label.FID_Motifcredit_BonusInstallation)
                                                                         From Account 
                                                                         Where ID IN: scope]); 
        for(Account acc:scope)
        {  
            if(mapIdFoyerFoyer.containskey(acc.id) && mapIdFoyerFoyer.get(acc.id).Fid_lisations__r.size()==0 && (acc.Date_d_installation__c.month() == 4) && (acc.Date_d_installation__c.year() == 2021))
            {
                system.debug('$$$ in 1');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_100)));
            }
            /*
            if(acc.Date_d_installation__c!=null && GetMonthsBetween(acc.Date_d_installation__c) >=2)
            {
                system.debug('$$$ in 2');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_30)));
            }
            if(acc.Date_de_recensement__c!=null && (acc.Date_de_recensement__c.month() == 4) && (acc.Date_de_recensement__c.year() == 2021))
            {
                system.debug('$$$ in 3');
                listFIDtoInsert.add(NewFID(acc.id,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_90)));
            } 
*/
        }
        if(listFIDtoInsert!=null && listFIDtoInsert.size()>0)
        {
            try{ 
               database.insert(listFIDtoInsert, false);
            }Catch(exception ex){
                system.debug('Insert FID Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des requêtes : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }  
        }
    }
    
        global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = new List<String>();
        toMailAddress.add('DSI-DCP-EIT-ReportingChargementSalesforce@mediametrie.fr');
        toMailAddress.add('tma.mediametrie@ei-technologies.com');
        toMailAddress.add('maribelle.zarazir@eit-mena.com');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName('Batch de Crédit Automatique - Avril');
        mail.setSubject('Batch de Crédit Automatique - Avril');
        
        String emailBody = 'L\'exécution du batch de Crédit Automatique (Bonus Installation - Avril) s\'est terminée.\n';
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
    /*
    public static integer GetMonthsBetween(date duedate )
    {
        decimal monthsBetweenDates = 0;
        
        if(duedate!=null && duedate <= date.newInstance(2021, 5, 1))
        {
            integer DaysBetween = duedate.monthsbetween(date.newInstance(2021, 5, 1)); 
            return DaysBetween;
        }
        else{
            return null;
        }
    }
*/
}