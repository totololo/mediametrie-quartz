/*
* @author: Mikael Chaaya
* @date: 20/07/2023
* @Description 
* @Coverage: 94%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
global  class Batch026_ClotureCaseSansControle implements Database.Batchable<sObject> {

    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    
    
    global List<Case> start(Database.BatchableContext bc) {
        // Query for inactive cases

        List<String> typeDeMaterielList = new List<String>{Label.ASS_TypeMateriel_Setmeter,Label.ASS_TypeMateriel_Pager};
        String typeDeControleNonRepondant=Label.CAS_TypeControle_Non_Repondant;
        List<String> statusList = new List<String>{Label.CAS_Statut_Cloture,'Clôturé partiel','Clôturé non traité'};
        String refPanelAIP=Label.RFP_Nom_AIP;
        List<String> typeList = new List<String>{Label.CAS_Type_NonRepondantSetMeter,Label.CAS_Type_Non_repondant,label.CAS_Type_Non_repondant_ROAV3};

        List<Case> scope = [SELECT id, Status
                            FROM Case
                            WHERE
                                id NOT IN (Select Requete__c from Controle__c where   CreatedDate = today)
                             AND Type_de_controle__c =  :typeDeControleNonRepondant
                             AND Status  NOT IN :statusList
                             AND Foyer_paneliste__r.Referentiel_Panel__r.Name=:refPanelAIP
                             AND Type IN :typeList];
        return scope;
        /*Select id,Status, Contact_sur_place__c,  CreatedDate,Type_de_controle__c,  Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c, Type 
        from Case 
        where 
        id not in ( Select Requete__c from Controle__c where 
                    CreatedDate = today  
                    and Statut__c <>'Pré-codé' 
                    and Audimetre__r.Type_d_audimetre__c IN ('24','34') ) 
        and Type_de_controle__c = '8' 
        and Status <> 'Clôturé' 
        and Foyer_paneliste__r.Referentiel_Panel__r.Name = 'AIP' 
        AND Type IN('Non-répondant' , 'Non-répondant SetMeter') 
        Order by CreatedDate ASC
    
        */
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {

        List<Case> casesToUpdate = new List<Case>();

        for(Case c : scope){
            c.Status=Label.CAS_Statut_Cloture;
            casesToUpdate.add(c);
        }

        if(casesToUpdate != null && casesToUpdate.size() > 0){
            try{ 
                database.update(casesToUpdate);
            }Catch(exception ex){    
                 System.debug('Erreur durant casesToUpdate : ' + ex.getMessage() );
            }
        }

    }


    global void finish(Database.BatchableContext bc) {
        
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B026_ToAddress.split(';');
     
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B026_SenderName);
        mail.setSubject(System.Label.BatchNotif_B026_Subject);
        
        String emailBody = 'L\'exécution du batch Batch026_ClotureCaseSansControle s\'est terminée.\n';
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
        //Added for notifications - END
    }
}