/*
* @author: Claire VEHRLE
* @date: 19/10/2021
* @ Description: Précodage des Controles MM/PaME
* @TestClass: Batch002_PrecodageControle_Test
* @Coverage: -- %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/

public class AP01_Controle {

    public static List<Controle__c> executePrecodageControleMMPaMe (List<Controle__c> scope) {
                
        //Get the jours fériés (public holidays) records that will be used in checkIfPublicHoliday function
        map<String,jour_ferie__c > mapJoursFeries = jour_ferie__c.getAll();
        string dateJoursFeries = '';
        for(jour_ferie__c jourFerie : mapJoursFeries.values()) {
            if(jourFerie.Date_du_jour_ferie__c.year() == date.today().year()) {
                dateJoursFeries += string.valueOf(jourFerie.Date_du_jour_ferie__c);
            }
        }
        
        Map<String,Etiquettes_et_controles__c > mapEtiquetteEtControle = Etiquettes_et_controles__c.getAll();
        Map<String,String> mapLibellePrecode = new  Map<String,String>();
        List<Controle__c> listControleToUpdate = new List<Controle__c>();
        set<string> setIdFoyer = new set<string>();
        Map<Id,Controle__c> MapIdControle = new  Map<Id,Controle__c>();
        Id ControleMMATPaMEId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        for(Etiquettes_et_controles__c etqCtrl: mapEtiquetteEtControle.values()) {
            if(!mapLibellePrecode.containskey(etqCtrl.Type_controle__c + ' ' + etqCtrl.Sous_type_controle__c +' '+etqCtrl.Nom_de_l_etiquette__c)) {
                mapLibellePrecode.put(etqCtrl.Type_controle__c + ' ' + etqCtrl.Sous_type_controle__c +' '+etqCtrl.Nom_de_l_etiquette__c,etqCtrl.Libell_de_pr_codage__c);             
            }
        }
        
        /*Set<String> keys = mapLibellePrecode.keySet();        
        for (string k: keys) {
            System.debug('Key : ' + k);
        }*/
		System.debug('##############################');
        System.debug('Scope: ' + scope);
        for(Controle__c ctrl: scope) {
            setIdFoyer.add(ctrl.Foyer__c);
        } 
        map<string, Account> mapIdFoyerToFoyer = new map<string, account>([Select id, name,
                                                                           (SELECT Id, Date_d_installation__c, Date_d_integration__c,Date_de_suspension__c,Suspendu__c 
                                                                            FROM Panelistes__r
                                                                            WHERE  RecordTypeId = :recordTypeIdFoyerPanelisteMMATPaME),
                                                                           (Select id, statut__c, Date_de_debut__c, Date_de_fin__c,Nom_de_l_etiquette__c  from Etiquettes__r
                                                                            Where statut__c =: Label.ETI_Statut_Actif),
                                                                           (Select id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c
                                                                            from Conges__r),
                                                                           (Select id,Resultat_joint__c,CreatedDate, Type_de_controle__c,Foyer__c,Statut__c, Sous_type_de_controle__c,
                                                                            Date_de_controle__c, Libelle_de_pre_codage__c, Membre_du_foyer__c, Audimetre__c, Joint_non_joint__c,
                                                                            Tech_DureeCreationControle__c,Foyer_paneliste__r.Suspendu__c
                                                                            FROM Controles__r
                                                                            WHERE (
                                                                                RecordTypeId =: ControleMMATPaMEId AND
                                                                                ((((Type_de_controle__c =: Label.CTRL_Type_Connexion AND
                                                                                   Sous_type_de_controle__c =: Label.CTRL_SousType_AudimetreNonConnecte) OR
                                                                                  (Type_de_controle__c =: Label.CTRL_Type_Participation AND
                                                                                   Sous_type_de_controle__c =: Label.CTRL_SousType_TVOnPlus12h)) AND
                                                                                 Tech_DureeCreationControle__c <= 1) OR
                                                                                (Tech_DureeCreationControle__c <= 14 AND Tech_DureeCreationControle__c != 0
                                                                                 AND Joint_non_joint__c =: true) OR
                                                                                (Type_de_controle__c =: Label.CTRL_Type_Reception_abonnement  AND
                                                                                 Tech_DureeCreationControle__c <= 30 AND Tech_DureeCreationControle__c != 0
                                                                                 AND Joint_non_joint__c =: true))
                                                                            ))
                                                                           From Account 
                                                                           Where ID IN: setIdFoyer]);
        
        
        list<workOrder> listWorkOrders = [select id, Type_de_l_intervention__c, Actions__c, AccountId, StartDate, EndDate, Status,
                                          (select id, SchedStartTime, SchedEndTime from Service_Appointments__r)
                                          From WorkOrder
                                          where AccountId IN: setIdFoyer];
        System.debug('setIdFoyer.size(): ' + setIdFoyer.size());
        System.debug('listWorkOrders: ' + listWorkOrders);
        map<string, list<workOrder>> mapAccIdToWorkOrders = new map<string, list<workOrder>>();
        for(workOrder intervention : listWorkOrders) {
            if(!mapAccIdToWorkOrders.containsKey(intervention.AccountId)) {
                mapAccIdToWorkOrders.put(intervention.AccountId, new list<workOrder>());
            }
            mapAccIdToWorkOrders.get(intervention.AccountId).add(intervention);
        }
        
        for(Controle__c contr : scope) {
            //Precode based on tickets available on the household/Foyer
            for(Etiquette__c etiq : mapIdFoyerToFoyer.get(contr.Foyer__c).Etiquettes__r) {
                if(contr.Libelle_de_pre_codage__c==null) {
                    if(etiq.Date_de_fin__c > contr.CreatedDate.date() && etiq.Date_de_debut__c <= contr.CreatedDate.date()) {
                        /*System.debug('### ' + contr.Type_de_controle__c + ' ' + contr.Sous_type_de_controle__c + ' ' + etiq.Nom_de_l_etiquette__c);
                        System.debug('clé ? : ' + mapLibellePrecode.containskey(contr.Type_de_controle__c+' '+contr.Sous_type_de_controle__c+' '+etiq.Nom_de_l_etiquette__c));*/
                        if(mapLibellePrecode.containskey(contr.Type_de_controle__c+' '+contr.Sous_type_de_controle__c+' '+etiq.Nom_de_l_etiquette__c)) {
                            /*System.debug('Je suis entrée dans la clé !');*/
                            contr.Libelle_de_pre_codage__c=mapLibellePrecode.get(contr.Type_de_controle__c+' '+contr.Sous_type_de_controle__c+' '+etiq.Nom_de_l_etiquette__c);
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                            
                            //listControleToUpdate.add(contr);
                            if(!MapIdControle.containskey(contr.id)) {
                               MapIdControle.put(contr.id,contr); 
                            }
                            break;
                        }
                    }
                }
            }
            if(contr.Libelle_de_pre_codage__c==null) {
                //Precode based on day of week is sunday or not
                if(checkIfSunday(contr.CreatedDate)) {
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Dimanche;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                    //listControleToUpdate.add(contr);
                    if(!MapIdControle.containskey(contr.id)) {
                        MapIdControle.put(contr.id,contr); 
                    }
                    continue;
                }
                
                //Precode based on day of week is weekend or not
                if(checkIfWeekend(contr.CreatedDate)) {
                    system.debug('weekend');
                    if((contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudienceIndividuellePlus7h) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours) ||
                   (contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudSansAbo) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud))
                	{
                        contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Weekend;
                        contr.Statut__c = Label.CTRL_Statut_Precode;
                        system.debug('week-end');
                        If(!MapIdControle.containskey(contr.id)) {
                            MapIdControle.put(contr.id,contr); 
                        }
                        //listControleToUpdate.add(contr);
                        continue;
                	}
                }
                
                //Precode based on public holiday or not
                if(checkIfPublicHoliday(contr.CreatedDate, dateJoursFeries)) {
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_JourFerie;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                    //listControleToUpdate.add(contr);
                    If(!MapIdControle.containskey(contr.id)) {
                        MapIdControle.put(contr.id,contr); 
                    }
                    continue;
                } 
                
                //Precode if foyer periode probatoire
                if (mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r != null) {
                        System.debug('***contr.Foyer__r.name: ' + contr.Foyer__r.name);
                        System.debug('***mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r: ' + mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r);
                    for(Foyer_Paneliste__c foyerPaneliste : mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r) {
                        System.debug('***foyerPaneliste: ' + foyerPaneliste);
                        if(contr.Foyer_Paneliste__c == foyerPaneliste.Id) {
                            if(contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_NonEnvoyeMediamat &&
                               foyerPaneliste.Date_d_installation__c != Null)
                            {
                                integer periodProbatoire = foyerPaneliste.Date_d_installation__c.daysBetween(date.today());
                                if(periodProbatoire <= 3 && periodProbatoire > 0) {
                                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_FoyerProbatoire;
                                    contr.Statut__c = Label.CTRL_Statut_Precode;
                                    //listControleToUpdate.add(contr);
                                    If(!MapIdControle.containskey(contr.id)) {
                                        MapIdControle.put(contr.id,contr); 
                                    }
                                    continue;
                                }
                            }
                        }
                    }
                }
                
                
                //Precode based on other controls related to the same household/Foyer
                if((contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudienceIndividuellePlus7h) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours) ||
                   (contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudSansAbo) ||
                   (contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud))
                {
                    if(mapIdFoyerToFoyer.containsKey(contr.Foyer__c) && mapIdFoyerToFoyer.get(contr.Foyer__c).Controles__r.size() > 0) {
                        string controlCheckReturn = checkIfOtherControlsExist(contr, mapIdFoyerToFoyer.get(contr.Foyer__c).Controles__r);
                        if(!string.isBlank(controlCheckReturn)) {
                            contr.Libelle_de_pre_codage__c = controlCheckReturn == 'CTRL traité J-1'? Label.CTRL_LibellePrecodage_CtrlNonConnecte:
                            controlCheckReturn == 'Controle participation existant'? Label.CTRL_LibellePrecodage_AppelRecentCTRLPart :
                            controlCheckReturn == 'Controle presence existant' ?Label.CTRL_LibellePrecodage_AppelRecentCTRLPres :
                            controlCheckReturn == 'Controle recep/abon 30 jour' ?Label.CTRL_LibellePrecodage_AppelRecentCTRLRecepAbo30j :
                            controlCheckReturn == 'Controle recent existant' ?Label.CTRL_LibellePrecodage_AppelRecentTousCTRL14j : 
                            controlCheckReturn == 'Controle participation 12h meme jour' ?Label.CTRL_LibellePrecodage_FoyerTvONPlus12j :
                            controlCheckReturn == 'Controle connexion meme jour' ?Label.CTRL_LibellePrecodage_CTRLConnMemeJour :
                            controlCheckReturn == 'Controle participation web existant' ?Label.CTRL_LibellePrecodage_AppelRecentCTRLPartWeb14j :'';
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                            If(!MapIdControle.containskey(contr.id)) {
                               MapIdControle.put(contr.id,contr); 
                            }
                            //listControleToUpdate.add(contr);
                            continue;
                        }
                    }
                }
                
                //Precode if foyer is suspended (Suspendu)
                if (mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r != null) {
                    for(Foyer_Paneliste__c foyerPaneliste : mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r) {
                        if(((contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte) ||
                            (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h) ||
                            (contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages) ||
                            (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees) ||
                            (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieBasePanel) ||
                            (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_NonEnvoyeMediamat)) &&
                            contr.Foyer_Paneliste__c == foyerPaneliste.Id  && foyerPaneliste.Suspendu__c==true && foyerPaneliste.Date_de_suspension__c <= contr.CreatedDate.date()
                          	)
                        {
                            contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_FoyerSuspendu;
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                            If(!MapIdControle.containskey(contr.id)) {
                                MapIdControle.put(contr.id,contr); 
                            }
                            // listControleToUpdate.add(contr);
                            continue;
                        }
                    }
                }
                /*
                if(((contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte) ||
                    (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h) ||
                    (contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages) ||
                    (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees) ||
                    (contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_NonEnvoyeMediamat)) )
                {
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_FoyerSuspendu;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                    If(!MapIdControle.containskey(contr.id)) {
                        MapIdControle.put(contr.id,contr); 
                    }
                   // listControleToUpdate.add(contr);
                    continue;
                }
				*/                
                //Precode based on date d'integration
                if (mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r != null) {
                    for(Foyer_Paneliste__c foyerPaneliste : mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r) {
                        if(contr.Foyer_Paneliste__c == foyerPaneliste.Id) {
                            if(contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_RejeteMediamat &&
                               foyerPaneliste.Date_d_integration__c == Null)
                            {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_FoyerAttenteCati3;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                                If(!MapIdControle.containskey(contr.id)) {
                                    MapIdControle.put(contr.id,contr); 
                                }
                                // listControleToUpdate.add(contr);
                                continue;
                            }
                        }
                    }
                }
                
                
                //Precode if member is less than a certain age 
                if(
                    (contr.Membre_du_foyer__c != Null ) && (((contr.Membre_du_foyer__r.birthdate.daysBetween(date.today()) / 365) < 4 ) ) &&
                    (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudienceIndividuellePlus7h 
                    ||
                   contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours)
                      
                )
                {
                    system.debug('here'+(contr.Membre_du_foyer__r.birthdate.daysBetween(date.today()) / 365));
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_EnfantMoins4ans;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                    If(!MapIdControle.containskey(contr.id)) {
                        MapIdControle.put(contr.id,contr); 
                    }
                   // listControleToUpdate.add(contr);
                    continue;
                } 
                //System.debug('***contr.Membre_du_foyer__r.birthdate.daysBetween(date.today()) / 365' + contr.Membre_du_foyer__r.birthdate.daysBetween(date.today()) / 365);
                if(contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente &&
                       contr.Membre_du_foyer__c != Null && ((contr.Membre_du_foyer__r.birthdate.daysBetween(date.today()) / 365) < 15))
                { 
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_EnfantMoins15ans;
                    contr.Statut__c = Label.CTRL_Statut_Precode; 
                    If(!MapIdControle.containskey(contr.id)) {
                        MapIdControle.put(contr.id,contr); 
                    }
                   // listControleToUpdate.add(contr);
                    continue;
                }
                
                //Precode based on work orders (interventions) or service appointments (rendez-vous)
                if(contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte
                   || contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudienceIndividuellePlus7h
                   || contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h
                   || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Presence &&  contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudSansAbo
                   || contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud
                   || contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages
                   || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteRouteur
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente)
                {
                    system.debug('teest');
                    if(mapAccIdToWorkOrders.containsKey(contr.Foyer__c) && mapAccIdToWorkOrders.get(contr.Foyer__c).size() > 0) {
                        system.debug('test2'+contr );
                        system.debug('wo '+mapAccIdToWorkOrders.get(contr.Foyer__c));
                        string workOrderReturn = checkWorkOrders(contr, mapAccIdToWorkOrders.get(contr.Foyer__c));
                        if(!string.isBlank(workOrderReturn)) {
                            system.debug('test');
                            contr.Libelle_de_pre_codage__c = workOrderReturn == 'Intervention Open or closed yesterday'? Label.CTRL_LibellePrecodage_InterEnCours:
                            workOrderReturn == 'Motif Contrôle Audience'? Label.CTRL_LibellePrecodage_InterEnCoursCtrlAudience :
                            workOrderReturn == 'Intallation ouverte ou fermée moin 15 jours' ?Label.CTRL_LibellePrecodage_InstallMoins15Jours :
                            workOrderReturn == 'Rendez-vous dans les prochains 15 jours' ?Label.CTRL_LibellePrecodage_InterMoins15Jours : '';
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                            If(!MapIdControle.containskey(contr.id)) {
                               MapIdControle.put(contr.id,contr); 
                            }
                            //listControleToUpdate.add(contr);
                            continue;
                        }
                    }
                    
                }
                
                if ( contr.Foyer_Paneliste__r.statut_audimetrique__c == Label.Statut_audimetrique_vacances && contr.Libelle_de_pre_codage__c !=Label.CTRL_LibellePrecodage_FoyerVac){
                    contr.Libelle_de_pre_codage__c =Label.CTRL_LibellePrecodage_FoyerVac;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                    MapIdControle.put(contr.id,contr);
                }
                
                //Precode based on vacations days (Congé object in Salesforce). The vacation could be for the household (Foyer) or the member (Contact/membre du foyer)
                else if(contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte
                   || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours
                   || contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud
                   || contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages
                   || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieBasePanel
                   || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees
                   || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_NonEnvoyeMediamat
                   || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_RejeteMediamat
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteRouteur
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente
                   || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente)
                {
                    if(mapIdFoyerToFoyer.containsKey(contr.Foyer__c) && mapIdFoyerToFoyer.get(contr.Foyer__c).Conges__r.size() > 0)
                    {
                        string vacationReturnStr = checkIfHouseholdOrMemberOnVacation(contr, mapIdFoyerToFoyer.get(contr.Foyer__c).Conges__r);
                        if(!string.isBlank(vacationReturnStr)) {
                            contr.Libelle_de_pre_codage__c = vacationReturnStr == 'Conge foyer'? Label.CTRL_LibellePrecodage_FoyerVac :
                            vacationReturnStr == 'Conge individu'? Label.CTRL_LibellePrecodage_IndividuVac : '';
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                            If(!MapIdControle.containskey(contr.id)) {
                               MapIdControle.put(contr.id,contr); 
                            }
                            //listControleToUpdate.add(contr);
                            continue;
                        }
                    }
                    
                }
                
            }  
        }

        
        return MapIdControle.values();
        
    }
    
    //Method that checks if the date of control happens to be on a Sunday
    public static boolean checkIfSunday(datetime dateDeControl) {
        boolean isSunday = false;
        String dayOfWeek = dateDeControl.format('E');
        if(dayOfWeek == 'Sun') {
            isSunday = true;
        }
        return isSunday;
    }
    
     //Method that checks if the date of control happens to be on a weekend
    public static boolean checkIfWeekend(datetime dateDeControl) {
        boolean isWeekend = false;
        String dayOfWeek = dateDeControl.format('E');
        if(dayOfWeek == 'Sun' || dayOfWeek == 'Sat') {
            isWeekend = true;
        }
        return isWeekend;
    }
    
    //Method that checks if the date of control happens to be on a public holiday
    public static boolean checkIfPublicHoliday(datetime dateDeControl, string dateJoursFeries) {
        boolean isPublicHoliday = false;
        if(dateJoursFeries.contains(string.valueOf(date.valueOf(dateDeControl)))) {
            isPublicHoliday = true;
        }
        
        return isPublicHoliday;
    } 
    
    //Method that checks if there's an open workOrder(intervention), or a work order that was closed recently
    public static string checkWorkOrders(Controle__c controle, list<workOrder> listInterventions) {
        string returnStr = '';
        for(workOrder intervention : listInterventions) {
            date interEndDate;
            if (intervention.StartDate !=null){
            	date interStartDate = date.newInstance(intervention.StartDate.year(), intervention.StartDate.month(), intervention.StartDate.day());
                
            
            if(intervention.EndDate != Null) {
                interEndDate = date.newInstance(intervention.endDate.year(), intervention.endDate.month(), intervention.endDate.day());
            }
            }
            
            
            dateTime rendezVousDateTime; 
            date rendezVousStartDate;
            
            if(intervention.Service_Appointments__r.size() > 0 && intervention.Service_Appointments__r[0].SchedStartTime != Null) {
                rendezVousDateTime = intervention.Service_Appointments__r[0].SchedStartTime;
                rendezVousStartDate = date.newInstance(rendezVousDateTime.year(), rendezVousDateTime.month(), rendezVousDateTime.day());
            }
            
            //Intervention ouverte affectée à un technicien référencé (ambassadeur ou tech externe) avec RDV fixé <= 15 j par rapport à la date du jour, 
            //quelque soit le motif (Type Réception/abonnement and Sous type Foyer avec audience sans abo OR sous type Foyer avec abo C+ sans audience)
            if(intervention.Type_de_l_intervention__c != Label.WOR_Type_d_intervention_Installation &&
                    controle.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && 
                    (controle.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudSansAbo 
                     || controle.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud) &&
                    rendezVousStartDate != Null)
            {
                if(date.today().daysBetween(rendezVousStartDate) <= 15 && rendezVousStartDate > date.today()) {
                    returnStr = 'Rendez-vous dans les prochains 15 jours';
                }
            }
            
            
            //Intervention ouverte avec ou sans RDV affectée à un technicien référencé (ambassadeur ou tech externe) ou cloturée à J-1, quelque soit le motif
            else if(intervention.Type_de_l_intervention__c != Label.WOR_Type_d_intervention_Installation && intervention.Actions__c!=label.WOR_Sous_type_d_intervention_Visite_de_courtoisie && intervention.Actions__c!=label.WOR_Actions_Modification_Abonnement_Etiquette &&
               (((controle.CreatedDate.date() >= intervention.StartDate && intervention.Status!=Label.WOR_Status_Terminee )
                || intervention.endDate == (controle.CreatedDate.date() - 1))))
            {
                system.debug('youssef');
                returnStr = 'Intervention Open or closed yesterday';
                
                //Intervention ouverte avec ou sans RDV affectée à un technicien référencé (ambassadeur ou tech externe) ou cloturée à J-1, 
                //avec motif "contrôle audience" (Type participation and sous type TVON > 12h)
                if(controle.Type_de_controle__c == Label.CTRL_Type_Participation && controle.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h &&
                   intervention.Actions__c == Label.WOR_Sous_type_d_intervention_Controle_d_audience && 
                   (((controle.CreatedDate.date() >= intervention.StartDate) & intervention.Status!=Label.WOR_Status_Terminee)
                    || (intervention.endDate == (controle.CreatedDate.date() - 1))))
                {
                    returnStr = 'Motif Contrôle Audience';
                    break;
                }
            }
            
            //L'installation (intervention de type installation) du foyer est encore ouverte ou est fermée depuis 15 jours ou moins par rapport 
            //à la date où est généré le contrôle (Type Participation Web and sous type Foyer sans activité routeur OR sous type Foyer sans activité Web cohérente 
            //OR sous type Individu sans activité Web cohérente)
          
            else if(intervention.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Installation &&
                    controle.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && 
                    (controle.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteRouteur 
                     || controle.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente
                     || controle.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente) &&
                    (((controle.CreatedDate.date() >= intervention.StartDate) && intervention.Status!=Label.WOR_Status_Terminee)
                     || (interEndDate != Null && interEndDate < date.today() && interEndDate.daysBetween(date.today()) <= 15)))
           
            {
              
                returnStr = 'Intallation ouverte ou fermée moin 15 jours';
                break;
            }
            
        }
        return returnStr;
    }
    
    //Method that checks if household or membre are on vacation (En congé) on the date of the control
    public static string checkIfHouseholdOrMemberOnVacation(Controle__c contr, list<conge__c> listConges) {
        string returnStr = '';
        for(Conge__c conge : listConges) {
            if(contr.CreatedDate.date() >= conge.Date_de_debut__c && contr.CreatedDate.date() <= conge.Date_de_fin__c) {
                if(string.isBlank(conge.Conge_de_l_individu__c) && 
                   (contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte
                    || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours
                    || contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours
                    || contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud
                    || contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages
                    || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieBasePanel
                    || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees
                    || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_NonEnvoyeMediamat
                    || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_RejeteMediamat
                    || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteRouteur)) {
                        system.debug('con foyer');
                        returnStr = 'Conge foyer';
                        break;
                        
                    }else if(!string.isBlank(conge.Conge_de_l_individu__c) && conge.Conge_de_l_individu__c == contr.Membre_du_foyer__c &&
                             (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours
                              || contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees
                              || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente
                              || contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente)) {
                                  returnStr = 'Conge individu';
                                  system.debug('con indiv');
                              }
            }
        }
        return returnStr;
    }
    
    //Method that checks if a household or member or equipment has another control that allows that current one to be precoded
    public static string checkIfOtherControlsExist(Controle__c contr, list<Controle__c> listControls) {
        string stringToReturn = '';
        if(contr.Type_de_controle__c == Label.CTRL_Type_Connexion && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte) {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Sous_type_de_controle__c == Label.CTRL_SousType_AudimetreNonConnecte && oldControl.Tech_DureeCreationControle__c == 1 && 
                   oldControl.Statut__c == Label.CTRL_Statut_Traite && oldControl.Id != contr.Id && oldControl.Audimetre__c != Null && contr.Audimetre__c != Null &&
                   oldControl.Audimetre__c == contr.Audimetre__c && (contr.Resultat_joint__c==label.CTRL_joint_Manip_OK || contr.Resultat_joint__c==Label.CTRL_joint_Manip_KO) )
                {
                    stringToReturn = 'CTRL traité J-1';
                    break;
                }
            }
        }    
        
        if((contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AudienceIndividuellePlus7h)/* ||
           (contr.Type_de_controle__c == Label.CTRL_Type_Participation && contr.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h)*/) {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Type_de_controle__c == Label.CTRL_Type_Participation && oldControl.Tech_DureeCreationControle__c != 0 &&
                   oldControl.Joint_non_joint__c)
                {
                    stringToReturn = 'Controle participation existant';
                    break;
                }
            }
        }
        
        if((contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudience6Jours) ||
           (contr.Type_de_controle__c == Label.CTRL_Type_Presence && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansAudience28Jours))
        {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Type_de_controle__c == Label.CTRL_Type_Presence && oldControl.Tech_DureeCreationControle__c != 0 &&
                   oldControl.Joint_non_joint__c)
                {
                    stringToReturn = 'Controle presence existant';
                    break;
                }
            }
        }
        
        if((contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansActiviteWebCoherente) ||
           (contr.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && contr.Sous_type_de_controle__c == Label.CTRL_SousType_IndividuSansActiviteWebCoherente))
        {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Type_de_controle__c == Label.CTRL_Type_ParticipationWeb && oldControl.Tech_DureeCreationControle__c != 0 &&
                   oldControl.Joint_non_joint__c)
                {
                    stringToReturn = 'Controle participation web existant';
                    break;
                }
            }
        }
        
        if(contr.Type_de_controle__c == Label.CTRL_TypeAutresUsages && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AutresUsages)
        {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Tech_DureeCreationControle__c != 0 && oldControl.Joint_non_joint__c) {
                    stringToReturn = 'Controle recent existant';
                    break;
                }
            }
        }
        
        if((contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerSansAudSansAbo) ||
           (contr.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement && contr.Sous_type_de_controle__c == Label.CTRL_SousType_FoyerAvecAboSansAud))
        {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Type_de_controle__c == Label.CTRL_Type_Reception_abonnement &&
                   oldControl.Tech_DureeCreationControle__c > 14 && oldControl.Id != contr.Id &&
                   oldControl.Tech_DureeCreationControle__c != 0 &&
                   oldControl.Joint_non_joint__c)
                {
                    stringToReturn = 'Controle recep/abon 30 jour';
                    break;
                }else if(oldControl.Tech_DureeCreationControle__c <= 14 && oldControl.Tech_DureeCreationControle__c != 0 && oldControl.Joint_non_joint__c) {
                    stringToReturn = 'Controle recent existant';
                    break;
                }
            }
        }
        
        if(contr.Type_de_controle__c == Label.CTRL_Type_NonRepondant && contr.Sous_type_de_controle__c == Label.CTRL_SousType_AnomalieTraitementDonnees) {
            for(Controle__c oldControl : listControls) {
                if(oldControl.Type_de_controle__c == Label.CTRL_Type_Participation && oldControl.Sous_type_de_controle__c == Label.CTRL_SousType_TVOnPlus12h &&
                   oldControl.Tech_DureeCreationControle__c == 0 && oldControl.Id != contr.Id)
                {
                    stringToReturn = 'Controle participation 12h meme jour';
                    break;
                }else if(oldControl.Type_de_controle__c == Label.CTRL_Type_Connexion && oldControl.Tech_DureeCreationControle__c == 0 && oldControl.Id != contr.Id) {
                    stringToReturn = 'Controle connexion meme jour';
                    break;
                }
            }
        }
        
        return stringToReturn;
    }
}