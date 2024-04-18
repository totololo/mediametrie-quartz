/*
* @author: Ayoub GHAMMAZ
* @date: 07/09/2021
* @ Description: Ce batch permet de Créer une requête de type vie de foyer quand les équipements ne sont pas envoies par le paneliste 
suite une requête de chute ou problème équipement
* @TestClass: Batch010_RequeteProcessusRestit_test
* @Coverage: 95%
* History
* <Date of modification>   <Author>    <Description of modification>
* */
global class Batch010_RequeteProcessusRestitution45j implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'select id , AccountId,type,Status,Foyer_paneliste__c ,(select id ,name,Foyer_paneliste__c,Requete__c,status,Date_de_desaffectation__c,Localisation__c from quipements__r where status='+'\''+Label.ASS_Statut_Desaffecte+'\''+'and localisation__c='+'\''+Label.ASS_Localisation_Foyer+'\''+') from case where (type='+'\''+Label.CAS_Type_Reclamation_Materiel+'\''+'or type='+'\''+Label.Cas_Type_DemandeChute+'\''+') and (status='+'\''+Label.CAS_Statut_En_cours+'\''+' or status='+'\''+Label.CAS_Statut_Nouveau+'\''+')';
        //String query = 'select id ,AccountId,type,Status,Foyer_paneliste__c,(select id,name,Foyer_paneliste__c,Requete__c,status,Date_de_desaffectation__c,Localisation__c from quipements__r) from case where id =\'5003H000008MO6NQAW\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Case> scope){
        //VAriables
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true; 
        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        list<Asset> ListAssetToUpdate = new list<Asset>();
        list<Asset> listAsset=new list<Asset>();
        List<Case> ListCaseToInsert = new List<Case>();
        //Logique
        for(Case cs : scope){
            system.debug('scope'+scope);
            List<Asset> ListAssetToCheck = new List<Asset>();
            system.debug('ass '+cs.quipements__r);
            if(cs.quipements__r!= null && cs.quipements__r.size()>0){
                for(Asset equ : cs.quipements__r){//Batch010_DateDesaffectation45
                    Integer nbJoursDateDesaffectation =0;
                    if(equ.Date_de_desaffectation__c!=null){// verifier combien de mois le beacon n'a pas transmit des données
                        nbJoursDateDesaffectation = equ.Date_de_desaffectation__c.daysBetween(date.today());
                        system.debug('nb jour '+nbJoursDateDesaffectation);
                    }
                    if(nbJoursDateDesaffectation > decimal.valueOf(Label.Batch010_DateDesaffectation45)){// si la date est sup a 45 jour on ajoute pour pouvoir comparer si un equipement de la requete a depasse  45j
                        system.debug('ass '+ListAssetToCheck);
                        ListAssetToCheck.add(equ);
                        listAsset.add(equ);
                    }
                }
                if(ListAssetToCheck!=null && ListAssetToCheck.size()>0){
                    ListCaseToInsert.add(new case(RecordTypeId=recordTypeIdRequeteDemandePanelisteAIP,Foyer_paneliste__c=cs.Foyer_paneliste__c , AccountId=cs.AccountId,Origin=Label.CAS_Origine_ProcessusDeRestitution,type=Label.CAS_Type_VieDuFoyer,Sous_type__c=Label.CAS_SousType_RestitutionDuMateriel));
                }
            }
            
        }
        system.debug('toinsert '+ListCaseToInsert);
        if(ListCaseToInsert.size()>0 && ListCaseToInsert!=null){
            try{ 
                database.Insert(ListCaseToInsert);
            }Catch(exception ex){
                system.debug('Insert requete (batche010) Exception Error:'+ex.getmessage());
            }
            for(Case cs :ListCaseToInsert ){
                for(Asset equ :listAsset ){
                    if(cs.Foyer_paneliste__c==equ.Foyer_paneliste__c){
                        equ.Requete__c=cs.id;
                        ListAssetToUpdate.add(equ);
                    }
                }
            }
        }
        if(ListAssetToUpdate.size()>0 && ListAssetToUpdate!=null){
            try{ 
                database.Update(ListAssetToUpdate);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la MAJ : ' + ex.getMessage() + '\n';
                containsErrors = true;
                system.debug('Update Asset (batche010) Exception Error:'+ex.getmessage());
            }
        }
        
    }
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B010_ToAddress.split(';');
     
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B010_SenderName);
        mail.setSubject(System.Label.BatchNotif_B010_Subject);
        
        String emailBody = 'L\'exécution du batch Batch010_RequeteProcessusRestitution45j s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.\n';
            
        }
        mail.setPlainTextBody(emailBody);
        if(!Test.isRunningTest()) {
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}