/*
* @date: 21/09/2021
* @ Description : 	-ouverture d'une requete de type welcome call quand le foyer paneliste est au status recruté apres 7 jours de sa creation
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: Batch011_CreationRequeteWelcomeCal_Test
* @Coverage: 97%
History
* <Date of modification> <Author> 	<Description of modification>
*Modif Mikael 15-12-22             L23-->L36
*/
global class Batch011_CreationRequeteWelcomeCal implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        String query = 'select id , Foyer__c,Date_de_creation__c from foyer_paneliste__c where Statut_Foyer_paneliste__c='+'\''+Label.PAN_Statut_panel+'\'and RecordTypeid='+'\''+recordTypeIdPanelAIP+'\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Foyer_paneliste__c> scope){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true; 
        list<Case> ListCaseToInsert = new List<Case>();
        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
		Set<String> fpIdSet=new Set<String>();        
        for (foyer_paneliste__c fp : scope){
            fpIdSet.add(fp.Id);
        }
        
        List<Case> oldWelcomeCaseList=[Select Id,Foyer_paneliste__c from case where Foyer_paneliste__c IN:fpIdSet AND Sous_type__c =: Label.CAS_Sous_type_WelcomeCall];
        
        Set<String> fdIdToAvoidSet=new Set<String>();
        for(Case c:oldWelcomeCaseList){
            fdIdToAvoidSet.add(c.Foyer_paneliste__c);
        }
        
        for(Foyer_paneliste__c fp : scope){
            if(!fdIdToAvoidSet.contains(fp.Id)){
                Integer nbJoursOuverture =0;
                if(fp.Date_de_creation__c!=null){// verifier combien de jours aprs l'ouverture du foyer paneliste
                    nbJoursOuverture = fp.Date_de_creation__c.daysBetween(date.today());
                }
                if(nbJoursOuverture>=decimal.valueOf(Label.Batch011_NBJours7)){// verifier si on a depasse le 7 eme jours 
                    ListCaseToInsert.add( new case(RecordTypeId = recordTypeIdRequeteDemandePanelisteAIP,
                                               Origin = Label.CAS_Origine_NouveauFoyer,
                                               AccountId=fp.Foyer__c,
                                               Foyer_paneliste__c = fp.id,
                                               Type = Label.CAS_Type_Recrute,
                                               Sous_type__c = Label.CAS_Sous_type_WelcomeCall
                                              ));
                }
            }
        }
        if(ListCaseToInsert.size()>0 && ListCaseToInsert !=null){
            try{ 
                database.insert(ListCaseToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la Création des requêtes WC : ' + ex.getMessage() + '\n';
                containsErrors = true;
                system.debug('Insert case Exception Error:'+ex.getmessage());
            }
        }
    }
    global void finish(Database.BatchableContext bc){
      //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B011_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B011_SenderName);
        mail.setSubject(System.Label.BatchNotif_B011_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch011_CreationRequeteWelcomeCal s\'est terminée.\n';
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