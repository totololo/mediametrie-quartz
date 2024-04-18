/*
* @date: 20/09/2021
* @ Description : 	-cloturer la requete de type pack initial quand le foyer paneliste passe au status installe 
*					-clôturer la requête de type welcom call si la date de la première émission de tous
les appareils du foyer est à 21 jours
-Cloturer la requete de type Remplacement materiel si la date de peremiere decetion est superieur a 7 jours
-cloture de la requete deType d’enregistrement = contrôle AIP, au 45eme jours ET Statut audimétrique du foyer panéliste = Non répondant 
=> generer un requete de type chute et //((Sous-type : chute forcée)) Sous-type : chute inactive
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: Batch009_ClotureRequeteAutomatique_Test
* @Coverage: 97%
History
* <Date of modification> 		<Author> 			<Description of modification>
* 06/09/2021 				Ayoub Ghammaz 			Cloture de la requete deType d’enregistrement = contrôle AIP
* 29/10/2021 				Claire VEHRLE 			Cloture des controles des requêtes non clôturées en fin de journée
* 12/01/2023				Marliatou D.			Clôturer la requête Welcome Call après la première collecte d'audience du dernier équipement
*/
global class Batch009_ClotureRequeteAutomatique implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        // String query = 'select id , recordTypeId,CreatedDate,Jour_de_traitement__c,J45__c,toLabel(foyer_paneliste__r.Statut_Audimetrique__c), AccountId,type,Sous_type__c,Type_de_controle__c,Nombre_de_tentatives_welcome_call__c,Status,Foyer_paneliste__r.Statut_Foyer_paneliste__c ,Foyer_paneliste__r.name,Foyer_paneliste__r.RecordTypeId, (select id ,name,Date_de_premiere_detection__c,Date_de_premiere_collecte_d_audience__c from quipements__r),(SELECT id, Statut__c FROM Controles__r) from case where type='+'\''+Label.CAS_Type_RemplacementMateriel
        //    +'\''+' or (type='+'\''+Label.CAS_Type_Non_repondant +'\''+' and ( not status='+'\''+Label.CAS_Statut_Cloture+'\''+')) or (type='+'\''+Label.CAS_Type_Anomalie_Materiel +'\''+' and ( not status='+'\''+Label.CAS_Statut_Cloture+'\''+')) or (type='+'\''+Label.CAS_Type_Suivi_Chute +'\''+' and ( not status='+'\''+Label.CAS_Statut_Cloture+'\''+')) or ( Sous_type__c='+'\''+Label.CAS_Sous_type_WelcomeCall+'\''+' and (not status='+'\''+Label.CAS_Statut_Cloture+'\''+')) or (Sous_type__c='+'\''+Label.CAS_Sous_type_PackInitial_SetMeter+'\''+' and (not status='+'\''+Label.CAS_Statut_Cloture+'\''+')) or (Sous_type__c='+'\''+Label.CAS_Sous_type_PackInitial+'\''+' and ( not status='+'\''+Label.CAS_Statut_Cloture+'\''+'))or (recordTypeId='+'\''+recordTypeIdControleAIP+'\''+' and ( not status='+'\''+Label.CAS_Statut_Cloture+'\''+'))';
        
        
        return Database.getQueryLocator([SELECT Id, RecordTypeId, CreatedDate, Jour_de_traitement__c, J45__c, 
                                         toLabel(foyer_paneliste__r.Statut_Audimetrique__c), AccountId,
                                         Type, Sous_type__c, Type_de_controle__c, Nombre_de_tentatives_welcome_call__c, 
                                         Status, Foyer_paneliste__r.Statut_Foyer_paneliste__c, Foyer_paneliste__r.Name, 
                                         Foyer_paneliste__r.RecordTypeId,
                                         (SELECT Id, Name, Date_de_premiere_detection__c, Date_de_premiere_collecte_d_audience__c FROM quipements__r),
                                         (SELECT Id, Statut__c, CreatedDate, Audimetre__c, Audimetre__r.Type_de_materiel__c,Libelle_de_pre_codage__c FROM Controles__r)
                                         FROM Case
                                         WHERE 
                                         origin != :label.CAS_Origine_Application_paneliste AND 
                                         ((Type = :Label.CAS_Type_RemplacementMateriel  AND Status != :Label.CAS_Statut_Cloture) OR
                                          (Type = :Label.CAS_Type_Non_repondant AND Status != :Label.CAS_Statut_Cloture) OR 
                                          (Type = :label.CAS_Type_Non_repondant_ROAV3 AND Status != :Label.CAS_Statut_Cloture) OR
                                          (Type = :Label.CAS_Type_Anomalie_Materiel AND Status != :Label.CAS_Statut_Cloture) OR
                                          (Type = :Label.CAS_Type_NonRepondantSetMeter AND Status != :Label.CAS_Statut_Cloture) OR                        
                                          (Type = :Label.CAS_Type_Suivi_Chute AND Status != :Label.CAS_Statut_Cloture) OR
                                          (Type = :Label.CAS_Type_InstallationSetMeter AND Status != :Label.CAS_Statut_Cloture) OR
                                          (Sous_type__c = :Label.CAS_Sous_type_WelcomeCall AND Status != :Label.CAS_Statut_Cloture) OR 
                                          (Sous_type__c = :Label.CAS_Sous_type_PackInitial_SetMeter AND Status != :Label.CAS_Statut_Cloture) OR 
                                          (Sous_type__c = :Label.CAS_Sous_type_PackInitial AND Status != :Label.CAS_Statut_Cloture) OR 
                                          (RecordTypeId = :recordTypeIdControleAIP AND Status != :Label.CAS_Statut_Cloture))]) ; 
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope){
        System.debug('Scope Case MD' + scope);
        //VAriables
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true; 
        Id recordTypeIdControleControleAIP =Schema.SObjectType.controle__c.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List<Id> ListIDFoyerPan= new List<Id>();// list id foyer pour pouvoir recuperer les equipements 
        //List<Id> ListIdFoyerPanSet= new List<Id>();// list Id Foyer pour Case de type Pack Initial et Setmeter
        List<Id> ListIdFoyerPanRAM= new List<Id>();// list Id Foyer pour Case Anomalie
        List<Foyer_Paneliste__c> ListFPanAnom= new List<Foyer_Paneliste__c>();// list Foyer Pan pour Case Anomalie
        List<Id> ListIdFoyerPAnSup = new List<Id>();// les foyers qui possedent des equipement detectes depuis 21 jours 
        List<Id> ListIdFoyerPanEq = new List<Id>(); // foyers dont la date de collecte est alimentée
        List<Id> ListIdFPanUpdate = new List<Id>(); 
        List<Case> ListrequeteToUpdate=new list<Case>();// les requetes a mettre a jour
        List<Case> caseToInsert = new List<Case>();
        List<Controle__c> controleToUpdate = new List<Controle__c>();
        List<Controle__c> listControleSetMeter = new List<Controle__c>(); //MD
        List<Controle__c> listControlePager = new List<Controle__c>(); //MD
        list<case> caseSuviChuteToupdate = new list<case>();
        list<case> ListFinalcaseSuviChuteToupdate = new list<case>();
        set<case> caseSuviChuteToupdateNoDup = new set<case>();
        list<case> caseSuvieChute = new list<case>();
        map<id,list<asset>> mapFoyAss = new map <id,list<asset>>();
        list<Foyer_paneliste__c> foyPanel = new list<Foyer_paneliste__c>();
        set<id> idFoyPan = new set<id>();
        map<id,list<case>> MapFoyerpanCase = new map<id,list<case>>();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        List<Controle__c> listContrleAIPAjd = new List<Controle__c>();
        
        listContrleAIPAjd = [SELECT Id FROM Controle__c WHERE CreatedDate = TODAY AND RecordTypeId = :recordTypeIdControleControleAIP];
        //Logique
        for(Case cs : scope){// pour chercher les equipements 
            if(cs.type==Label.CAS_Type_Anomalie_Materiel || cs.type==label.CAS_Type_RemplacementMateriel){// si requete de type Remplacement materiel ou Anomalie Matériel
                ListIdFoyerPanRAM.add(cs.Foyer_paneliste__c);
                if(MapFoyerpanCase.get(cs.Foyer_paneliste__c)==null){
                    MapFoyerpanCase.put(cs.Foyer_paneliste__c,new list<case>{cs});
                } 
                else{
                    MapFoyerpanCase.get(cs.Foyer_paneliste__c).add(cs);
                }
                
            } 
            
            if(cs.Sous_type__c==Label.CAS_Sous_type_WelcomeCall){// si requete de type welcom call => ajouter la liste du foyer pan pour chercher dans le for
                ListIDFoyerPan.add(cs.Foyer_paneliste__c);   
                System.debug('ListIDFoyerPan MD ' + ListIDFoyerPan);
            }
            
            // Si cest une requete de pack initial et setMeter et le statut foyer paneliste est installe = > cloturer la requete
            if(cs.Foyer_paneliste__r.Statut_Foyer_paneliste__c==Label.PAN_Statut_Panel_Installe && !ListrequeteToUpdate.contains(cs) 
               && (cs.Sous_type__c==Label.CAS_Sous_type_PackInitial || cs.Sous_type__c== Label.CAS_Sous_type_PackInitial_SetMeter)){          
                   cs.status=Label.CAS_Statut_Cloture;
                   System.debug('Pack Case  : '+ cs);                   
                   ListrequeteToUpdate.add(cs);
               }
            
            if(cs.Type == Label.CAS_Type_InstallationSetMeter && cs.Jour_de_traitement__c >= 7){          
                cs.status=Label.CAS_Statut_Cloture;                
                ListrequeteToUpdate.add(cs);
            }
            
            
            if(cs.recordTypeId== recordTypeIdControleAIP && listContrleAIPAjd.size() > 0){
                //System.debug('bastien cs.Jour_de_traitement__c : '+cs.Jour_de_traitement__c);
                
                // si le type d'enregistrement de la requete est controle aip, le type de contrôle Non-Répondant et le foyer pan est Répondant(Présent) => cloturer la requete de controle                
                if(cs.Type_de_controle__c == Label.CAS_TypeControle_Non_Repondant && cs.Type == Label.CAS_Type_Non_repondant && cs.foyer_paneliste__r.RecordTypeId == recordTypeIdPanelAIP 
                   && cs.foyer_paneliste__r.Statut_Audimetrique__c == Label.PAN_Statut_Audimetrique_Present_Batch009){
                       cs.Status=Label.CAS_Statut_Cloture;
                       System.debug('Case ' + cs);
                       System.debug('Case Status ' + cs.Status);
                       ListrequeteToUpdate.Add(cs);
                       System.debug('ListrequeteToUpdate ' + ListrequeteToUpdate);
                   }
                
                // si le type d'enregistrement de la requete est controle aip et le foyer pan est Non Repondant=> cloturer la requete de controle est creer une nouvelle requete de chute
                if(cs.Jour_de_traitement__c >=decimal.valueOf(Label.Batch009_NbJoursRequeteNonRepondant) && cs.foyer_paneliste__r.Statut_Audimetrique__c == Label.PAN_Statut_Audimetrique_nonRepondant){//J45__c
                    cs.Status=Label.CAS_Statut_Cloture;
                    ListrequeteToUpdate.Add(cs);                  
                    caseToInsert.add( new case(RecordTypeId = recordTypeIdRequeteDemandePanelisteAIP,
                                               //Mikael 05-01-2023
                                               //Origin = Label.CAS_Origine_Appel_sortant,
                                               Origin=Label.CAS_CaseOrigin_Controle,
                                               AccountId=cs.AccountId,
                                               Foyer_paneliste__c = cs.Foyer_paneliste__c,
                                               Type = Label.CAS_Type_DemandeChute,
                                               //Sous_type__c = Label.CAS_Sous_type_ChuteForcee
                                               Sous_type__c=Label.CAS_Sous_type_chute_inactive,
                                               Chute_confirmee__c = true
                                              ));
                }                                                          
                
                //Case Non Répondant SetMeter (Contrôle Type de Matériel SetMeter)
                if(cs.Type == Label.CAS_Type_NonRepondantSetMeter){
                    for(Controle__c ctrl : cs.Controles__r){
                        if(ctrl.Audimetre__r.Type_de_materiel__c == Label.ASS_TypeMateriel_Setmeter 
                           && ctrl.CreatedDate.date() == date.today()){ 
                               listControleSetMeter.add(ctrl);  
                               System.debug('listControleSetMeter ' + listControleSetMeter);
                           }                                        
                    } 
                    
                    if(listControleSetMeter == null || listControleSetMeter.size() == 0){
                        cs.Status = Label.CAS_Statut_Cloture;
                        ListrequeteToUpdate.Add(cs); 
                        System.debug('ListrequeteToUpdate SetM ' + ListrequeteToUpdate);
                    }
                }
                
                //Case Non Répondant (Contrôle Type de Matériel Pager)
                if(cs.Type == Label.CAS_Type_Non_repondant){
                    for(Controle__c ctrl : cs.Controles__r){
                        if(ctrl.Audimetre__r.Type_de_materiel__c == Label.ASS_TypeMateriel_Pager
                           && ctrl.CreatedDate.date() == date.today()){ 
                               listControlePager.add(ctrl);
                               System.debug('listControlePager ' + listControlePager);
                           } 
                    }
                    
                    if(listControlePager == null || listControlePager.size() == 0){
                        cs.Status = Label.CAS_Statut_Cloture;
                        ListrequeteToUpdate.Add(cs);
                        System.debug('ListrequeteToUpdate Pager ' + ListrequeteToUpdate);
                    }            
                }
                if (cs.Status != Label.CAS_Statut_Cloture) {
                    for (Controle__c ctrl: cs.Controles__r) {
                        if(ctrl.CreatedDate.date() != date.today() && ctrl.statut__c != label.CTRL_Statut_Traite){
                            ctrl.statut__c = Label.CTRL_Statut_Abandone;
                            controleToUpdate.add(ctrl);
                        }
                    }
                }
                
            }
            
            if (cs.Status == Label.CAS_Statut_Cloture) {
                // cs.Motif_de_cloture__c = label.CAS_Motif_de_cloture_Actif_avant_appel;
            }                                                         
        }
        
        
        List<Asset> assetsReMateriel = new List<Asset>();
        List<Asset> assetsAnoMateriel = new List<Asset>(); 
        set<case> ListerequeteToUpdateAno = new set<case>();
        list<case> ListrequeteToUpdateAno = new list<case>();
        list<case> ListrequeteToUpdateAnoFinal = new list<case>();
        list<asset> Equipements = [SELECT id,Date_de_premiere_detection__c,Date_de_premiere_collecte_d_audience__c,Foyer_paneliste__c from asset where Foyer_paneliste__c in :ListIdFoyerPanRAM and (Date_de_premiere_detection__c!=null or Date_de_premiere_collecte_d_audience__c!=null)] ;
        system.debug('asset'+Equipements);
        //For(Foyer_paneliste__c fp : ListFPanAnom){        // recuperer les equipements attaches au foyer pan                                    
        
        for(asset equ :Equipements){
            Integer nbJoursPremiereDetecte=0;
            Integer nbJoursDateCollecte=0;
            IF (equ.Date_de_premiere_detection__c !=null){
                nbJoursPremiereDetecte=equ.Date_de_premiere_detection__c.daysBetween(date.today());
            }
            if(nbJoursPremiereDetecte > decimal.valueOf(Label.Batch009_NBJours7)){// si la date est sup a 7 jours -> cloturer la requete de type Remplacement materiel
                assetsReMateriel.add(equ);
                ListrequeteToUpdateAno.addall(MapFoyerpanCase.get(equ.Foyer_paneliste__c));
            }
            //Ano Materiel  
            if (equ.Date_de_premiere_collecte_d_audience__c!=null){              
                nbJoursDateCollecte=equ.Date_de_premiere_collecte_d_audience__c.daysBetween(date.today());
            }
            if(nbJoursDateCollecte > decimal.valueOf(Label.Batch009_NBJours7)){// si la date est sup a 7 jours -> cloturer la requete de type Anomalie Matériel
                assetsAnoMateriel.add(equ);  
                for (case requ: MapFoyerpanCase.get(equ.Foyer_paneliste__c)){
                    if(requ.createddate > equ.Date_de_premiere_collecte_d_audience__c){
                        system.debug('heere');
                        ListrequeteToUpdateAno.add(requ);
                    }
                }
            }
        }
        
        system.debug('ListrequeteToUpdate'+ListrequeteToUpdate);
        ListerequeteToUpdateAno.addAll(ListrequeteToUpdateAno);
        ListrequeteToUpdateAnoFinal.addAll(ListerequeteToUpdateAno);
        for(Case cs :ListrequeteToUpdateAnoFinal){
            if(cs.Status!=Label.CAS_Statut_Cloture){
                cs.Status=Label.CAS_Statut_Cloture;
                System.debug('Case Ano ou Re  : '+ cs); 
                
            }             
        }
        if (ListrequeteToUpdateAnoFinal.size()>0) { 
            
            update ListrequeteToUpdateAnoFinal;
        }
        
        //Welcome Call
        for(Foyer_paneliste__c fp :[select id,name, 
                                    (select id,name,requete__c,Foyer_paneliste__c,Type_de_materiel__c,Date_de_premiere_detection__c,Date_de_premiere_collecte_d_audience__c from equipements__r)
                                    from Foyer_paneliste__c where id IN :ListIDFoyerPan and RecordTypeid=:recordTypeIdPanelAIP] ){// recuperer les equipements attaches au foyer pan
                                        List<Asset> appareils = new List<Asset>();
                                        List<Asset> assets = new List<Asset>();  
                                        
                                        for(asset equipement :fp.equipements__r){
                                            Integer nbJoursDetecte=0;
                                            Integer nbJoursCollecte=0;
                                            if(equipement.Date_de_premiere_detection__c!=null){// verifier combien de mois le beacon n'a pas transmit des données
                                                nbJoursDetecte = equipement.Date_de_premiere_detection__c.daysBetween(date.today());
                                            }
                                            if(nbJoursDetecte >= decimal.valueOf(Label.Batch009_NBJours_DatePremiereDetection)){// si la date est sup a 21 on ajoute pour pouvoir comparer si tt les equipements du foyer depassent 21 j
                                                appareils.add(equipement);
                                            }
                                            if(equipement.Date_de_premiere_collecte_d_audience__c != null){
                                                nbJoursCollecte = equipement.Date_de_premiere_collecte_d_audience__c.daysBetween(date.today());
                                                if(nbJoursCollecte >= decimal.valueOf(Label.Batch009_NBJours_DatePremiereDetection)){
                                                    assets.add(equipement);
                                                    System.debug('assets : ' + assets); 
                                                }                                                
                                                System.debug('equipement MD' + equipement);                                              
                                            }                                             
                                        }
                                        
                                        if(appareils.size()==fp.equipements__r.size() && appareils.size() >0 ){// verifier si tous les equipements sont sup a 21j
                                            ListIdFoyerPAnSup.add(fp.id);
                                        }
                                        
                                        if(assets.size()>0 && assets.size()==fp.equipements__r.size()){
                                            ListIdFoyerPanEq.add(fp.id);
                                            System.debug('ListIdFoyerPanEq MD' + ListIdFoyerPanEq);
                                        }
                                        
                                    }
        if(ListIdFoyerPAnSup.size() >0 && ListIdFoyerPAnSup != null){
            for(Case cs :scope){
                if(ListIdFoyerPAnSup.contains(cs.Foyer_paneliste__c) && cs.Sous_type__c==Label.CAS_Sous_type_WelcomeCall){
                    cs.Status=Label.CAS_Statut_Cloture;
                    cs.Motif_de_cloture__c = label.CAS_Motif_de_cloture_Actif_avant_appel;
                    if(!ListrequeteToUpdate.contains(cs)){
                        ListrequeteToUpdate.add(cs); 
                    }
                    
                }
            }  
        }
        if(ListIdFoyerPanEq.size() >0 && ListIdFoyerPanEq != null){
            for(Case cs :scope){
                if((ListIdFoyerPanEq.contains(cs.Foyer_paneliste__c) && cs.Sous_type__c==Label.CAS_Sous_type_WelcomeCall) 
                   ||cs.Nombre_de_tentatives_welcome_call__c == decimal.valueOf(Label.CAS_nombre_tentatives_appel)){
                       cs.Status=Label.CAS_Statut_Cloture;
                       if(!ListrequeteToUpdate.contains(cs)){
                           ListrequeteToUpdate.add(cs); 
                       }
                       
                   }
            }
            System.debug('ListrequeteToUpdate MD' + ListrequeteToUpdate);
        }
        
        //requete suivie chute
        //YH 
        
        for (case cs:scope){
            if (cs.Type==Label.CAS_Type_Suivi_Chute){
                caseSuvieChute.add(cs);
            }
        }
        system.debug('case '+caseSuvieChute);
        for (case cs:caseSuvieChute){
            idFoyPan.add(cs.Foyer_paneliste__c);
        }
        foyPanel = [select id , (select id ,status from  Equipements__r) from Foyer_paneliste__c where id in :idFoyPan];
        
        for (Foyer_paneliste__c foy:foyPanel){
            mapFoyAss.put(foy.id,foy.Equipements__r);
        }
        integer i=0;
        
        for (case cs:caseSuvieChute){ 
            for (asset equip:mapFoyAss.get(cs.Foyer_paneliste__c)){
                system.debug('ass '+mapFoyAss.get(cs.Foyer_paneliste__c).size());
                if (equip.Status!=label.ASS_Statut_Installe){
                    system.debug('ii'+i);
                    i+=1;
                    
                }
                if (mapFoyAss.get(cs.Foyer_paneliste__c).size() ==i || mapFoyAss.get(cs.Foyer_paneliste__c).size()==null ){
                    system.debug('aaa');
                    cs.Status=Label.CAS_Statut_Cloture;
                    caseSuviChuteToupdate.add(cs);
                    
                }
                
            }
            i=0;
        }
        caseSuviChuteToupdateNoDup.addall(caseSuviChuteToupdate);
        ListFinalcaseSuviChuteToupdate.addall(caseSuviChuteToupdateNoDup);
        if (ListFinalcaseSuviChuteToupdate.size()>0){
            system.debug('suivi chute' +ListFinalcaseSuviChuteToupdate);
            update ListFinalcaseSuviChuteToupdate;
        }
        
        
        if(ListrequeteToUpdate.size()>0 && ListrequeteToUpdate != null){
            try{ 
                database.update(ListrequeteToUpdate);
                System.debug('ListrequeteToUpdate DM' + ListrequeteToUpdate);
            }Catch(exception ex){
                system.debug('Update requete (batche009) Exception Error:'+ex.getmessage());
            }
        }
        if(caseToInsert!=null && caseToInsert.size()>0){
            try{ 
                database.insert(caseToInsert);
            }Catch(exception ex){
                system.debug('insert requete (batche009) Exception Error:'+ex.getmessage());
                errorTxt += 'Erreur durant l\'insertion : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
        }
        if(controleToUpdate!=null && controleToUpdate.size()>0){
            try{ 
                database.update(controleToUpdate);
            }Catch(exception ex){
                system.debug('update controle (batche009) Exception Error:'+ex.getmessage());
                errorTxt += 'Erreur durant la MAJ : ' + ex.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        
    }
    
    global void finish(Database.BatchableContext bc){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B009C_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B009C_SenderName);
        mail.setSubject(System.Label.BatchNotif_B009C_Subject);
        
        String emailBody = 'L\'exécution du batch Batch009_ClotureRequeteAutomatique s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.\n';
            
        }
        mail.setPlainTextBody(emailBody);
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
}