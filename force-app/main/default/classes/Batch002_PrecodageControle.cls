/*
* @author: Joyce Saidy/Khaled Hammoudeh EI
* @date: 11/09/2020
* @ Description Batch pour le precodage des contôles en se basant sur critères du fichier "EB - filtrage controles PRM_V3_02072020" 
* @TestClass: Batch002_PrecodageControle_Test
* @Coverage: -- %
* History
* <Date of modification>   		<Author>    		<Description of modification>
* 		18/10/2021   			Claire VEHRLE  		   Ajout des précodages pour les contrôles AIP
*/
global class Batch002_PrecodageControle implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([SELECT ID,CreatedDate, Type_de_controle__c,Resultat_joint__c,Foyer__c,Statut__c, Sous_type_de_controle__c,
                                         Date_de_controle__c, Libelle_de_pre_codage__c, Membre_du_foyer__c, Membre_du_foyer__r.Birthdate,
                                         Audimetre__c, RecordTypeId,Foyer_Paneliste__r.Suspendu__c,Foyer_Paneliste__r.Date_de_suspension__c,
                                         Foyer_Paneliste__r.statut_audimetrique__c, Foyer_Paneliste__c, Foyer__r.name
                                         FROM Controle__c
                                         WHERE (Date_de_controle__c = Today 
                                         OR CreatedDate = Today)
                                         AND Statut__c<> :Label.CTRL_Statut_Traite]);
                                          
        
    }
    
    global void execute(Database.BatchableContext bc, List<Controle__c> scope){
        system.debug('***start'+scope);
        Id ControleAIPId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id ControleMMATPaMEId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        Map<String, String> errorsMap = new Map<String, String>();
        List<Controle__c> controleListMMPaME = new List<Controle__c>();
        List<Controle__c> controleListAIP = new List<Controle__c>();
        List<Controle__c> listControleToUpdate = new List<Controle__c>();
        
        for (Controle__c ctrl: scope) {
            if (ctrl.RecordTypeId == ControleMMATPaMEId) {
                system.debug('pame');
            	controleListMMPaME.add(ctrl);
            }
            
            else if (ctrl.RecordTypeId == ControleAIPId){
                controleListAIP.add(ctrl);
            }
        }
        System.debug('***controleListAIP: ' + controleListAIP);
        
        
        if (!controleListMMPaME.isEmpty() || controleListMMPaME.size() > 0) {
            System.debug('***AP01');
            listControleToUpdate.addAll(AP01_Controle.executePrecodageControleMMPaMe(controleListMMPaME));
        }
        
        if (!controleListAIP.isEmpty() || controleListAIP.size() > 0) {
            System.debug('***AP02');
            listControleToUpdate.addAll(AP02_Controle.executePrecodageControleAIP(controleListAIP));
        }
        
                
        
        if(listControleToUpdate !=null && listControleToUpdate.size() > 0) {
            system.debug('listControleToUpdate' + listControleToUpdate);
            
            try{ //added for notification
                database.update(listControleToUpdate, false);
            } catch(Exception e) {
                errorTxt += 'Erreur durant la mise à jour des contrôles : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        
    }
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B002_ToAddress.split(';');
        String senderName = System.Label.BatchNotif_B002_SenderName;
        String subject = System.Label.BatchNotif_B002_Subject;
        
        String emailBody = 'L\'exécution du batch Batch002_PrecodageControle s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        
        AP01_SendEmail.sendEmail(toMailAddress, senderName, subject, emailBody, null);
        //Added for notifications - END
    }
   
}