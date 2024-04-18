/*
YH 19/01/2023
batch pour créer un case retour matériel (type suivi retour materiel chute) après 46j

*/

global class Batch022_CreationRequete_RetourMateriel implements Database.Batchable<sObject>, Database.AllowsCallouts{

    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
             Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        integer jour_trait=46;
        string query = 'select id,Foyer_paneliste__c,AccountId, Account.Contact_principal__c,Contact_sur_place__c  from case where RecordTypeId =:recordTypeIdRequeteDemandePanelisteAIP and Chute_confirmee__c=true and Jour_de_traitement__c=:jour_trait';
     
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope){
        boolean inserer=false;
 		list <case> caseToInsert = new list <case>();
        set<id> idFoyPan = new set<id>();
        list<Foyer_paneliste__c> foyPanel = new list<Foyer_paneliste__c>();
        map<id,list<asset>> mapFoyAss = new map <id,list<asset>>();
        for (case cs:scope){
            idFoyPan.add(cs.Foyer_paneliste__c);
        }
       foyPanel = [select id , (select id ,status from  Equipements__r) from Foyer_paneliste__c where id in :idFoyPan];
        for (Foyer_paneliste__c foy:foyPanel){
            mapFoyAss.put(foy.id,foy.Equipements__r);
        }
        for (case cs:scope){
            for (asset equip:mapFoyAss.get(cs.Foyer_paneliste__c)){
                if (equip.status==label.ASS_Statut_Installe){
                   
					caseToInsert.add(new case(RecordTypeId=recordTypeIdRequeteDemandePanelisteAIP,Foyer_paneliste__c=cs.Foyer_paneliste__c , AccountId=cs.AccountId,Origin=Label.CAS_Origine_ProcessusDeRestitution,type=Label.CAS_Type_Suivi_Chute,Sous_type__c=Label.CAS_SousType_RestitutionDuMateriel));
					break;
                }
               
            }
        }
        
       
        if(caseToInsert.size()>0 && caseToInsert!=null){
            try{ 
                system.debug('insert'+caseToInsert);
                database.Insert(caseToInsert);
            }Catch(exception ex){
                
                errorTxt += 'Erreur durant la création des requêtes : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
        }
    }
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B022_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B022_SenderName);
        mail.setSubject(System.Label.BatchNotif_B022_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch022_CreationRequete_RetourMateriel s\'est terminée.\n';
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
    }
}