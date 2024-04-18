/*
* @author: Jérôme HE 
* @date: 24/03/2022
* @ Description:- creation d'une requete de chute pour les requetes dont jour de traitement > 90
*				- creation d'une tâche pour les requete dont jour de traitement > 70
* @TestClass: 
* @Coverage: 82%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 10-1-2023                     Mikael chaaya		Correction start querry and added conge
*/
global class Batch017_InstallControlesSoftMeters implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    global List<Foyer_paneliste__c> start(Database.BatchableContext bc) {
        List<Foyer_paneliste__c> softMeterList = [SELECT id , Foyer__c,Foyer__r.Contact_principal__c,name,
                                                  (SELECT id,Jour_de_traitement__c,ContactId
                                                   FROM Requetes__r
                                                   where Status <> :label.CAS_Statut_Cloture and (Jour_de_traitement__c=:Decimal.valueOf(label.CAS_Jour_De_Traitement_70) or Jour_de_traitement__c=:Decimal.valueOf(label.CAS_Jour_De_Traitement_90)) And type=:label.CAS_Type_Inactif_Meter_J_1
                                                  ),
                                                  (SELECT id ,name,Date_de_derniere_activite_browser__c,Date_de_derniere_activite_mobile__c, Composition_du_foyer__c
                                                   FROM Panelistes__r)
                                                  FROM Foyer_paneliste__c 
                                                  where Referentiel_Panel__r.Type_de_panel__c =:label.RFP_TypePanel_PaME 
                                                  AND 
                                                  Intervention_en_cours__c = false
                                                  and Statut_Audimetrique__c!=:label.PAN_Statut_Audimetrique_EnVacance
                                                  and Statut_Foyer_paneliste__c    !=:label.PAN_StatusPan_ChuteTemp
                                                  and Motif_de_suspension__c !=:label.PAN_Motif_de_Suspension_Demenagement
                                                  and Statut_Foyer_paneliste__c !=:label.PAN_StatusPan_ChuteDefinitive
                                                  and Id in 
                                                  (SELECT Foyer_paneliste__c 
                                                   FROM Individu_Paneliste__c 
                                                   where Composition_du_foyer__r.Type__c !=:label.Acc_Type_invite and
                                                   ((Composition_du_foyer__r.Frequence_de_connexion_ordinateur__c in (:label.Acc_Freq_Conx_Ordi_TousLesJours,:label.Acc_Freq_Conx_Ordi_PresqueTousLesJours) and Date_de_derniere_activite_browser__c != today and Date_de_derniere_activite_browser__c != null)
                                                    or ((Composition_du_foyer__r.Frequence_de_connexion_mobile__c in (:label.Acc_Freq_Conx_Mobile_TousLesJours , :label.Acc_Freq_Conx_Mobile_PresqueTousLesJours) or Composition_du_foyer__r.Frequence_de_connexion_tablette__c in (:label.Acc_Freq_Conx_Tablette_TousLesJours,:label.Acc_Freq_Conx_Tablette_PresqueTousLesJours)) and Date_de_derniere_activite_mobile__c != today and Date_de_derniere_activite_mobile__c != null) ))
                                                 
                                                 ];
        
        
        return softMeterList;
    }
    
    global void execute(Database.BatchableContext bc, List<Foyer_paneliste__c> scope){
        System.debug('***scope: ' + scope);
        date today = date.today();
        boolean RouteurOn = false;
        
        list<Task> ListtaskToInsert = new list<Task>();
        list<Case> listCaseToInsert = new list<Case>();
        
        user logistique = [select id , username ,name from user where username=:label.Mulesoft_integrationUser_username];
        
        Id recordTypeIdRequeteDemandePaneliste =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePaneliste).getRecordTypeId();
        Id recordTypeIdRequeteControle = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();
        Id recordTypeIdEquipementDuFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        
        Set<Id> setFoyerId = new Set<Id>();
        Set<Id> setIdCompoFoyerATesterId = new Set<Id>();
        Set<Id> setIdCompoFoyerId = new Set<Id>();
        List<Case> requeteOuverteList = new list<Case>();
        //List<Equipement_du_foyer_de_l_individu__c> utlisateurDeviceList = new List<Equipement_du_foyer_de_l_individu__c>();
        List<Equipements_du_foyer__c> utilisateurPrincipaleDeviceList = new List<Equipements_du_foyer__c>();
        Map<Id, String> compoFoyersousTypeMap = new Map<Id, String>();
        
        
        for(Foyer_paneliste__c fp : scope){
            setFoyerId.add(fp.Foyer__c);   
        }
                
        for(Foyer_paneliste__c fp : scope){
            for(Individu_paneliste__c indPan : fp.Panelistes__r){
                setIdCompoFoyerATesterId.add(indPan.Composition_du_foyer__c);
            }
        }
        System.debug('***setIdCompoFoyerATesterId: ' + setIdCompoFoyerATesterId);
        
        utilisateurPrincipaleDeviceList =  [SELECT Id, Utilisateur_principal__r.Frequence_de_connexion_ordinateur__c,Utilisateur_principal__r.Frequence_de_connexion_tablette__c,
                                            Utilisateur_principal__r.Frequence_de_connexion_mobile__c, type__c, Utilisateur_principal__c
                                            FROM Equipements_du_foyer__c WHERE Utilisateur_principal__c IN :setIdCompoFoyerATesterId ];
        
        System.debug('***utilisateurPrincipaleDeviceList: ' + utilisateurPrincipaleDeviceList);
        for(Equipements_du_foyer__c eqtF: utilisateurPrincipaleDeviceList) {
            if ((eqtF.Utilisateur_principal__r.Frequence_de_connexion_ordinateur__c == '1' || eqtF.Utilisateur_principal__r.Frequence_de_connexion_ordinateur__c =='2')
                && (eqtF.type__c == Label.EQF_Type_OrdinateurPortable || eqtF.type__c == Label.EQF_Type_OrdinateurFixe)) {
                    if (compoFoyersousTypeMap.get(eqtF.Utilisateur_principal__c) != null) {
                        if(compoFoyersousTypeMap.get(eqtF.Utilisateur_principal__c) == label.CAS_Sous_type_Inactif_mobile_J_1) {
                            compoFoyersousTypeMap.put(eqtF.Utilisateur_principal__c, label.CAS_Sous_type_Inactif_mobile_browser_J_1);
                            setIdCompoFoyerId.add(eqtF.Utilisateur_principal__c);
                        }
                    }
                    else {
                        compoFoyersousTypeMap.put(eqtF.Utilisateur_principal__c, label.CAS_Sous_type_Inactif_browser_J_1);
                        setIdCompoFoyerId.add(eqtF.Utilisateur_principal__c);
                    }
                    
                }
            if(((eqtF.Utilisateur_principal__r.Frequence_de_connexion_mobile__c == '1'|| eqtF.Utilisateur_principal__r.Frequence_de_connexion_mobile__c == '2')
                && eqtF.type__c == Label.EQF_Type_Smartphone) 
               ||
               ((eqtF.Utilisateur_principal__r.Frequence_de_connexion_tablette__c == '1' || eqtF.Utilisateur_principal__r.Frequence_de_connexion_tablette__c =='2')
                && eqtF.type__c == Label.EQF_Type_Tablette)) {
                    if (compoFoyersousTypeMap.get(eqtF.Utilisateur_principal__c) != null) {
                        if(compoFoyersousTypeMap.get(eqtF.Utilisateur_principal__c) == label.CAS_Sous_type_Inactif_browser_J_1) {
                            compoFoyersousTypeMap.put(eqtF.Utilisateur_principal__c, label.CAS_Sous_type_Inactif_mobile_browser_J_1);
                            setIdCompoFoyerId.add(eqtF.Utilisateur_principal__c);
                        }
                    }
                    else {
                        compoFoyersousTypeMap.put(eqtF.Utilisateur_principal__c, label.CAS_Sous_type_Inactif_mobile_J_1);
                        setIdCompoFoyerId.add(eqtF.Utilisateur_principal__c);
                    }
                }
        }
        
        //TMASF-31 EN attente
        /*
        utlisateurDeviceList =  [SELECT Id, composition_du_foyer__r.Frequence_de_connexion_ordinateur__c,Composition_du_foyer__r.Frequence_de_connexion_tablette__c,
                                 Composition_du_foyer__r.Frequence_de_connexion_mobile__c, Equipement_du_foyer__r.type__c
                                 FROM Equipement_du_foyer_de_l_individu__c WHERE composition_du_foyer__c IN :setIdCompoFoyerATesterId AND Utilisation_de_l_equipement__c = 'Oui'];
        
        System.debug('***utlisateurDeviceList: ' + utlisateurDeviceList);
        for(Equipement_du_foyer_de_l_individu__c eqtInd: utlisateurDeviceList) {
            if ((eqtInd.composition_du_foyer__r.Frequence_de_connexion_ordinateur__c == '1' || eqtInd.composition_du_foyer__r.Frequence_de_connexion_ordinateur__c =='2')
                && (eqtInd.Equipement_du_foyer__r.type__c == Label.EQF_Type_OrdinateurPortable || eqtInd.Equipement_du_foyer__r.type__c == Label.EQF_Type_OrdinateurFixe)) {
                    if (compoFoyersousTypeMap.get(eqtInd.Composition_du_foyer__c) != null) {
                        if(compoFoyersousTypeMap.get(eqtInd.Composition_du_foyer__c) == label.CAS_Sous_type_Inactif_mobile_J_1) {
                            compoFoyersousTypeMap.put(eqtInd.Composition_du_foyer__c, label.CAS_Sous_type_Inactif_mobile_browser_J_1);
                            setIdCompoFoyerId.add(eqtInd.Composition_du_foyer__c);
                        }
                    }
                    else {
                        compoFoyersousTypeMap.put(eqtInd.Composition_du_foyer__c, label.CAS_Sous_type_Inactif_browser_J_1);
                        setIdCompoFoyerId.add(eqtInd.Composition_du_foyer__c);
                    }
                    
                }
            if(((eqtInd.Composition_du_foyer__r.Frequence_de_connexion_mobile__c == '1'|| eqtInd.Composition_du_foyer__r.Frequence_de_connexion_mobile__c == '2')
                && eqtInd.Equipement_du_foyer__r.type__c == Label.EQF_Type_Smartphone) 
               ||
               ((eqtInd.Composition_du_foyer__r.Frequence_de_connexion_tablette__c == '1' || eqtInd.Composition_du_foyer__r.Frequence_de_connexion_tablette__c =='2')
                && eqtInd.Equipement_du_foyer__r.type__c == Label.EQF_Type_Tablette)) {
                    if (compoFoyersousTypeMap.get(eqtInd.Composition_du_foyer__c) != null) {
                        if(compoFoyersousTypeMap.get(eqtInd.Composition_du_foyer__c) == label.CAS_Sous_type_Inactif_browser_J_1) {
                            compoFoyersousTypeMap.put(eqtInd.Composition_du_foyer__c, label.CAS_Sous_type_Inactif_mobile_browser_J_1);
                            setIdCompoFoyerId.add(eqtInd.Composition_du_foyer__c);
                        }
                    }
                    else {
                        compoFoyersousTypeMap.put(eqtInd.Composition_du_foyer__c, label.CAS_Sous_type_Inactif_mobile_J_1);
                        setIdCompoFoyerId.add(eqtInd.Composition_du_foyer__c);
                    }
                }
        }*/
        
        System.debug('***setIdCompoFoyerId: ' + setIdCompoFoyerId);
        //Pas de requêtes déjà ouvertes
        requeteOuverteList = [SELECT Id, ContactId 
                              FROM Case 
                              WHERE (ContactId IN :setIdCompoFoyerId)
                              AND Type = :label.CAS_Type_Inactif_Meter_J_1
                              AND (Sous_type__c = :label.CAS_Sous_type_Inactif_mobile_browser_J_1 
                                   OR Sous_type__c = :label.CAS_Sous_type_Inactif_browser_J_1
                                   OR Sous_type__c = :label.CAS_Sous_type_Inactif_mobile_J_1)
                             AND Status != :Label.CAS_Statut_Cloture];
        
        for(Case requete : requeteOuverteList){
            setIdCompoFoyerId.remove(requete.ContactId);   
        }
        
        System.debug('***setIdCompoFoyerId: ' + setIdCompoFoyerId);
        //Pas de congé en cours
        List<Conge__c> temp = new List<Conge__c>([Select Conge_de_l_individu__c from Conge__c where  isCongeEnCours__c=True and Conge_de_l_individu__c IN: setIdCompoFoyerId ]);
        for (Conge__c c: temp){
            setIdCompoFoyerId.remove(c.Conge_de_l_individu__c);
        }
        
        System.debug('***setIdCompoFoyerId: ' + setIdCompoFoyerId);
        System.debug('***compoFoyersousTypeMap: ' + compoFoyersousTypeMap);
        //Utilisateur d'un device
        
        
        
        for(Foyer_paneliste__c fp : scope){
            
            
            for(Individu_paneliste__c indPan : fp.Panelistes__r){
                //Mikael
                if(setIdCompoFoyerId.contains(indPan.Composition_du_foyer__c)){
                    
                    
                    Integer daysDerniereActiviteBrowser = null;
                    Integer daysDerniereActiviteMobile = null;
                                   
                    
                    if(indPan.Date_de_derniere_activite_browser__c != null){
                        daysDerniereActiviteBrowser = today.daysBetween(indPan.Date_de_derniere_activite_browser__c);
                    }
                    
                    if(indPan.Date_de_derniere_activite_mobile__c != null){
                        daysDerniereActiviteMobile = today.daysBetween(indPan.Date_de_derniere_activite_mobile__c);
                    }
                                        
                    if((daysDerniereActiviteBrowser != null || daysDerniereActiviteMobile  != null) && compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c) != null) {
                        
                        String sousType;
                        if((daysDerniereActiviteBrowser == -2) && (daysDerniereActiviteMobile  != -2) && compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c) == label.CAS_Sous_type_Inactif_browser_J_1){
                            SousType = compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c);
                        } else if((daysDerniereActiviteMobile  == -2) && (daysDerniereActiviteBrowser != -2) && compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c) == label.CAS_Sous_type_Inactif_mobile_J_1) {
                            SousType = compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c);
                        } else if((daysDerniereActiviteMobile  == -2) && (daysDerniereActiviteBrowser == -2) && compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c) == label.CAS_Sous_type_Inactif_mobile_browser_J_1) {
                            SousType = compoFoyersousTypeMap.get(indPan.Composition_du_foyer__c);
                        }
                        if(SousType != null){
                            Case newCase = new Case();
                            newCase.RecordTypeId= recordTypeIdRequeteControle;
                            newCase.Foyer_paneliste__c=fp.id;
                            newCase.AccountId=fp.foyer__c;
                            newCase.Type=label.CAS_Type_Inactif_Meter_J_1;
                            newCase.Sous_type__c=SousType;
                            newCase.ContactId=indPan.Composition_du_foyer__c;
                            newCase.Contact_sur_place__c=fp.Foyer__r.Contact_principal__c;
                            newCase.Origin = label.CAS_Origine_Controle;
                            newCase.Priority = Label.CAS_Priorite_Moyen;
                            listCaseToInsert.add(newCase);
                        }
                        
                    }
                    
                }
            }
            
            // requetes
            System.debug('fp.requetes__r');
            System.debug(fp.requetes__r);
            for(Case req : fp.requetes__r){
                System.debug('req.Jour_de_traitement__c');
                System.debug(req.Jour_de_traitement__c);
                if(req.Jour_de_traitement__c == 70){
                    
                    Task newTask = new Task();// creer une nouvelle tache
                    newTask.WhoId = fp.Foyer__r.Contact_principal__c ;
                    newTask.WhatId = fp.Foyer__c;
                    newTask.Subject = Label.TSK_Subject_EnvoyerCourrier;
                    newTask.OwnerId=logistique.id;
                    newTask.ActivityDate = date.today();
                    ListtaskToInsert.add(newTask);
                }
                if(req.Jour_de_traitement__c == 90){
                    
                    Case CaseChute = new Case();
                    CaseChute.RecordTypeId= recordTypeIdRequeteDemandePaneliste;
                    CaseChute.Foyer_paneliste__c=fp.id;
                    CaseChute.AccountId=fp.foyer__c;
                    CaseChute.ContactId=req.ContactId;
                    CaseChute.Contact_sur_place__c=fp.Foyer__r.Contact_principal__c;
                    CaseChute.Origin = label.CAS_Origine_Controle;
                    CaseChute.type=Label.CAS_Type_J_90;
                    CaseChute.Sous_type__c = Label.CAS_Sous_type_Foyer_inactif_meter_J_90;
                    CaseChute.Priority = Label.CAS_Priorite_Moyen;
                    listCaseToInsert.add(CaseChute);
                }
            }                  
            
            RouteurOn = false;
        }
        
        if(listCaseToInsert!=null && listCaseToInsert.size()>0){// insert the new cases
            system.debug('Inserting case');
            try{ 
                database.insert(listCaseToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la création des contrôles : ' + ex.getMessage() + '\n';
                containsErrors = true;
                system.debug('insert case batch017 Exception Error:'+ex.getmessage());
            }
        }
        
        if(ListtaskToInsert!=null && ListtaskToInsert.size()>0){// insert the new tasks
            try{ 
                database.insert(ListtaskToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la création des taches : ' + ex.getMessage() + '\n';
                containsErrors = true;
                system.debug('insert task batch017 Exception Error:'+ex.getmessage());
            }
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B017_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B017_SenderName);
        mail.setSubject(System.Label.BatchNotif_B017_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch017_InstallControlesSoftMeters s\'est terminée.\n';
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