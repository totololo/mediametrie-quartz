/*
* @author: Claire VEHRLE
* @date: 19/10/2021
* @ Description: Précodage des Controles AIP
* @TestClass: Batch002_PrecodageControle_Test
* @Coverage: 93 %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/

public class AP02_Controle {

    public static List<Controle__c> executePrecodageControleAIP (List<Controle__c> scope) {
        
        Date day = Date.Today();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        
        //Get the jours fériés (public holidays) records that will be used in checkIfPublicHoliday function
        map<String,jour_ferie__c > mapJoursFeries = jour_ferie__c.getAll();
        //System.debug('***mapJoursFeries: ' + mapJoursFeries);
        string dateJoursFeries = '';
        for(jour_ferie__c jourFerie : mapJoursFeries.values()) {
            if(jourFerie.Date_du_jour_ferie__c.year() == date.today().year()) {
                dateJoursFeries += string.valueOf(jourFerie.Date_du_jour_ferie__c);
            }
        }
        //System.debug('***dateJoursFeries: ' + dateJoursFeries);
        
        
        List<Controle__c> listControleToUpdate = new List<Controle__c>();
        set<string> setIdFoyer = new set<string>();
       
        for(Controle__c ctrl: scope) {
            setIdFoyer.add(ctrl.Foyer__c);
        }
        //System.debug('***setIdFoyer: ' + setIdFoyer);
        map<string, Account> mapIdFoyerToFoyer = new map<string, account>([SELECT Id, name,
                                                                           (SELECT Id
                                                                            FROM Panelistes__r
                                                                            WHERE Suspendu__c = true AND RecordType.Id = :recordTypeIdFoyerPanelisteAIP),
                                                                           (SELECT Id, statut__c, Date_de_debut__c, Date_de_fin__c,Nom_de_l_etiquette__c
                                                                            FROM Etiquettes__r
                                                                            WHERE statut__c =: Label.ETI_Statut_Actif),
                                                                           (SELECT Id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c, 
                                                                            Vacances_hors_France__c
                                                                            FROM Conges__r
                                                                            WHERE Vacances_hors_France__c = true 
                                                                            AND Date_de_debut__c <= :day AND Date_de_fin__c >= :day),
                                                                           (SELECT Id, CompletedDateTime, status
                                                                            FROM Tasks 
                                                                            WHERE (DAY_ONLY(CallStartTime__c) = :day - 1
                                                                            AND Subject = :Label.TSK_Objet_Call AND CallDurationInSeconds != 0
                                                                            AND Status = :Label.TSK_Statut_Completed)
                                                                           	OR (Status = :Label.TSK_Statut_Open
                                                                            AND CallStartTime__c > :day))
                                                                           FROM Account 
                                                                           WHERE ID IN: setIdFoyer]);
        
       
        System.debug('mapIdFoyerToFoyer');
         System.debug(mapIdFoyerToFoyer);
        for(Controle__c contr : scope) {
            //System.debug('***contr.CreatedDate: ' + contr.CreatedDate);
            System.debug('mapIdFoyerToFoyer.get(contr.Foyer__c) '+mapIdFoyerToFoyer.get(contr.Foyer__c));
            if(mapIdFoyerToFoyer.get(contr.Foyer__c)?.Etiquettes__r?.size() > 0){
               for(Etiquette__c etiq : mapIdFoyerToFoyer.get(contr.Foyer__c)?.Etiquettes__r) {
                    if(contr.Libelle_de_pre_codage__c == null) {
                        if(etiq.Date_de_fin__c > contr.CreatedDate.date() && etiq.Date_de_debut__c <= contr.CreatedDate.date()) {
                            //Mauvaise réception
                            if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Mauvaise_Reception) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Mauvaise_Reception;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Mouvement atypique
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Mouvement_Atypique) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Mouvement_Atypique;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Foyer témoin
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Foyer_temoin) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Foyer_Temoin;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Peu écoute casque
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Peu_Ecoute_Casque) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Peu_Ecoute_Casque;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Raisons presonellees
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Raisons_Personnelles) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Raisons_Personnelles;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Refus temporaire de paticipation
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Refus_Temporaire_De_Participation) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Refus_Temporaire_De_Participation;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //Profession atypique
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Profession_Atypique) {
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Profession_Atypique;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                            //presence foyer
                            else if (etiq.Nom_de_l_etiquette__c == Label.ETI_Nom_de_l_etiquette_Presencefoyer){
                                contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Presence_Foyer;
                                contr.Statut__c = Label.CTRL_Statut_Precode;
                            }
                        }
                    }
                }
            }
            
            
            if(contr.Libelle_de_pre_codage__c == null) {
                //Suspendu AIP
                if (mapIdFoyerToFoyer.get(contr.Foyer__c)?.Panelistes__r?.size() > 0) {
                    for(Foyer_Paneliste__c foyerPaneliste : mapIdFoyerToFoyer.get(contr.Foyer__c).Panelistes__r) {
                        if(contr.Foyer_Paneliste__c == foyerPaneliste.Id) {
                            contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_FoyerSuspendu;
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                        }
                    }
                }
            }
            if(contr.Libelle_de_pre_codage__c == null) {
                //Hors France
                if (mapIdFoyerToFoyer.get(contr.Foyer__c)?.Conges__r?.size() > 0) {
                    for(Conge__c conge : mapIdFoyerToFoyer.get(contr.Foyer__c).Conges__r) {
                        contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Hors_France;
                        contr.Statut__c = Label.CTRL_Statut_Precode;
                    }
                }
                
            }
            //System.debug('***TASK contr.Libelle_de_pre_codage__c' + contr.Libelle_de_pre_codage__c);
            if(contr.Libelle_de_pre_codage__c == null) {
                //System.debug('***mapIdFoyerToFoyer.get(contr.Foyer__c).Tasks: ' + mapIdFoyerToFoyer.get(contr.Foyer__c).Tasks);
                if (mapIdFoyerToFoyer.get(contr.Foyer__c)?.Tasks?.size() > 0) {
                    for (Task tache:mapIdFoyerToFoyer.get(contr.Foyer__c).Tasks) {
                        
                        //System.debug('***tache.status: ' + tache.status);
                        //Appel hier
                        if (tache.status == Label.TSK_Statut_Completed) {
                            contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Appel_Hier;
                            contr.Statut__c = Label.CTRL_Statut_Precode;
                        }
                        //RDV
                        else if (tache.status == Label.TSK_Statut_Open) {
                           contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_RDV;
                           contr.Statut__c = Label.CTRL_Statut_Precode;
                        }
                    }
                }
            }
            
            if(contr.Libelle_de_pre_codage__c == null) {
                System.debug('***Dimanche et Jour férié');
                //Dimanche
                if(checkIfSunday(contr.CreatedDate)) {
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_Dimanche;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                }
                //Jour ferié
                else if(checkIfJourFerie(contr.CreatedDate, dateJoursFeries)) {
                    contr.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_JourFerie;
                    contr.Statut__c = Label.CTRL_Statut_Precode;
                }
            }
            
            listControleToUpdate.add(contr);
        }

        return listControleToUpdate;
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
    
    //Method that checks if the date of control happens to be on a public holiday
    public static boolean checkIfJourFerie(datetime dateDeControl, string dateJoursFeries) {
        boolean isJourFerie = false;
        //system.debug('*** dateJoursFeries ' + dateJoursFeries + ' && ' + string.valueOf(date.valueOf(dateDeControl)));
        if(dateJoursFeries.contains(string.valueOf(date.valueOf(dateDeControl)))) {
            isJourFerie = true;
        }
        
        return isJourFerie;
    }
    
}