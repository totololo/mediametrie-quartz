/*
* @author: Mikael Chaaya
* @date: 29/03/2023
* @ Description:un batch de clôture automatique des case de type Inactif Meter J+1
*       Si Individu_paneliste__r.Date_de_derniere_activite_mobile__c = J-1 et Individu_paneliste__r.Date_de_derniere_activite_browser__c = J-1 =>
            Clôturer le case Inactif Meter J+1 sous type Inactif mobile et browser J+1 de la Composition_foyer__c correspondant à l’Individu_paneliste__r.Composition_foyer__c

*       Si Individu_paneliste__r.Date_de_derniere_activite_mobile__c = J-1 et Individu_paneliste__r.Date_de_derniere_activite_browser__c <> J-1 => 
            Clôturer le case Inactif Meter J+1 sous type Inactif mobile J+1 de la Composition_foyer__c correspondant à l’Individu_paneliste__r.Composition_foyer__c

*       Si Individu_paneliste__r.Date_de_derniere_activite_mobile__c <> J-1 et Individu_paneliste__r.Date_de_derniere_activite_browser__c = J-1 => 
            Clôturer le case Inactif Meter J+1 sous type Inactif browser J+1 de la Composition_foyer__c correspondant à l’Individu_paneliste__r.Composition_foyer__c
* @TestClass: Batch025_ClotureAuto_Test
* @Coverage: 97%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 
*/
global class Batch025_ClotureAuto_CaseInactifMeter implements Database.Batchable<sObject> {
  //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    global List<Case> start(Database.BatchableContext bc) {
        // Query for inactive cases
        List<Case> scope = [SELECT Id, ContactId, Sous_type__c, CaseNumber FROM Case 
                            WHERE Type = :Label.CAS_Type_Inactif_Meter_J_1
                            AND Status != :Label.CAS_Statut_Cloture];
        return scope;
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        Date j0 = Date.today();
        Date j1 = Date.today() - 1;

        List<Case> casesToUpdate = new List<Case>();
        Map<Id, Case> caseMap = new Map<Id, Case>();
        List<Id> caseContactIdList = new List<Id>();
        Map<Id, Individu_paneliste__c> contactIdindivMap = new Map<Id, Individu_paneliste__c>();
        for (Case c : scope) {
            System.debug('$$$c.CaseNumber: ' + c.CaseNumber);
            caseMap.put(c.Id, c);
            caseContactIdList.add(c.ContactId);
        }
        System.debug('$$$caseContactIdList: ' + caseContactIdList);

        List<Individu_paneliste__c> individuList = [SELECT Id, Name, Date_de_derniere_activite_mobile__c, Date_de_derniere_activite_browser__c, Composition_du_foyer__c
                                                    FROM Individu_paneliste__c
                                                    WHERE Composition_du_foyer__c IN :caseContactIdList
                                                    AND ((Date_de_derniere_activite_mobile__c = YESTERDAY
                                                    OR Date_de_derniere_activite_browser__c =  YESTERDAY)
                                                        OR (Date_de_derniere_activite_mobile__c = TODAY
                                                    	OR Date_de_derniere_activite_browser__c =  TODAY))
                                                   ];

        for (Individu_paneliste__c i : individuList) {
            contactIdindivMap.put(i.Composition_du_foyer__c, i);
                
        }
        System.debug('$$$contactIdindivMap: ' + contactIdindivMap);
        
        System.debug('$$$caseMap: ' + caseMap);
        
        System.debug('$$$j0: ' + j0);
        System.debug('$$$j1: ' + j1);

        Date lastMobileActivity;
        Date lastBrowserActivity;
        for(Id key:caseMap.KeySet()){
            Case c= caseMap.get(key);
            if(contactIdindivMap.containsKey(c.ContactId)){
                Individu_paneliste__c i = contactIdindivMap.get(c.ContactId);
                lastMobileActivity=i.Date_de_derniere_activite_mobile__c;
                lastBrowserActivity=i.Date_de_derniere_activite_browser__c;
                System.debug('$$$lastMobileActivity: ' + lastMobileActivity);
                System.debug('$$$lastBrowserActivity: ' + lastBrowserActivity);

                if ((lastMobileActivity == j1 && lastBrowserActivity == j1) || (lastMobileActivity == j0 && lastBrowserActivity == j0)) {
                    System.debug('$$$Browser et Mobile');
                    // Close as Inactif mobile et browser J+1
                    c.Sous_type__c = Label.CAS_Sous_type_Inactif_mobile_browser_J_1;//Inactif mobile et browser J+1   	
                    c.Status = Label.CAS_Statut_Cloture;//	Clôturé  	
                    casesToUpdate.add(c);
                } else if ((lastMobileActivity == j1 && lastBrowserActivity != j1) || (lastMobileActivity == j0 && lastBrowserActivity != j0)) {
                    System.debug('$$$Mobile');
                    // Close as Inactif mobile J+1
                    c.Sous_type__c = Label.CAS_Sous_type_Inactif_mobile_J_1;//Inactif mobile J+1 
                    c.Status = Label.CAS_Statut_Cloture;//	Clôturé
                    casesToUpdate.add(c);
                } else if ((lastMobileActivity != j1 && lastBrowserActivity == j1) || (lastMobileActivity != j0 && lastBrowserActivity == j0)) {
                    System.debug('$$$Browser');
                    // Close as Inactif browser J+1
                    c.Sous_type__c = Label.CAS_Sous_type_Inactif_browser_J_1;//ivate	Inactif browser J+1  
                    c.Status = Label.CAS_Statut_Cloture;//	Clôturé
                    casesToUpdate.add(c);
                }
            }
        }

        if (!casesToUpdate.isEmpty()) {
            try {
                system.debug('casesToUpdate');
                system.debug(casesToUpdate);
                update casesToUpdate;
            } catch (Exception ex) {
                errorTxt += 'Erreur durant la création des controles : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                system.debug('Update case batch025 Exception Error:'+ex.getmessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        //Added for notifications - START
        List<String> toMailAddress = System.Label.BatchNotif_B025_ToAddress.split(';');
        String senderName = Label.BatchNotif_B025_SenderName;
        String subject = Label.BatchNotif_B025_Subject;
        
        String emailBody = 'L\'exécution du batch Batch025_ClotureAuto_CaseInactifMeter s\'est terminée.\n';
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