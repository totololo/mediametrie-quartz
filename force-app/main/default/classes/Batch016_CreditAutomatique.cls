/*
* @author: Nancy Al Kalach
* @date: 07/12/2021
* @ Description Batch pour le credit automatique des fidelisation 
* @TestClass: Batch016_CreditAutomatique_Test
* @Coverage: 85%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*  		20/11/2023			Claire VEHRLE			TMASF-556
*/ 
global class Batch016_CreditAutomatique implements Database.Batchable<sObject>, Database.Stateful {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> Status = new List<String>{Label.PAN_StatusPan_ChuteTemp ,Label.PAN_Statut_Panel_Desinstalle ,Label.PAN_StatusPan_ChuteDefinitive};
            
            return Database.getQueryLocator([Select id , Freeze__c,Referentiel_Panel__r.Type_de_panel__c, foyer__c,Date_d_installation__c, Date_de_creation__c,
                                             Date_de_recensement__c,foyer__r.Personne_de_reference__c, 
                                             foyer__r.Contact_principal__c, Membre_du_foyer__c,
                                             (select id, Composition_du_foyer__c, Date_de_derniere_activite_mobile__c, Date_de_derniere_activite_browser__c  from Panelistes__r)
                                             from Foyer_paneliste__c
                                             where Statut_Foyer_paneliste__c not in:Status and (Date_de_recensement__c!=null OR Date_d_installation__c!=null)]);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Foyer_paneliste__c> scope){
        system.debug('$$$ Scope ' + scope);
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        list<Fidelisation__c> listFIDtoInsert = new  list<Fidelisation__c>();
        map<string, Foyer_paneliste__c> mapIdFoyerFoyer = new map<string, Foyer_paneliste__c>([Select id, name, 
                                                                                               (Select id from Fidelisations__r
                                                                                                Where   Motif_de_credit__c= :Label.FID_Motifcredit_BonusInstallation)
                                                                                               From Foyer_paneliste__c 
                                                                                               Where ID IN: scope]); 
        for(Foyer_paneliste__c fp:scope) {  
            
            if (fp.Freeze__c== false){
                //Recensement
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_AIP)) {
                    system.debug('RECENSEMENT AIP');
                    system.debug(fp.Panelistes__r);
                    //system.debug(fp.Panelistes__r[0].Composition_du_foyer__c);
                    if(fp.Panelistes__r.size() > 0){
                        system.debug(fp.Panelistes__r[0].Composition_du_foyer__c);
                        listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_AIP, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_50), fp.Panelistes__r[0].Composition_du_foyer__c, Label.RFP_TypePanel_AIP)); 
                    } else {
                        listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_AIP, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_50), null, Label.RFP_TypePanel_AIP)); 
                    }
                    
                } 
                
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$recensement MMT');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_100), fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                } 
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    system.debug('$$$recensement PaME');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_100), fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_PAME));
                } 
                
                
                //Participation mensuelle
                if(fp.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(fp.Date_d_installation__c) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ Participaiton mensuelle MMT');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_30),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                }
                if(fp.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(fp.Date_d_installation__c) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME) ) {
                    system.debug('$$$ Participaiton mensuelle PaME');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME,Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_30),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_PAME));
                }
                
                //Installation Bienvenue
                if(mapIdFoyerFoyer.containskey(fp.id) && mapIdFoyerFoyer.get(fp.id).Fidelisations__r.size()==0 && (GetMonthsBetween(fp.Date_d_installation__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ Instalation Bienvenue MMT');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_50),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                }
                if(mapIdFoyerFoyer.containskey(fp.id) && mapIdFoyerFoyer.get(fp.id).Fidelisations__r.size()==0 && (GetMonthsBetween(fp.Date_d_installation__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    system.debug('$$$ Instalation Bienvenue PaME');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_50),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                }

                //Noces MM
                if((Math.mod(GetMonthsBetween(fp.Date_de_creation__c),12) == 1) && (Date.Today().year() - fp.Date_de_creation__c.year() != 0)  && (((Date.Today().year() - fp.Date_de_creation__c.year()==1 && fp.Date_de_creation__c.month() !=12) || (Date.Today().year() - fp.Date_de_creation__c.year()==2 && fp.Date_de_creation__c.month() ==12)) || ((Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 0 && fp.Date_de_creation__c.month() !=12) || (Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 1 && fp.Date_de_creation__c.month() ==12))) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    system.debug('$$$ NoceMM PaME');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_Noce_MM,integer.valueof(Label.FID_NbrPoints_50),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                }
                if((Math.mod(GetMonthsBetween(fp.Date_de_creation__c),12) == 1) && (Date.Today().year() - fp.Date_de_creation__c.year() != 0)  && (((Date.Today().year() - fp.Date_de_creation__c.year()==1 && fp.Date_de_creation__c.month() !=12) || (Date.Today().year() - fp.Date_de_creation__c.year()==2 && fp.Date_de_creation__c.month() ==12)) || ((Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 0 && fp.Date_de_creation__c.month() !=12) || (Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 1 && fp.Date_de_creation__c.month() ==12))) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ NoceMM MMT');
                    listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_Noce_MM,integer.valueof(Label.FID_NbrPoints_50),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_MMAT));
                }
                
                //PaME Web
                if(fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME) {
                    if(fp.Panelistes__r.size() == 1) {
                        if(GetMonthsBetween(fp.Panelistes__r[0].Date_de_derniere_activite_mobile__c) == 1 || GetMonthsBetween(fp.Panelistes__r[0].Date_de_derniere_activite_browser__c) == 1) {
                            listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusMensuelWeb,integer.valueof(Label.FID_NbrPoints_30),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                        }
                    }
                    else {
                        for(Individu_paneliste__c indPan:fp.Panelistes__r) {
                            if(GetMonthsBetween(indPan.Date_de_derniere_activite_mobile__c) == 1 || GetMonthsBetween(indPan.Date_de_derniere_activite_browser__c) == 1) {
                                listFIDtoInsert.add(NewFID(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusMensuelWeb,integer.valueof(Label.FID_NbrPoints_15),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                            }
                        }
                    }
                }
            }
                        
            // foyez freez credit =0
            
            else if (fp.Freeze__c== true){
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_AIP)) {
                    system.debug('RECENSEMENT AIP');
                    system.debug(fp.Panelistes__r);
                    //system.debug(fp.Panelistes__r[0].Composition_du_foyer__c);
                    if(fp.Panelistes__r.size() > 0){
                        system.debug(fp.Panelistes__r[0].Composition_du_foyer__c);
                        listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_AIP, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_0), fp.Panelistes__r[0].Composition_du_foyer__c, Label.RFP_TypePanel_AIP)); 
                    } else {
                        listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_AIP, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_0), null, Label.RFP_TypePanel_AIP)); 
                    }
                    
                } 
                
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ in 2');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_0), fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                } 
                if(fp.Date_de_recensement__c!=null && (GetMonthsBetween(fp.Date_de_recensement__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    system.debug('$$$ in 2');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_Recensement,integer.valueof(Label.FID_NbrPoints_0), fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_PAME));
                } 
                
                
                //Participation mensuelle
                if(fp.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(fp.Date_d_installation__c) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ in 2');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                }
                if(fp.Date_d_installation__c!=null && IsInstalledForMoreThanAMonth(fp.Date_d_installation__c) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME) ) {
                    system.debug('$$$ in 2');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME,Label.FID_Motifcredit_BonusMensuelTV,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_PAME));
                }
                
                //Installation Bienvenue
                if(mapIdFoyerFoyer.containskey(fp.id) && mapIdFoyerFoyer.get(fp.id).Fidelisations__r.size()==0 && (GetMonthsBetween(fp.Date_d_installation__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    system.debug('$$$ in 1');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c, Label.RFP_TypePanel_MMAT));
                }
                if(mapIdFoyerFoyer.containskey(fp.id) && mapIdFoyerFoyer.get(fp.id).Fidelisations__r.size()==0 && (GetMonthsBetween(fp.Date_d_installation__c) == 1 ) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    system.debug('$$$ in 1');
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusInstallation,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                }
                
                //Noces MM
                if((Math.mod(GetMonthsBetween(fp.Date_de_creation__c),12) == 1) && (Date.Today().year() - fp.Date_de_creation__c.year() != 0)  && (((Date.Today().year() - fp.Date_de_creation__c.year()==1 && fp.Date_de_creation__c.month() !=12) || (Date.Today().year() - fp.Date_de_creation__c.year()==2 && fp.Date_de_creation__c.month() ==12)) || ((Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 0 && fp.Date_de_creation__c.month() !=12) || (Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 1 && fp.Date_de_creation__c.month() ==12))) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME)) {
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_Noce_MM,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                }
                if((Math.mod(GetMonthsBetween(fp.Date_de_creation__c),12) == 1) && (Date.Today().year() - fp.Date_de_creation__c.year() != 0)  && (((Date.Today().year() - fp.Date_de_creation__c.year()==1 && fp.Date_de_creation__c.month() !=12) || (Date.Today().year() - fp.Date_de_creation__c.year()==2 && fp.Date_de_creation__c.month() ==12)) || ((Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 0 && fp.Date_de_creation__c.month() !=12) || (Math.mod(Date.Today().year() - fp.Date_de_creation__c.year(),5) == 1 && fp.Date_de_creation__c.month() ==12))) && (fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_MMAT)) {
                    listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_MMAT, Label.FID_Motifcredit_Noce_MM,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_MMAT));
                }
                
                //PaME Web
                if(fp.Referentiel_Panel__r.Type_de_panel__c == Label.RFP_TypePanel_PAME) {
                    if(fp.Panelistes__r.size() == 1) {
                        if(GetMonthsBetween(fp.Panelistes__r[0].Date_de_derniere_activite_mobile__c) == 1 || GetMonthsBetween(fp.Panelistes__r[0].Date_de_derniere_activite_browser__c) == 1) {
                            listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusMensuelWeb,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                        }
                    }
                    else {
                        for(Individu_paneliste__c indPan:fp.Panelistes__r) {
                            if(GetMonthsBetween(indPan.Date_de_derniere_activite_mobile__c) == 1 || GetMonthsBetween(indPan.Date_de_derniere_activite_browser__c) == 1) {
                                listFIDtoInsert.add(NewFID_freeze(fp.id,fp.foyer__c,recordTypeIdFIDcredit,Label.FID_TypeMouvement_CreditExceptionnel,Label.RFP_TypePanel_PAME, Label.FID_Motifcredit_BonusMensuelWeb,integer.valueof(Label.FID_NbrPoints_0),fp.foyer__r.Contact_principal__c,Label.RFP_TypePanel_PAME));
                            }
                        }
                    }
                }
            }
            
        }
        system.debug('fid'+listFIDtoInsert);
        if(listFIDtoInsert != null && listFIDtoInsert.size()>0) {
            try { 
                database.insert(listFIDtoInsert, false);
                system.debug('Insert FID DONE');
            } Catch(exception ex) {
                system.debug('Insert FID Exception Error:'+ex.getmessage());
                //added for notification
                errorTxt += 'Erreur durant la création des fidélisation : ' + ex.getMessage() + '\n';
                containsErrors = true;
            } 
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = Label.BatchNotif_B004_ToAddress.split(';');
        String senderName = Label.BatchNotif_B004_SenderName;
        String subject = Label.BatchNotif_B004_Subject;
        
        String emailBody = 'L\'exécution du batch Batch016_CreditAutomatique s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        if(!Test.isRunningTest()) {
            AP01_SendEmail.sendEmail(toMailAddress, senderName, subject, emailBody, null);
        }
    }
    
    public static Fidelisation__c NewFID(ID foyerPanId,ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement, String TypePanel, String MotifCredit,Integer NbrsPoints, Id compositionDuFoyer, String typePanelIndividuPaneliste) {
        Fidelisation__c FID = new Fidelisation__c();
        List <Individu_Paneliste__c> ind = new List <Individu_Paneliste__c>();
        if(TypeMouvement!=null && MotifCredit!=null && NbrsPoints!=null) {
            if(TypePanel == Label.RFP_TypePanel_AIP) {
                system.debug('type AIP');
                ind = [select id, Foyer_paneliste__r.id, Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c from Individu_Paneliste__c where Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c = :Label.RFP_TypePanel_AIP and Foyer_paneliste__r.id = :foyerPanId];    
            } else {
                ind = [select id from Individu_Paneliste__c where Composition_du_foyer__c = :compositionDuFoyer and Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c = :typePanelIndividuPaneliste];
            }
            system.debug(ind);
            // system.debug(ind[0].Id);
            FID.Foyer_paneliste__c = foyerPanId;
            FID.Type_de_mouvement__c = TypeMouvement;
            FID.Motif_de_credit__c = MotifCredit;
            FID.Points_credites__c = NbrsPoints;
            FID.RecordTypeId = recordTypeIdFIDcredit;
            FID.Foyer__c = AccounId;
            if(compositionDuFoyer != null){
                FID.Composition_du_foyer__c	= compositionDuFoyer;
            }	
            if( (ind.size() > 0)) {
                FID.Individu_paneliste__c = ind[0].Id;
            }
            
        }
        System.debug('composition du foyer');
        System.debug(compositionDuFoyer);
        return FID;
    }
    
    public static Fidelisation__c NewFID_freeze(ID foyerPanId,ID AccounId,Id recordTypeIdFIDcredit, String TypeMouvement, String TypePanel, String MotifCredit,Integer NbrsPoints, Id compositionDuFoyer, String typePanelIndividuPaneliste) {
        Fidelisation__c FID = new Fidelisation__c();
        List <Individu_Paneliste__c> ind = new List <Individu_Paneliste__c>();
        if(TypeMouvement!=null && MotifCredit!=null && NbrsPoints!=null) {
            if(TypePanel == Label.RFP_TypePanel_AIP){
                system.debug('type AIP');
                ind = [select id, Foyer_paneliste__r.id, Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c from Individu_Paneliste__c where Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c = :Label.RFP_TypePanel_AIP and Foyer_paneliste__r.id = :foyerPanId];    
            } else {
                ind = [select id from Individu_Paneliste__c where Composition_du_foyer__c = :compositionDuFoyer and Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c = :typePanelIndividuPaneliste];
            }
            system.debug(ind);
            // system.debug(ind[0].Id);
            FID.Foyer_paneliste__c = foyerPanId;
            FID.Type_de_mouvement__c = TypeMouvement;
            FID.Motif_de_credit__c = MotifCredit;
            FID.Points_credites__c = NbrsPoints;
            FID.RecordTypeId = recordTypeIdFIDcredit;
            FID.Foyer__c = AccounId;
            FID.Commentaire__c = 'Aucun bonus mensuel car le foyer est freeze';
            if(compositionDuFoyer != null) {
                FID.Composition_du_foyer__c	= compositionDuFoyer;
            }	
            if( (ind.size() > 0) ){
                FID.Individu_paneliste__c = ind[0].Id;
            }
            
        }
        System.debug('composition du foyer');
        System.debug(compositionDuFoyer);
        return FID;
    }
    public static integer GetMonthsBetween(date duedate ) {
        decimal monthsBetweenDates = 0;
         
        if(duedate!=null && duedate <= Date.Today()) {
            integer DaysBetween = duedate.monthsbetween(Date.Today()); 
            return DaysBetween;
        }
        else {
            return null;
        }
    }
    
    //Added by MZ for MEDIAMETRIE-203 - START
    public static Boolean IsInstalledForMoreThanAMonth(date dateInstallation) {
        if(dateInstallation != null) {
            return (GetMonthsBetween(dateInstallation) > 1) || ((dateInstallation.month() == date.today().month() - 1) && (dateInstallation.day() == date.today().day()) && (dateInstallation.year() == date.today().year()));
        } else {
            return false;
        }
    }
    //Added by MZ for MEDIAMETRIE-203 - END
}