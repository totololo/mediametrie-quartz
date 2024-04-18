/*
* @author: Joyce Saidy
* @date: 10/09/2020
* @Description Batch pour mettre à le statut des requetes à cloturé partiel qui ont des contrôles non traités le jour même, le statut des controle à abandonner
et cocher le champs Requête clôturée automatiquement
* @TestClass: Batch001_ControleAbandone_Test
* @Coverage: 94 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class Batch001_ControleAbandone implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        String statutPrecode = System.Label.CTRL_Statut_Precode;
        String statutTraite = System.Label.CTRL_Statut_Traite;
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        String query = 'SELECT ID, Statut__c,Requete__c,Requete__r.RecordTypeId ' + 
            ' FROM Controle__c ' +
            ' WHERE Statut__c !=: statutTraite AND Statut__c !=: statutPrecode AND CreatedDate = TODAY '; //AND Date_de_controle__c = Today AND Requete__c!=null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Controle__c> scope){
        system.debug('$$$ Scope ' + scope);
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        list<controle__c> listControleToUpdate = new list<Controle__c>();
        list<Id> setCaseIds =  new list<Id>();
        list<case> listCases = new list<case>();
        list<case> listCasesToUpdate = new list<case>();
        for(Controle__c ctrl : scope)
        { 
            if(ctrl.Requete__c!=null && 
               ctrl.Requete__r.RecordTypeId != recordTypeIdControleAIP) {           
                setCaseIds.add(ctrl.Requete__c);
            } 
        } 
        map<string, Case> mapIdCaseToCase = new map<string, Case>([Select id,status,
                                                                   (Select id,Statut__c from Controles__r
                                                                    //where Date_de_controle__c = Today)
                                                                   Where CreatedDate = Today)
                                                                   From Case 
                                                                   Where ID IN: setCaseIds
                                                                   AND RecordTypeId!= :recordTypeIdControleAIP]);
        for(case  Cs : mapIdCaseToCase.values())
        {
            for(Controle__c ctr:mapIdCaseToCase.get(Cs.id).Controles__r)
            {
                if(ctr.Statut__c == Label.CTRL_Statut_Traite &&  Cs.status != Label.CASE_Statut_CloturePartiel)
                {
                    Cs.status = Label.CASE_Statut_CloturePartiel; 
                    Cs.Cloturee_automatiquement__c = true; 
                }
                /*else{ 
                    ctr.Statut__c = Label.CTRL_Statut_Abandone;
                    listControleToUpdate.add(ctr);
                }*/
            } 
            if(Cs.status != Label.CASE_Statut_CloturePartiel)
            {
                Cs.status = Label.CASE_Statut_ClotureNonTraite;   
                Cs.Cloturee_automatiquement__c = true; 
			}
            listCasesToUpdate.add(Cs);
        }
        for(Controle__c ctr:scope)
        {
            ctr.Statut__c = Label.CTRL_Statut_Abandone;
             listControleToUpdate.add(ctr);
        }
        if(listControleToUpdate!=null && listControleToUpdate.size()>0)
        {
            try{ 
                database.update(listControleToUpdate, false);
            }Catch(exception e){
                system.debug('Ctrl Exception Error:'+e.getmessage());
                //Added for notification
                errorTxt += 'Erreur durant la mise à jour des contrôles : ' + e.getMessage() + '\n';
                containsErrors = true;
            } 
        }
        if(listCasesToUpdate!=null && listCasesToUpdate.size()>0)
        {
            try{ 
                database.update(listCasesToUpdate, false);
            }Catch(exception ex){
                system.debug('Case Exception Error:'+ex.getmessage());
                //Added for notification
                errorTxt += 'Erreur durant la mise à jour des requêtes : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B001_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B001_SenderName);
        mail.setSubject(System.Label.BatchNotif_B001_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch001_ControleAbandone s\'est terminée.\n';
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