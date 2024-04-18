/*
* @author: Joyce Saidy 
* @date: 21/09/2020
* @ Description Batch pour le création des requêtes de type contrôle 
* @TestClass: Batch003_CreationRequeteControle_Test
* @Coverage: 90 %
* History
* <Date of modification>  		 <Author>   		 <Description of modification>
* 		30/03/2021	 	    	 Elio Bou Habib  		Mise en place de critères de priorisation pour les rapports et les vues de listes associées
* 		06/10/2021   			Claire VEHRLE  		   Création des requêtes pour les contrôle de type Contrôle AIP
* 		23/08/2023   			Claire VEHRLE  		   Nouveau contrôle SetMeter

*	
*/

global class Batch003_CreationRequeteControle implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    /*Functions to get label of the picklist values*/
    public String getSousTypeLabel(String apiName) {
        String label;
        Schema.DescribeFieldResult sousTypeControle = Controle__c.Sous_type_de_controle__c.getDescribe();
        if (!apiName.isNumeric()) {
            label = apiName;
        } else {
            for (Schema.PicklistEntry valeur : sousTypeControle.getPicklistValues()) {
                if (valeur.getValue() == apiName) {
                    label = valeur.getLabel();
                    break;
                }
            }           
        }
        return label; 
    }
    
    public String getTypeLabel(String apiName) {
        String label;
        Schema.DescribeFieldResult typeControle = Controle__c.Type_de_controle__c.getDescribe();
        if (!apiName.isNumeric()) {
            label = apiName;
        } else {
            for (Schema.PicklistEntry valeur : typeControle.getPicklistValues()) {
                if (valeur.getValue() == apiName) {
                    label = valeur.getLabel();
                    break;
                }
            }           
        }
        return label; 
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeIdControleMediamatPaME =Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        Id recordTypeIdControleAIP =Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        
        //label de precodage a prendre
        List<String> libelleList = new List<String>{Label.CTRL_LibellePrecodage_Dimanche ,Label.CTRL_LibellePrecodage_JourFerie ,Label.CTRL_LibellePrecodage_Appel_Hier};
            
            return Database.getQueryLocator( [Select id, name, Foyer__c, Foyer__r.Single_source__c, Foyer__r.Personne_de_reference__c, Requete__c, RecordType.Name, 
                                              Type_de_controle__c, Sous_type_de_controle__c, Tech_Priority__c, Rep_ou_non_rep__c, foyer_paneliste__c,Referentiel_alarme__r.Name, Libelle_de_pre_codage__c, Audimetre__r.Product2.Name
                                              FROM Controle__c  
                                              where 
                                              ( 
                                                  (RecordTypeId =:recordTypeIdControleAIP
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_FoyerSansAudienceDepuis4Jours 
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_FoyerSansAudienceDepuisPlus4Jours
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_IndividusSansAudienceDepuis4Jours 
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_IndividusSansAudienceDepuisPlus4Jours 
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_AnomalieBasePanel
                                                   AND Sous_type_de_controle__c != :Label.CTRL_SousType_NonEnvoyeMediamat
                                                   AND Type_de_controle__c != :Label.CTRL_TypeAutresUsages
                                                   AND Type_de_controle__c != :Label.CTRL_Type_Reception_abonnement
                                                   AND Type_de_controle__c != :Label.CTRL_Type_Foyer_Vacancier
                                                   AND Type_de_controle__c != :Label.CTRL_Type_ParticipationWeb
                                                   AND Type_de_controle__c != :Label.CTRL_Type_FoyerVacancierLongueDuree 
                                                   AND Statut__c != :Label.CTRL_Statut_Precode
                                                   AND CreatedDate = today and Requete__c = null and Foyer__r.Single_source__c=false
                                                   //mikael
                                                   AND Audimetre__r.Type_de_materiel__c =:Label.ASS_TypeMateriel_Pager 
                                                  )
                                                  OR(Statut__c != :Label.CTRL_Statut_Precode
                                                     AND RecordTypeId =:recordTypeIdControleAIP
                                                     AND Type_de_controle__c = :Label.CTRL_Type_InstallationSetMeter
                                                     AND CreatedDate = today and Requete__c = null and Foyer__r.Single_source__c=false)
                                                  OR (
                                                      RecordTypeId =:recordTypeIdControleMediamatPaME
                                                      AND Statut__c != :Label.CTRL_Statut_Precode
                                                      AND CreatedDate = today and Requete__c = null and Foyer__r.Single_source__c=false 
                                                  )
                                                  //Mikael TMASF-144
                                                  OR (
                                                      RecordTypeId =:recordTypeIdControleAIP
                                                      AND Statut__c = :Label.CTRL_Statut_Precode
                                                      AND Requete__c = null and Foyer__r.Single_source__c=false 
                                                      AND Libelle_de_pre_codage__c IN :libelleList
                                                      AND CreatedDate = today
                                                      AND Audimetre__r.Type_de_materiel__c =:Label.ASS_TypeMateriel_Pager
                                                  )
                                              )]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Controle__c> scope){
        
        system.debug('$$$ scope size ' + scope.size());
        Id recordTypeIdRequeteControle =Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();
        Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        map<string, list<case>> mapIdFoyerRequete = new map<string, list<case>>();
        list<case> listCaseToInsert = new list<case>();
        //Added by Elio Bou Habib - ticket MEDIAMETRIE-9
        list<case> listCaseToUpdate = new list<case>();
        //ticket MEDIAMETRIE-9
        list<Controle__c> listControleToUpdate = new list<Controle__c>();
        set<string> setIdFoyer = new set<string>();
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        //mikael
        map<string,String> mapIdFoyerToControlSousType=new map<string,String>();
        
        //Mikael 07-09-2023
        User userAdmMM= [Select id from User where Name Like 'Administrateur Requête Médiamétrie' limit 1];
        
        for(Controle__c ctrl: scope) {
            
            setIdFoyer.add(ctrl.Foyer__c);
            //mikael
            if(ctrl.Sous_type_de_controle__c==Label.CTRL_SousType_PagerOff){
                mapIdFoyerToControlSousType.put(ctrl.Foyer__c,'1');
            }
            else if(ctrl.Sous_type_de_controle__c==Label.CTRL_SousType_AbsenceCollecte && mapIdFoyerToControlSousType.get(ctrl.Foyer__c)!='1'){
                mapIdFoyerToControlSousType.put(ctrl.Foyer__c,'2');
            }
            else if(ctrl.Sous_type_de_controle__c==Label.CTRL_SousType_Pager_eteint_trop_longtemps && mapIdFoyerToControlSousType.get(ctrl.Foyer__c)!='1' && mapIdFoyerToControlSousType.get(ctrl.Foyer__c)!='2'){
                mapIdFoyerToControlSousType.put(ctrl.Foyer__c,'3');
            }
            else if(ctrl.Sous_type_de_controle__c==Label.CTRL_SousType_AbsenceMouvement){
                mapIdFoyerToControlSousType.put(ctrl.Foyer__c,'4');
            }
            else{
                mapIdFoyerToControlSousType.put(ctrl.Foyer__c,'5');
            }
            //fin mikael
        }
        
        list<Account> listAccounts = [SELECT id, name, 
                                      (SELECT id,Rep_ou_non_rep__c,Sous_type_de_controle__c,Status,AccountId, Tech_Priority__c,Type_de_controle__c,Nombre_de_controles__c, RecordTypeId 
                                       FROM Cases
                                       //case non repondant seulement
                                       WHERE ((Status = :Label.CAS_Statut_Nouveau OR Status = :Label.CAS_Statut_En_cours OR Status= : Label.CAS_Status_Traite) 
                                              AND (Type =:Label.CAS_Type_Non_repondant 
                                                   OR Type = :Label.CAS_Type_InstallationSetMeter
                                                   OR Type = :Label.CAS_Type_Non_repondant_ROAV3)) 
                                       ORDER BY AccountId)
                                      FROM Account 
                                      WHERE ID IN: setIdFoyer];
        
        /*system.debug('$$$222');*/
        for(Account acc : listAccounts) {
            
            if(!mapIdFoyerRequete.containsKey(acc.Id)) {
                mapIdFoyerRequete.put(acc.Id, new list<case>());
            }
            if(acc.cases.size() > 0) {
                for(Case requete: acc.Cases) {
                    mapIdFoyerRequete.get(acc.Id).add(requete);
                }
            }
        }
        
        /*System.debug('scope: ' + scope);*/
        for(Controle__c ctrl: scope) {
            Boolean mapIdFoyerRequeteListIsNull = false;
            Boolean requeteWithSameRecordType = false;
            /*System.debug('MC');
System.debug('mapIdFoyerRequete.get(ctrl.foyer__c)');	
System.debug(mapIdFoyerRequete.get(ctrl.foyer__c));	*/
            if ((mapIdFoyerRequete.get(ctrl.foyer__c)== null || mapIdFoyerRequete.get(ctrl.foyer__c).isEmpty() ||
                 mapIdFoyerRequete.get(ctrl.foyer__c).size() == 0) && ctrl.Libelle_de_pre_codage__c==null) {
                     mapIdFoyerRequeteListIsNull = true;
                 }
            else {
                for (Case requete: mapIdFoyerRequete.get(ctrl.foyer__c)) {
                    if((ctrl.RecordType.Name == Label.CTRL_RecordType_ControleMediamat_PaME && requete.RecordtypeId == recordTypeIdRequeteControle && ctrl.Type_de_controle__c == requete.Type_de_controle__c) ||
                       (ctrl.RecordType.Name == Label.CTRL_RecordType_ControleAIP && requete.RecordtypeId == recordTypeIdRequeteControleAIP)) {
                           requeteWithSameRecordType = true;
                       }
                }
            }
            
            
            if(mapIdFoyerRequeteListIsNull || !requeteWithSameRecordType) {
                Case req = new case();                
                
                if (ctrl.RecordType.Name == Label.CTRL_RecordType_ControleMediamat_PaME) {
                    req.RecordtypeId = recordTypeIdRequeteControle;
                    if (ctrl.Type_de_controle__c==label.CTRL_Type_NonRepondant){
                        req.Type = Label.CAS_Type_Non_repondant;
                    }
                    else{
                        req.Type=getTypeLabel(ctrl.Type_de_controle__c);
                    }
                    
                    
                    
                }
                else if (ctrl.RecordType.Name == Label.CTRL_RecordType_ControleAIP) {
                    req.RecordtypeId = recordTypeIdRequeteControleAIP;
                    if (ctrl.Type_de_controle__c == Label.CTRL_Type_InstallationSetMeter) {
                        req.Type = Label.CAS_Type_InstallationSetMeter;
                        if(ctrl.Sous_type_de_controle__c == Label.CTRL_SousType_IndiceQualiteFaible) {
                            req.sous_type__c = Label.CAS_Sous_type_Indice_Qualite_Faible;
                        }
                    }
                    else if (ctrl.Audimetre__r.Product2.Name.containsIgnoreCase(label.Product_ROAV3)
                             || ctrl.Audimetre__r.Product2.Name.containsIgnoreCase(label.Product_ROA_V3)){
                                 req.type = label.CAS_Type_Non_repondant_ROAV3;
                             }
                    else {
                        req.Type = Label.CAS_Type_Non_repondant;
                    }
                }
                
                req.Origin = label.CAS_Recordtype_Controle;
                req.AccountId = ctrl.Foyer__c;
                req.ContactId = ctrl.Foyer__r.Personne_de_reference__c;
                req.foyer_paneliste__c = ctrl.foyer_paneliste__c;
                req.Priority = Label.CAS_Priorite_Moyen;
                req.Status = Label.CAS_Statut_Nouveau;
                req.setOptions(dmo);
                if(ctrl.Tech_Priority__c==null){
                    ctrl.Tech_Priority__c='1';
                }
                //Added by Elio Bou Habib - ticket MEDIAMETRIE-9
                if(ctrl.Tech_Priority__c!=null) {
                    
                    req.Tech_Priority__c = ctrl.Tech_Priority__c;
                    req.Type_de_controle__c = ctrl.Type_de_controle__c;  //Modification : ajout en default du type non repondant
                    req.Sous_type_de_controle__c = ctrl.Sous_type_de_controle__c;
                    req.Rep_ou_non_rep__c = ctrl.Rep_ou_non_rep__c;
                }
                //ticket MEDIAMETRIE-9
                if (ctrl.Sous_type_de_controle__c != null) {
                    req.Subject = getSousTypeLabel(ctrl.Sous_type_de_controle__c);
                    //mikael
                    req.Sous_type__c=getSousTypeLabel(ctrl.Sous_type_de_controle__c);       
                } else if (ctrl.Type_de_controle__c != null) {
                    req.Subject = getTypeLabel(ctrl.Type_de_controle__c);
                }
                
                listCaseToInsert.add(req);
                if (mapIdFoyerRequete.get(ctrl.foyer__c)== null || mapIdFoyerRequete.get(ctrl.foyer__c).isEmpty() ||
                    mapIdFoyerRequete.get(ctrl.foyer__c).size() == 0) {
                        mapIdFoyerRequete.put(ctrl.Foyer__c, new list<case>{req});
                    }
                else{
                    mapIdFoyerRequete.get(ctrl.Foyer__c).add(req);
                }
            }
            else {
                if(ctrl.Tech_Priority__c==null){
                    ctrl.Tech_Priority__c='1';
                }
                //Added by Elio Bou Habib - ticket MEDIAMETRIE-9
                Case req = mapIdFoyerRequete.get(ctrl.foyer__c)[0];
                
                if(String.isNotBlank(ctrl.Tech_Priority__c) &&
                   (String.isBlank(req.Tech_Priority__c) ||
                    Integer.valueOf(req.Tech_Priority__c) > Integer.valueOf(ctrl.Tech_Priority__c)))
                {
                    //req.sousType=ctrl.soustypedecontrole_c;
                    req.Tech_Priority__c = ctrl.Tech_Priority__c;  
                    req.Type_de_controle__c = ctrl.Type_de_controle__c;
                    req.Sous_type_de_controle__c = ctrl.Sous_type_de_controle__c; 
                    req.Rep_ou_non_rep__c = ctrl.Rep_ou_non_rep__c;
                    if(req.Status== Label.CAS_Status_Traite){
                        req.Status=Label.CAS_Statut_Nouveau;
                        req.OwnerId=userAdmMM.Id;
                    }
                    listCaseToUpdate.add(req);
                }
                //Mikael TMASF-508
                else{
                    if(req.Status== Label.CAS_Status_Traite){
                        req.Status=Label.CAS_Statut_Nouveau;
                        req.OwnerId=userAdmMM.Id;
                    }
                }
                
                ctrl.Requete__c = req.Id;
            }
            
            listControleToUpdate.add(ctrl); 
        }
        /*System.debug('MC listCaseToInsert'+listCaseToInsert);
for (Case cs: listCaseToInsert){
System.debug(cs);
}*/
        if(listCaseToInsert != null && listCaseToInsert.size() > 0) {
            try{ 
                database.insert(listCaseToInsert);
            }Catch(exception ex){
                system.debug('Insert Case Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des requêtes : ' + ex.getMessage() + '\n'; containsErrors = true;
            } 
        }
        
        if(listControleToUpdate != null &&
           listControleToUpdate.size() > 0)
        {
            System.debug('################');
            for(Controle__c ctrl : listControleToUpdate) {
                if(mapIdFoyerRequete.containsKey(ctrl.foyer__c)) {
                    for (Case requete : mapIdFoyerRequete.get(ctrl.foyer__c)) {
                        if((ctrl.RecordType.Name == Label.CTRL_RecordType_ControleMediamat_PaME && requete.RecordtypeId == recordTypeIdRequeteControle && ctrl.Type_de_controle__c == requete.Type_de_controle__c) ||
                           (ctrl.RecordType.Name == Label.CTRL_RecordType_ControleAIP && requete.RecordtypeId == recordTypeIdRequeteControleAIP)) {
                               Case req = requete;
                               req.Nombre_de_controles__c = req.Nombre_de_controles__c != null ? req.Nombre_de_controles__c + 1 : 1;
                               ctrl.Requete__c = requete.Id;
                               
                               if(mapIdFoyerToControlSousType.get(ctrl.foyer__c)=='1'){
                                   req.Sous_type__c=Label.CAS_Sous_type_Pager_Off;
                               }
                               else if(mapIdFoyerToControlSousType.get(ctrl.foyer__c)=='2'){
                                   req.Sous_type__c= Label.CAS_Sous_type_Absence_Collecte;
                               }
                               else if(mapIdFoyerToControlSousType.get(ctrl.foyer__c)=='3'){
                                   req.Sous_type__c= Label.CAS_Sous_type_Pager_eteint_Trop_Longtemps;
                               }
                               else if(mapIdFoyerToControlSousType.get(ctrl.foyer__c)=='4'){
                                   req.Sous_type__c= Label.CAS_Sous_type_Absence_Mouvement;
                               }
                               else{
                                   if(ctrl?.Sous_type_de_controle__c !=null){
                                       req.Sous_type__c=getSousTypeLabel(ctrl.Sous_type_de_controle__c);
                                   }
                                   
                               }
                               listCaseToUpdate.add(req);
                           }
                    }
                }
            }
        }
        if(listControleToUpdate != null && listControleToUpdate.size() > 0) {
            try{ 
                database.update(listControleToUpdate, false);
            }Catch(exception ex){
                system.debug('Update Controle Exception Error:'+ex.getmessage());
                //Added for notification
                errorTxt += 'Erreur durant la MAJ des controles : ' + ex.getMessage() + '\n'; containsErrors = true;
            }  
        }
        
        if(listCaseToUpdate != null && listCaseToUpdate.size() > 0) {
            Map <Id, Case> casesToUpdateMap = new Map <Id, Case>();
            for(Case myCase: listCaseToUpdate) {
                
                if(String.isNotBlank(myCase.Id)) {
                    if(casesToUpdateMap.containsKey(myCase.Id)) {
                        if(casesToUpdateMap.get(myCase.Id).Nombre_de_controles__c > myCase.Nombre_de_controles__c) {
                            casesToUpdateMap.put(myCase.Id, myCase); 
                        }
                    }
                    else {
                        casesToUpdateMap.put(myCase.Id, myCase); 
                    }
                }
            }
            if(!casesToUpdateMap.isEmpty()) {
                try { 
                    database.update(casesToUpdateMap.values(), false);
                } Catch(exception ex){
                    system.debug('Update Case Exception Error:'+ex.getmessage());
                    //Added for notification
                    errorTxt += 'Erreur durant la MAJ des requêtes : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                }  
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        List<String> toMailAddress = System.Label.BatchNotif_B003_ToAddress.split(';');
        String senderName = Label.BatchNotif_B003_SenderName;
        String subject = Label.BatchNotif_B003_Subject;
        
        String emailBody = 'L\'exécution du batch Batch003_CreationRequeteControle s\'est terminée.\n';
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