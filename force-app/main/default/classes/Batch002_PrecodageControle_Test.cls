/*
* @Auteur Joyce Saidy
* @date: 14/09/2020
* @Classe: Batch002_PrecodageControle, AP01_Controle, AP02_Controle
* * History
* <Date of modification>   		<Author>    		<Description of modification>
* 		18/10/2021   			Claire VEHRLE  		   Ajout du test des précodage pour les contrôles AIP
*/

@isTest
public class Batch002_PrecodageControle_Test {
    
    public static testMethod void AP01_ControleTest(){
        
        Profile pfAdmin= [Select Id from profile where Name='Administrateur système' or  Name='System Administrator']; 

      User uu=new User(firstname = 'testFirst', 
                         lastName = 'testLast', 
                         email = 't@test.org', 
                         Username = 't@test.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = 'test12', 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pfAdmin.Id,
                       	 isActive = true
                        ); 
        uu.Bypass_flows__c = true;
        uu.Bypass_triggers__c='AP08_ServiceAppointment';
        uu.Bypass_validation_rules__c = true;
        insert uu;
        
        
         System.runAs(uu){
                
        Id ControleMMPaMEId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        
        //Create Jours Ferie
        list<Jour_ferie__c> listJourFerieToInsert = new list<Jour_ferie__c>();
        Jour_ferie__c JrsFerie = Test_Utils.createJourFerie(system.today()+1,'Fete1');   
        listJourFerieToInsert.add(JrsFerie);  
       
        insert listJourFerieToInsert;
         string fer = string.valueof(JrsFerie.Date_du_jour_ferie__c);
        datetime vacc = system.today()+1;
        AP01_controle.checkIfPublicHoliday(vacc,fer);
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account acc = Test_Utils.createFoyer();
        acc.Date_d_installation__c=system.today()-2;
        acc.Suspendu__c=true;
        acc.Motif_de_suspension__c='41';
        acc.Date_de_suspension__c=system.today();
        acc.Date_d_integration__c=null;
        acc.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc); 
        
        account acc3 = Test_Utils.createFoyer(); 
        acc3.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc3.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc3); 
        
        account acc2 = Test_Utils.createFoyer(); 
        acc2.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc2.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc2); 
        
        account acc4 = Test_Utils.createFoyer(); 
        acc4.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc4.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc4);
        
        account acc5 = Test_Utils.createFoyer(); 
        acc5.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc5.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc5);
        
        account acc6 = Test_Utils.createFoyer(); 
        acc6.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc6.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc6);
        
        account acc7 = Test_Utils.createFoyer(); 
        acc7.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc7.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc7);
        
        account acc8 = Test_Utils.createFoyer(); 
        acc8.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc8.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc8);
        
        account acc9 = Test_Utils.createFoyer(); 
        acc9.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc9.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc9);
        
        account acc10 = Test_Utils.createFoyer(); 
        acc10.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc10.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc10);
        
        account acc11 = Test_Utils.createFoyer(); 
        acc11.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc11.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc11);
        
        account acc12 = Test_Utils.createFoyer(); 
        acc11.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc11.Numero_de_portable__c = '0611111122';
        listFoyersToInsert.add(acc12);
        
        account acc13 = Test_Utils.createFoyer(); 
        acc13.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc13.Numero_de_portable__c = '0613111122';
        listFoyersToInsert.add(acc13);
        
        insert listFoyersToInsert;  
        
           
        //creer foyer paneliste 
         Foyer_paneliste__c paneliste = new Foyer_paneliste__c(name='PanelisteTest',Foyer__c= acc.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe); //MD
         insert paneliste; //MD
        
        
        //Create old controls
        list<Controle__c> listOldControlsToInsert = new list<Controle__c>();
        Controle__c oldControl = Test_Utils.createControle(acc11.id, Null, Null, Null,System.today());  
        oldControl.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        oldControl.Sous_type_de_controle__c=Label.CTRL_SousType_AutresUsages; 
        oldControl.Statut__c=Label.CTRL_StatutActif;
        oldControl.Foyer_paneliste__c = paneliste.Id; //MD
        oldControl.createdDate = date.today() - 1;
        listOldControlsToInsert.add(oldControl);
        
        Controle__c oldControl1 = Test_Utils.createControle(acc11.id, Null, Null, Null,System.today());  
        oldControl1.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        oldControl1.Sous_type_de_controle__c=Label.CTRL_SousType_AudimetreNonConnecte; 
        oldControl1.Statut__c=Label.CTRL_Statut_Traite;
        oldControl1.Foyer_paneliste__c = paneliste.Id; //MD
        oldControl1.createdDate = date.today() - 1;
        listOldControlsToInsert.add(oldControl1);
        
        insert listOldControlsToInsert;
        
        //Create Membre Foyer
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        Contact Cont = Test_Utils.createMembreFoyer(acc.id); 
        cont.Birthdate=system.today().addyears(-5);
        cont.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont.Classification__c = Label.CON_Classification_Employe;
        cont.CSP4__c = '1';
        cont.Code_profession__c = 1;
        listMembreFoyerToInsert.add(Cont);  
        
        Contact Cont1 = Test_Utils.createMembreFoyer(acc.id); 
        Cont1.Birthdate=system.today().addyears(-10);
        cont1.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille; 
        cont1.Classification__c = Label.CON_Classification_Employe;
        cont1.CSP4__c = '2';
        cont1.Code_profession__c = 1;
        listMembreFoyerToInsert.add(Cont1);
        
        Contact Cont2 = Test_Utils.createMembreFoyer(acc3.id); 
        Cont2.Birthdate=system.today().addyears(-20); 
        cont2.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont2.Classification__c = Label.CON_Classification_Employe;
        cont2.CSP4__c = '3';
        cont2.Code_profession__c = 1;
        listMembreFoyerToInsert.add(Cont2);
        insert listMembreFoyerToInsert; 
        
        //Create Conge
        list<Conge__c> listCongeToInsert = new list<Conge__c>();
        Conge__c cong = Test_Utils.createConge(acc.id, Cont1.Id); 
        cong.Date_de_debut__c = System.today()-2;
        Cong.Date_de_fin__c= System.today()+4;     
        listCongeToInsert.add(cong);  
        
        Conge__c cong1 = Test_Utils.createConge(acc3.id, Cont2.Id);
        cong1.Motif__c = Label.CONG_Motif_Autre;
        cong1.Date_de_debut__c = System.today()-2;
        cong1.Date_de_fin__c= System.today()+4;   
        listCongeToInsert.add(cong1);
        
        Conge__c cong2 = Test_Utils.createConge(acc.id, Cont.Id);
        cong2.Motif__c = Label.CONG_Motif_Autre;
        cong2.Date_de_debut__c = System.today()-2;
        cong2.Date_de_fin__c= System.today()+4;   
        listCongeToInsert.add(cong2);
        
        insert listCongeToInsert;  
                
        Controle__c c1 = new Controle__c();
        c1.Type_de_controle__c=Label.CTRL_Type_Connexion;
        c1.Sous_type_de_controle__c= Label.CTRL_SousType_AudimetreNonConnecte;
        c1.Foyer__c=acc13.Id;
        c1.Foyer_paneliste__c = paneliste.Id; //MD
        c1.CreatedDate=system.today();
        insert c1;
        
        AP01_controle.checkIfHouseholdOrMemberOnVacation(c1, listCongeToInsert);
        //Foyer Paneliste
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        Foyer_paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste.Foyer__c = acc.Id;
        foyerPaneliste.Date_d_installation__c = system.today()-2;
        foyerPaneliste.Suspendu__c = true;
        foyerPaneliste.Motif_de_suspension__c = Label.PAN_Motif_de_Suspension_Chute;
        foyerPaneliste.Date_de_suspension__c = system.today();
        foyerPaneliste.Date_d_integration__c = null;
        //foyerPaneliste.statut_audimetrique__c = Label.Statut_audimetrique_vacances;
        foyerPanelisteList.add(foyerPaneliste);
        
        Foyer_paneliste__c foyerPaneliste1 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Foyer__c = acc12.Id;
        foyerPaneliste1.Date_d_installation__c = system.today()-2;
        foyerPaneliste1.Date_d_integration__c = null;
        //foyerPaneliste1.statut_audimetrique__c = Label.Statut_audimetrique_vacances;
        foyerPanelisteList.add(foyerPaneliste);
        
        Foyer_paneliste__c foyerPaneliste2 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste2.Foyer__c = acc13.Id;
        foyerPaneliste2.Date_d_installation__c = system.today()-2;
        foyerPaneliste2.Date_d_integration__c =SYSTEM.today();
        foyerPaneliste2.statut_audimetrique__c = '1';
        //foyerPaneliste2.Foyer__c=acc13.id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPaneliste;
        insert foyerPaneliste1;
        insert foyerPaneliste2;
        
        Controle__c c = new Controle__c();
        c.Type_de_controle__c=label.CTRL_Type_Participation;
        c.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h;
        c.Foyer__c=acc13.Id;
        c.Foyer_paneliste__c=foyerPaneliste2.Id;  
        insert c;
        //Create Case
        list<Case> listCaseToInsert = new list<Case>();
        Case req = Test_Utils.createCase(acc.id);
        req.Foyer_paneliste__c = foyerPaneliste.Id;
        listCaseToInsert.add(req);  
        insert listCaseToInsert; 
        
        
        //Create Etiquette et controle custom setting
        list<Etiquettes_et_controles__c> listEtqCtrlToInsert = new list<Etiquettes_et_controles__c>();
        Etiquettes_et_controles__c EtqCtrl = Test_Utils.createEtqCtrl();
        EtqCtrl.Type_controle__c=Label.CTRL_Type_Connexion;
        EtqCtrl.Sous_type_controle__c=Label.CTRL_SousType_AudimetreNonConnecte;
        EtqCtrl.Nom_de_l_etiquette__c=Label.ETI_Nom_de_l_etiquette_Ticket_Incident;
        EtqCtrl.Libell_de_pr_codage__c=Label.ETI_Nom_de_l_etiquette_Ticket_Incident;
        listEtqCtrlToInsert.add(EtqCtrl);  
        insert listEtqCtrlToInsert; 
        
        date d2 = system.today();
        date d3 = system.today() + 5;
        date d4 = system.today() -11;
        
        Etiquette__c etq1 = new Etiquette__c();
        etq1.Nom_de_l_etiquette__c='Présence foyer';
        etq1.Date_de_debut__c = d2;
        etq1.Date_de_fin__c=d3;
        etq1.Foyer_paneliste__c=foyerPaneliste2.id;
        etq1.Foyer__c=acc13.id;
         
        insert etq1;
        test.setCreatedDate(etq1.id, d4);
        etq1.Date_de_debut__c=system.today()-5;
        update etq1;
        //Create Audimetre
        Id posteRecordTypeId = Schema.SObjectType.asset.getRecordTypeInfosByName().get(Label.RecType_DevName_Poste).getRecordTypeId();
        list<asset> listEquipementToInsert = new list<asset>();
        asset poste1 = new asset();
        poste1.RecordTypeId = posteRecordTypeId;
        poste1.Name = 'Poste Test';
        poste1.AccountId = acc5.Id;
        listEquipementToInsert.add(poste1);
        
        Insert listEquipementToInsert;
        datetime d = dateTime.newInstance(2023, 1, 29,22,33,44);
        AP01_Controle.checkIfSunday(d);
        //Create Controle
        List<Controle__c> listControleToInsert = new List<Controle__c>();
        Controle__c ctrl = Test_Utils.createControle(acc11.id, Null, Null, req.id,System.today());   
        ctrl.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl.Membre_du_foyer__c = Cont1.Id;
        ctrl.RecordTypeId = ControleMMPaMEId;
        ctrl.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudience6Jours; 
        ctrl.Statut__c=Label.CTRL_StatutActif;
        insert ctrl;
        //Test.setcreateddate(ctrl.id,d);
        //listControleToInsert.add(ctrl);
        
        Controle__c ctrl45 = Test_Utils.createControle(acc12.id, Null, Null, req.id,System.today());   
        ctrl45.Foyer_paneliste__c = foyerPaneliste1.Id;
        ctrl45.RecordTypeId = ControleMMPaMEId;
        ctrl45.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl45.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudience6Jours; 
        ctrl45.Statut__c=Label.CTRL_StatutActif;
        insert ctrl45;
        Test.setcreateddate(ctrl45.id,d);
        datetime d1 = datetime.newInstance(2023, 1, 28,11,22,33);
        AP01_Controle.checkIfWeekend(d1);
        Controle__c ctrl44 = Test_Utils.createControle(acc12.id, Null, Null, req.id,System.today());   
        ctrl44.Foyer_paneliste__c = foyerPaneliste1.Id;
        //ctrl44.Membre_du_foyer__c = Cont1.Id;
        ctrl44.RecordTypeId = ControleMMPaMEId;
        ctrl44.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl44.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerAvecAboSansAud; 
        ctrl44.Statut__c=Label.CTRL_StatutActif;
        insert ctrl44;
        Test.setcreateddate(ctrl44.id,d1);
        
        Controle__c ctrl1 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl1.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl1.Membre_du_foyer__c = Cont1.Id;
        ctrl1.RecordTypeId = ControleMMPaMEId;
        ctrl1.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl1.Sous_type_de_controle__c=Label.CTRL_SousType_NonEnvoyeMediamat; 
        ctrl1.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl1);
        
        
        Controle__c ctrl2 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());      
        ctrl2.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl2.Membre_du_foyer__c = Cont1.Id;
        ctrl2.RecordTypeId = ControleMMPaMEId;
        ctrl2.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl2.Sous_type_de_controle__c=Label.CTRL_SousType_AnomalieTraitementDonnees; 
        ctrl2.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl2); 
        
        Controle__c ctrl3 = Test_Utils.createControle(acc.id, cont.Id, Null, req.id,System.today());    
        ctrl3.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl3.RecordTypeId = ControleMMPaMEId;
        ctrl3.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl3.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h; 
        ctrl3.Statut__c=Label.CTRL_StatutActif; 
        listControleToInsert.add(ctrl3); 
        
        Controle__c ctrl4 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());      
        ctrl4.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl4.Membre_du_foyer__c = Cont1.Id;
        ctrl4.RecordTypeId = ControleMMPaMEId;
        ctrl4.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl4.Sous_type_de_controle__c=Label.CTRL_SousType_TVOnPlus12h; 
        ctrl4.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl4); 
        
        Controle__c ctrl5 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl5.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl5.Membre_du_foyer__c = Cont1.Id;
        ctrl5.RecordTypeId = ControleMMPaMEId;
        ctrl5.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl5.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudience6Jours; 
        ctrl5.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl5);
             
        
        Controle__c ctrl551 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl551.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl551.Membre_du_foyer__c = Cont1.Id;
        ctrl551.RecordTypeId = ControleMMPaMEId;
        ctrl551.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl551.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h;
        ctrl551.Date_de_controle__c=Datetime.now();
        ctrl551.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl551); 
             
        Controle__c ctrl552 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl552.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl552.Membre_du_foyer__c = Cont1.Id;
        ctrl552.RecordTypeId = ControleMMPaMEId;
        ctrl552.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl552.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h;
        ctrl552.Date_de_controle__c=Datetime.now();
        ctrl552.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl552); 
             
       	Controle__c ctrl553 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl553.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl553.Membre_du_foyer__c = Cont1.Id;
        ctrl553.RecordTypeId = ControleMMPaMEId;
        ctrl553.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl553.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerAvecAboSansAud;
        ctrl553.Date_de_controle__c=Datetime.now();
        ctrl553.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl553); 
        
        Controle__c ctrl6 = Test_Utils.createControle(acc.id, cont.id, Null, req.id,System.today());      
        ctrl6.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl6.Membre_du_foyer__c = Cont1.Id;
        ctrl6.RecordTypeId = ControleMMPaMEId;
        ctrl6.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl6.Sous_type_de_controle__c=Label.CTRL_SousType_IndividuSansAudience28Jours; 
        ctrl6.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl6); 
        
        Controle__c ctrl7 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());     
        ctrl7.Foyer_paneliste__c = foyerPaneliste.Id; 
        ctrl7.Membre_du_foyer__c = Cont1.Id;
        ctrl7.RecordTypeId = ControleMMPaMEId;
        ctrl7.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl7.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl7.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl7); 
        
        Controle__c ctrl8 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());      
        ctrl8.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl8.Membre_du_foyer__c = Cont1.Id;
        ctrl8.RecordTypeId = ControleMMPaMEId;
        ctrl8.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl8.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerAvecAboSansAud; 
        ctrl8.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl8);
        
        Controle__c ctrl9 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());      
        ctrl9.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl9.Membre_du_foyer__c = Cont1.Id;
        ctrl9.RecordTypeId = ControleMMPaMEId;
        ctrl9.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl9.Sous_type_de_controle__c=Label.CTRL_SousType_RejeteMediamat; 
        ctrl9.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl9); 
        
        Controle__c ctrl10 = Test_Utils.createControle(acc.id, cont1.id, Null, req.id,System.today());      
        ctrl10.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl10.RecordTypeId = ControleMMPaMEId;
        ctrl10.Type_de_controle__c=Label.CTRL_Type_ParticipationWeb;
        ctrl10.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansActiviteWebCoherente; 
        ctrl10.Statut__c=Label.CTRL_StatutActif;
        listControleToInsert.add(ctrl10);
        
        Controle__c ctrl11 = Test_Utils.createControle(acc.id, Null, Null, req.id,System.today());      
        ctrl11.Foyer_paneliste__c = foyerPaneliste.Id;
        ctrl11.Membre_du_foyer__c = Cont1.Id;
        ctrl11.RecordTypeId = ControleMMPaMEId;
        ctrl11.Type_de_controle__c=Label.CTRL_Type_ParticipationWeb;
        ctrl11.Sous_type_de_controle__c=Label.CTRL_SousType_IndividuSansActiviteWebCoherente; 
        ctrl11.Statut__c=Label.CTRL_StatutActif; 
        listControleToInsert.add(ctrl11) ;
        
        Controle__c ctrl12 = Test_Utils.createControle(acc2.id, Null, Null, req.id,System.today());   
        ctrl12.RecordTypeId = ControleMMPaMEId;
        ctrl12.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl12.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl12.Statut__c=Label.CTRL_StatutActif;
        ctrl12.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl12);
        
        Controle__c ctrl13 = Test_Utils.createControle(acc3.id, cont2.Id, Null, req.id,System.today());   
        ctrl13.RecordTypeId = ControleMMPaMEId;
        ctrl13.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl13.Sous_type_de_controle__c=Label.CTRL_SousType_AnomalieTraitementDonnees; 
        ctrl13.Statut__c=Label.CTRL_StatutActif;
        ctrl13.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl13);
        
        Controle__c ctrl14 = Test_Utils.createControle(acc4.id, cont2.Id, Null, req.id,System.today());   
        ctrl14.RecordTypeId = ControleMMPaMEId;
        ctrl14.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl14.Sous_type_de_controle__c=Label.CTRL_SousType_TVOnPlus12h; 
        ctrl14.Statut__c=Label.CTRL_StatutActif;
        ctrl14.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl14);
        
        Controle__c ctrl15 = Test_Utils.createControle(acc4.id, Null, Null, req.id,System.today());   
        ctrl15.RecordTypeId = ControleMMPaMEId;
        ctrl15.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl15.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl15.Statut__c=Label.CTRL_StatutActif;
        ctrl15.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl15);
        
        Controle__c ctrl16 = Test_Utils.createControle(acc5.id, Null, Null, req.id,System.today());   
        ctrl16.RecordTypeId = ControleMMPaMEId;
        ctrl16.Type_de_controle__c=Label.CTRL_Type_Connexion;
        ctrl16.Sous_type_de_controle__c=Label.CTRL_SousType_AudimetreNonConnecte; 
        ctrl16.Statut__c=Label.CTRL_StatutActif;
        ctrl16.Audimetre__c = poste1.Id;
        ctrl16.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl16);
        
        Controle__c ctrl17 = Test_Utils.createControle(acc5.id, Null, Null, req.id,System.today() - 1);   
        ctrl17.RecordTypeId = ControleMMPaMEId;
        ctrl17.Type_de_controle__c=Label.CTRL_Type_Connexion;
        ctrl17.Sous_type_de_controle__c=Label.CTRL_SousType_AudimetreNonConnecte; 
        ctrl17.Statut__c=Label.CTRL_Statut_Traite;
        ctrl17.Audimetre__c = poste1.Id;
        ctrl17.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl17);
        
        Controle__c ctrl18 = Test_Utils.createControle(acc5.id, Null, Null, req.id,System.today());   
        ctrl18.RecordTypeId = ControleMMPaMEId;
        ctrl18.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        ctrl18.Sous_type_de_controle__c=Label.CTRL_TypeAutresUsages; 
        ctrl18.Statut__c=Label.CTRL_Statut_Traite;
        ctrl18.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl18);
        
        Controle__c ctrl19 = Test_Utils.createControle(acc5.id, Null, Null, req.id,System.today() - 1);   
        ctrl19.RecordTypeId = ControleMMPaMEId;
        ctrl19.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        ctrl19.Sous_type_de_controle__c=Label.CTRL_TypeAutresUsages; 
        ctrl19.Statut__c=Label.CTRL_Statut_Traite;
        ctrl19.Joint_non_joint__c = true;
        ctrl19.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl19);
        
        Controle__c ctrl20 = Test_Utils.createControle(acc5.id, Null, Null, req.id,System.today());   
        ctrl20.RecordTypeId = ControleMMPaMEId;
        ctrl20.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl20.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl20.Statut__c=Label.CTRL_Statut_Traite;
        ctrl20.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl20);
        
        Controle__c ctrl21 = Test_Utils.createControle(acc6.id, Null, Null, req.id,System.today());   
        ctrl21.RecordTypeId = ControleMMPaMEId;
        ctrl21.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl21.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl21.Statut__c=Label.CTRL_Statut_Traite;
        ctrl21.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        ctrl21.Joint_non_joint__c = true;
        listControleToInsert.add(ctrl21);
        
        Controle__c ctrl22 = Test_Utils.createControle(acc6.id, Null, Null, req.id,System.today() - 15);   
        ctrl22.RecordTypeId = ControleMMPaMEId;
        ctrl22.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl22.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl22.Statut__c=Label.CTRL_Statut_Traite;
        ctrl22.Joint_non_joint__c = true;
        ctrl22.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl22);
        
        Controle__c ctrl23 = Test_Utils.createControle(acc6.id, Null, Null, req.id,System.today());   
        ctrl23.RecordTypeId = ControleMMPaMEId;
        ctrl23.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl23.Sous_type_de_controle__c=Label.CTRL_SousType_AnomalieTraitementDonnees; 
        ctrl23.Statut__c=Label.CTRL_Statut_Traite;
        ctrl23.Joint_non_joint__c = true;
        ctrl23.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl23);
        
        Controle__c ctrl24 = Test_Utils.createControle(acc6.id, Null, Null, req.id,System.today());   
        ctrl24.RecordTypeId = ControleMMPaMEId;
        ctrl24.Type_de_controle__c=Label.CTRL_Type_Connexion;
        ctrl24.Sous_type_de_controle__c=Label.CTRL_SousType_AudimetreNonConnecte; 
        ctrl24.Statut__c=Label.CTRL_StatutActif;
        ctrl24.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl24);
        
        Controle__c ctrl25 = Test_Utils.createControle(acc7.id, Null, Null, req.id,System.today());   
        ctrl25.RecordTypeId = ControleMMPaMEId;
        ctrl25.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl25.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudience6Jours; 
        ctrl25.Statut__c=Label.CTRL_StatutActif;
        ctrl25.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl25);
        
        Controle__c ctrl26 = Test_Utils.createControle(acc7.id, Null, Null, req.id,System.today() - 1);   
        ctrl26.RecordTypeId = ControleMMPaMEId;
        ctrl26.Type_de_controle__c=Label.CTRL_Type_Presence;
        ctrl26.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudience6Jours; 
        ctrl26.Statut__c=Label.CTRL_StatutActif;
        ctrl26.Joint_non_joint__c = true;
        ctrl26.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl26);
        
        Controle__c ctrl27 = Test_Utils.createControle(acc7.id, Null, Null, req.id,System.today());   
        ctrl27.RecordTypeId = ControleMMPaMEId;
        ctrl27.Type_de_controle__c=Label.CTRL_Type_ParticipationWeb;
        ctrl27.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansActiviteWebCoherente; 
        ctrl27.Statut__c=Label.CTRL_StatutActif;
        ctrl27.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl27);
        
        Controle__c ctrl28 = Test_Utils.createControle(acc7.id, Null, Null, req.id,System.today() - 1);   
        ctrl28.RecordTypeId = ControleMMPaMEId;
        ctrl28.Type_de_controle__c=Label.CTRL_Type_ParticipationWeb;
        ctrl28.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansActiviteWebCoherente; 
        ctrl28.Statut__c=Label.CTRL_StatutActif;
        ctrl28.Joint_non_joint__c = true;
        ctrl28.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl28);
        
        Controle__c ctrl29 = Test_Utils.createControle(acc8.id, Null, Null, req.id,System.today());   
        ctrl29.RecordTypeId = ControleMMPaMEId;
        ctrl29.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl29.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h; 
        ctrl29.Statut__c=Label.CTRL_StatutActif;
        ctrl29.Foyer_paneliste__c = foyerPaneliste.Id; //MD
        listControleToInsert.add(ctrl29);
        
        Controle__c ctrl30 = Test_Utils.createControle(acc8.id, Null, Null, req.id,System.today() - 1);   
        ctrl30.RecordTypeId = ControleMMPaMEId;
        ctrl30.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl30.Sous_type_de_controle__c=Label.CTRL_SousType_AudienceIndividuellePlus7h; 
        ctrl30.Statut__c=Label.CTRL_StatutActif;
        ctrl30.Joint_non_joint__c = true;
        ctrl30.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl30);
        
        Controle__c ctrl31 = Test_Utils.createControle(acc9.id, Null, Null, req.id,System.today());   
        ctrl31.RecordTypeId = ControleMMPaMEId;
        ctrl31.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl31.Sous_type_de_controle__c=Label.CTRL_SousType_AnomalieTraitementDonnees; 
        ctrl31.Statut__c=Label.CTRL_StatutActif;
        ctrl31.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl31);
        
        Controle__c ctrl32 = Test_Utils.createControle(acc9.id, Null, Null, req.id,System.today());   
        ctrl32.RecordTypeId = ControleMMPaMEId;
        ctrl32.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl32.Sous_type_de_controle__c=Label.CTRL_SousType_TVOnPlus12h; 
        ctrl32.Statut__c=Label.CTRL_StatutActif;
        ctrl32.Joint_non_joint__c = true;
        ctrl32.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl32);
        
        Controle__c ctrl33 = Test_Utils.createControle(acc10.id, Null, Null, req.id,System.today());   
        ctrl33.RecordTypeId = ControleMMPaMEId;
        ctrl33.Type_de_controle__c=Label.CTRL_Type_Connexion;
        ctrl33.Sous_type_de_controle__c=Label.CTRL_SousType_AudimetreNonConnecte; 
        ctrl33.Statut__c=Label.CTRL_StatutActif;
        ctrl33.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl33);
        
        Controle__c ctrl34 = Test_Utils.createControle(acc10.id, Null, Null, req.id,System.today());   
        ctrl34.RecordTypeId = ControleMMPaMEId;
        ctrl34.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl34.Sous_type_de_controle__c=Label.CTRL_SousType_TVOnPlus12h; 
        ctrl34.Statut__c=Label.CTRL_StatutActif;
        ctrl34.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl34);
        
        Controle__c ctrl35 = Test_Utils.createControle(acc10.id, Null, Null, req.id,System.today());   
        ctrl35.RecordTypeId = ControleMMPaMEId;
        ctrl35.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl35.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansActiviteRouteur; 
        ctrl35.Statut__c=Label.CTRL_StatutActif;
        ctrl35.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl35);
        
        Controle__c ctrl36 = Test_Utils.createControle(acc10.id, Null, Null, req.id,System.today());   
        ctrl36.RecordTypeId = ControleMMPaMEId;
        ctrl36.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl36.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl36.Statut__c=Label.CTRL_StatutActif;
        ctrl36.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl36);
        
        Controle__c ctrl37 = Test_Utils.createControle(acc11.id, Null, Null, req.id,System.today());   
        ctrl37.RecordTypeId = ControleMMPaMEId;
        ctrl37.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        ctrl37.Sous_type_de_controle__c=Label.CTRL_SousType_AutresUsages; 
        ctrl37.Statut__c=Label.CTRL_StatutActif;
        ctrl37.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl37);
        
        Controle__c ctrl38 = Test_Utils.createControle(acc11.id, Null, Null, req.id,System.today());   
        ctrl38.RecordTypeId = ControleMMPaMEId;
        ctrl38.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        ctrl38.Sous_type_de_controle__c=Label.CTRL_SousType_AutresUsages; 
        ctrl38.Statut__c=Label.CTRL_StatutActif;
        ctrl38.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl38);
        
        Controle__c ctrl39 = Test_Utils.createControle(acc8.id, Null, Null, req.id,System.today());   
        ctrl39.RecordTypeId = ControleMMPaMEId;
        ctrl39.Type_de_controle__c=Label.CTRL_Type_Reception_abonnement;
        ctrl39.Sous_type_de_controle__c=Label.CTRL_SousType_FoyerSansAudSansAbo; 
        ctrl39.Statut__c=Label.CTRL_StatutActif;
        ctrl39.Joint_non_joint__c = true;
        ctrl39.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl39);
        
        Controle__c ctrl40 = Test_Utils.createControle(acc9.id, Null, Null, req.id,System.today());   
        ctrl40.RecordTypeId = ControleMMPaMEId;
        ctrl40.Type_de_controle__c=Label.CTRL_Type_Participation;
        ctrl40.Sous_type_de_controle__c=Label.CTRL_SousType_TVOnPlus12h; 
        ctrl40.Statut__c=Label.CTRL_StatutActif;
        ctrl40.Joint_non_joint__c = true;
        ctrl40.Foyer_paneliste__c = foyerPaneliste.Id;   //MD
        listControleToInsert.add(ctrl40);
        
        System.debug('************');
        if(listControleToInsert!=null && listControleToInsert.size()>0) {
            insert listControleToInsert;
        }
        Test.setCreatedDate(ctrl551.Id, Date.newInstance(2024, 02, 05));
        update ctrl551;
        Test.setCreatedDate(ctrl552.Id, Date.newInstance(2024, 02, 04));
        update ctrl552;
        Test.setCreatedDate(ctrl553.Id, Date.newInstance(2024, 01, 02));
        update ctrl553;     
   
             
        //Create Etiquette
        list<Etiquette__c> listEtiquetteToInsert = new list<Etiquette__c>();
        Etiquette__c etq = Test_Utils.createEtiquette(acc.id,null,null,system.today(),system.today()+3);
        etq.Nom_de_l_etiquette__c=Label.ETI_Nom_de_l_etiquette_Ticket_Incident;
        listEtiquetteToInsert.add(etq);  
        insert listEtiquetteToInsert; 
        
        //Create Equipement
        list<asset> listEquipementsToInsert = new list<asset>();
        asset equipement1 = Test_Utils.createEquipement(acc4.Id);
        equipement1.name='tv1';
        equipement1.Audimetre__c = '2436EA';  //MD  
        listEquipementsToInsert.add(equipement1);
        
        asset equipement2 = Test_Utils.createEquipement(acc.Id);
        equipement2.name='tv2';
        equipement2.Audimetre__c = '2423EA';  //MD 
        listEquipementsToInsert.add(equipement2);
        
        asset equipement9 = Test_Utils.createEquipement(acc9.Id);
        equipement9.name='tv9';
        equipement9.Audimetre__c = '2427EA';  //MD 
        listEquipementsToInsert.add(equipement9);
        
        insert listEquipementsToInsert;
        
        //Create workOrder
        list<workOrder> listWorkOrderToInsert = new list<workOrder>();
        workOrder WO = Test_Utils.createWorkOrder(acc10.id); 
        WO.Status = Label.WOR_Status_En_cours;
        WO.Type_de_l_intervention__c=Label.WOR_Type_d_intervention_Installation;
        WO.AssetId  = equipement2.Id;
        WO.StartDate=system.today()-14;
        WO.EndDate=system.today()-12;
        WO.Tech_TestClass__c=true;
        listWorkOrderToInsert.add(WO); 
        
        workOrder WO1 = Test_Utils.createWorkOrder(acc8.id); 
        WO1.Status = Label.WOR_Status_En_cours;
        WO1.Type_de_l_intervention__c=Label.WOR_Type_d_intervention_Depannage_support;
        WO1.AssetId  = equipement2.Id;
        WO1.StartDate=system.today()+1;
        WO1.Tech_TestClass__c=true;
        WO1.EndDate=system.today()+10;
        listWorkOrderToInsert.add(WO1);
        
        workOrder WO2 = Test_Utils.createWorkOrder(acc9.id);
        WO2.Status = Label.WOR_Status_En_cours;
        WO2.Type_de_l_intervention__c=Label.WOR_Type_d_intervention_Depannage_support;
        WO2.Actions__c = Label.WOR_Sous_type_d_intervention_Controle_d_audience;
        WO2.AssetId  = equipement9.Id;
        WO2.StartDate=system.today()-5;
        WO2.EndDate=system.today()-1;
        WO2.Tech_TestClass__c=true;
        listWorkOrderToInsert.add(WO2);
        
        insert listWorkOrderToInsert;
        
        
        //Create ServiceAppointment
        list<serviceAppointment> listServiceAppointmentToInsert = new list<serviceAppointment>();
        serviceAppointment SA = Test_Utils.createSA(WO.id); 
        SA.SchedStartTime=system.today();
        SA.SchedendTime=system.today();
        listServiceAppointmentToInsert.add(SA); 
        
        serviceAppointment SA1 = Test_Utils.createSA(WO1.id); 
        SA1.SchedStartTime=system.today()+1;
        SA1.SchedendTime=system.today()+13;
        listServiceAppointmentToInsert.add(SA1);
        
        insert listServiceAppointmentToInsert;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont1.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont2.id));
        Batch002_PrecodageControle btch = new Batch002_PrecodageControle();
        database.executeBatch(btch);
        Test.stopTest();
         } 
    }
    
    public static testMethod void AP02_ControleTest(){
        
        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
         System.runAs(u){
        
        
        Id ControleAIPId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        
        
        //Create Jours Ferie
        list<Jour_ferie__c> listJourFerieToInsert = new list<Jour_ferie__c>();
        Jour_ferie__c JrsFerie = Test_Utils.createJourFerie(Date.today() - 1,'Fête 1');   
        listJourFerieToInsert.add(JrsFerie);  
        
        insert listJourFerieToInsert;
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account acc1 = Test_Utils.createFoyer();
        acc1.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc1); 
        
        account acc2 = Test_Utils.createFoyer(); 
        acc2.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc2); 
        
        account acc3 = Test_Utils.createFoyer(); 
        acc3.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc3); 
        
        account acc4 = Test_Utils.createFoyer(); 
        acc4.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc4);
        
        account acc5 = Test_Utils.createFoyer(); 
        acc5.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc5);
        
        account acc6 = Test_Utils.createFoyer(); 
        acc6.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc6);
        
        account acc7 = Test_Utils.createFoyer(); 
        acc7.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc7);
        
        account acc8 = Test_Utils.createFoyer(); 
        acc8.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc8);
        
        account acc9 = Test_Utils.createFoyer(); 
        acc9.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc9);
        
        account acc10 = Test_Utils.createFoyer();
        acc10.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc10);
        
        account acc11 = Test_Utils.createFoyer(); 
        acc11.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc11);
        
        account acc12 = Test_Utils.createFoyer(); 
        acc12.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc12);
        
        account acc13 = Test_Utils.createFoyer(); 
        acc13.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc13);
        
        account acc14 = Test_Utils.createFoyer(); 
        acc14.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc14);
        
        account acc15 = Test_Utils.createFoyer(); 
        acc15.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc15);
        
        account acc16 = Test_Utils.createFoyer(); 
        acc16.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc16);
        
        account acc17 = Test_Utils.createFoyer(); 
        acc17.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc17);
        
        account acc18 = Test_Utils.createFoyer(); 
        acc18.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc18);
        
        account acc19 = Test_Utils.createFoyer(); 
        acc19.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc19);
        
        account acc20 = Test_Utils.createFoyer(); 
        acc20.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(acc20);
        
        insert listFoyersToInsert;  
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        Foyer_paneliste__c foyerPaneliste5 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste5.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste5.Foyer__c = acc5.Id;
        foyerPaneliste5.Suspendu__c = true;
        foyerPaneliste5.Motif_de_suspension__c = Label.PAN_Motif_de_Suspension_EnAttenteDeChute;
        foyerPanelisteList.add(foyerPaneliste5);
        
        insert foyerPaneliste5;
        
        //Create Membre Foyer
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        Contact cont3 = Test_Utils.createMembreFoyer(acc3.id); 
        cont3.Birthdate=system.today().addyears(-5);
        cont3.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont3.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont3.Classification__c = Label.CON_Classification_Employe; 
        cont3.CSP4__c = '1';
        cont3.Code_profession__c = 1;
        listMembreFoyerToInsert.add(cont3);
        
        Contact cont6 = Test_Utils.createMembreFoyer(acc6.id); 
        cont6.Birthdate=system.today().addyears(-20); 
        cont6.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont6.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont6.Classification__c = Label.CON_Classification_Employe; 
        cont6.CSP4__c = '2';
        cont6.Code_profession__c = 1;
        listMembreFoyerToInsert.add(cont6); 
        
        Contact cont10 = Test_Utils.createMembreFoyer(acc10.id); 
        cont10.Birthdate=system.today().addyears(-10);
        cont10.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont10.Lien_parente__c = Label.CON_LienParente_ChefDeFamille; 
        cont10.Classification__c = Label.CON_Classification_Employe;
        cont10.CSP4__c = '3';
        cont10.Code_profession__c = 1;
        listMembreFoyerToInsert.add(cont10);
        
        Contact cont13 = Test_Utils.createMembreFoyer(acc13.id); 
        cont13.Birthdate=system.today().addyears(-20); 
        cont13.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont13.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont13.Classification__c = Label.CON_Classification_Employe;
        cont13.CSP4__c = '4';
        cont13.Code_profession__c = 1;
        listMembreFoyerToInsert.add(cont13);
        
        Contact cont14 = Test_Utils.createMembreFoyer(acc14.id); 
        cont14.Birthdate=system.today().addyears(-20); 
        cont14.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        cont14.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        cont14.Classification__c = Label.CON_Classification_Employe;
        cont14.CSP4__c = '1';
        cont14.Code_profession__c = 1;
        listMembreFoyerToInsert.add(cont14);
        
        
        insert listMembreFoyerToInsert;  
        
        //Create Controle
        List<Controle__c> listControleToInsert = new List<Controle__c>();
        Controle__c ctrl1 = Test_Utils.createControle(acc1.id, null, null, null, Date.today());  
        ctrl1.RecordTypeId = ControleAIPId;  
        ctrl1.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl1.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        ctrl1.Statut__c=Label.CTRL_StatutActif;
        
        listControleToInsert.add(ctrl1);
        
        Controle__c ctrl2 = Test_Utils.createControle(acc2.id, null, null, null, Date.today());   
        ctrl2.RecordTypeId = ControleAIPId; 
        ctrl2.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl2.Statut__c=Label.CTRL_StatutActif;
        ctrl2.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl2); 
        
        Controle__c ctrl3 = Test_Utils.createControle(acc3.id, cont3.Id, null, null, Date.today());  
        ctrl3.RecordTypeId = ControleAIPId;  
        ctrl3.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl3.Statut__c=Label.CTRL_StatutActif; 
        ctrl3.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl3); 
        
        Controle__c ctrl4 = Test_Utils.createControle(acc4.id, null, null, null, Date.today());  
        ctrl4.RecordTypeId = ControleAIPId;  
        ctrl4.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl4.Statut__c=Label.CTRL_StatutActif;
        ctrl4.Foyer_paneliste__c = foyerPaneliste5.Id;     //MD
        listControleToInsert.add(ctrl4); 
        
        Controle__c ctrl5 = Test_Utils.createControle(acc5.id, null, null, null, Date.today());  
        ctrl5.RecordTypeId = ControleAIPId;  
        ctrl5.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl5.Statut__c=Label.CTRL_StatutActif;
        ctrl5.Foyer_paneliste__c = foyerPaneliste5.Id;
        listControleToInsert.add(ctrl5); 
        
        Controle__c ctrl6 = Test_Utils.createControle(acc6.id, cont6.id, null, null, Date.today());  
        ctrl6.RecordTypeId = ControleAIPId;  
        ctrl6.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl6.Statut__c=Label.CTRL_StatutActif;
        ctrl6.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl6); 
        
        Controle__c ctrl7 = Test_Utils.createControle(acc7.id, null, null, null, Date.today());  
        ctrl7.RecordTypeId = ControleAIPId;  
        ctrl7.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl7.Statut__c=Label.CTRL_StatutActif;
        ctrl7.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl7); 
        
        Controle__c ctrl8 = Test_Utils.createControle(acc8.id, null, null, null, Date.today());  
        ctrl8.RecordTypeId = ControleAIPId;  
        ctrl8.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl8.Statut__c=Label.CTRL_StatutActif;
        ctrl8.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl8);
        
        Controle__c ctrl9 = Test_Utils.createControle(acc9.id, null, null, null, Date.today());  
        ctrl9.RecordTypeId = ControleAIPId;  
        ctrl9.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl9.Statut__c=Label.CTRL_StatutActif;
        ctrl9.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl9); 
        
        Controle__c ctrl10 = Test_Utils.createControle(acc10.id, cont10.id, null, null, Date.today());  
        ctrl10.RecordTypeId = ControleAIPId;  
        ctrl10.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl10.Statut__c=Label.CTRL_StatutActif;
        ctrl10.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl10);
        
        Controle__c ctrl11 = Test_Utils.createControle(acc11.id, null, null, null, Date.today());  
        ctrl11.RecordTypeId = ControleAIPId;  
        ctrl11.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl11.Statut__c=Label.CTRL_StatutActif; 
        ctrl11.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl11) ;
        
        Controle__c ctrl12 = Test_Utils.createControle(acc12.id, null, null, null, Date.today());  
        ctrl12.RecordTypeId = ControleAIPId;  
        ctrl12.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl12.Statut__c=Label.CTRL_StatutActif;
        ctrl12.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl12);
        
        Controle__c ctrl13 = Test_Utils.createControle(acc13.id, cont13.Id, null, null, Date.today());  
        ctrl13.RecordTypeId = ControleAIPId;  
        ctrl13.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl13.Statut__c=Label.CTRL_StatutActif;
        ctrl13.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl13);
        
        Controle__c ctrl14 = Test_Utils.createControle(acc14.id, cont14.Id, null, null, Date.today());  
        ctrl14.RecordTypeId = ControleAIPId;  
        ctrl14.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl14.Statut__c=Label.CTRL_StatutActif;
        ctrl14.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl14);
        
        Controle__c ctrl15 = Test_Utils.createControle(acc15.id, null, null, null, Date.today());  
        ctrl15.RecordTypeId = ControleAIPId;  
        ctrl15.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        ctrl15.Statut__c=Label.CTRL_StatutActif;
        ctrl15.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl15);  
        
        Controle__c ctrl16 = Test_Utils.createControle(acc16.id, null, null, null, Date.today());  
        ctrl16.RecordTypeId = ControleAIPId;  
        ctrl16.Type_de_controle__c = Label.CTRL_Type_NonRepondant;
        ctrl16.Statut__c = Label.CTRL_Statut_Traite;
        ctrl16.Foyer_paneliste__c = foyerPaneliste5.Id;   //MD
        listControleToInsert.add(ctrl16);         
        
        Controle__c ctrl17 = Test_Utils.createControle(acc17.id, null, null, null, Date.today() - 1);  
        ctrl17.RecordTypeId = ControleAIPId;  
        ctrl17.Type_de_controle__c = Label.CTRL_Type_NonRepondant;
        ctrl17.Statut__c = Label.CTRL_StatutActif;
        ctrl17.Foyer_paneliste__c = foyerpaneliste5.Id;   //MD
        listControleToInsert.add(ctrl17);
        
        insert listControleToInsert;
        
        Test.setCreatedDate(ctrl17.Id, Date.today() - 1);
        
        List<Controle__c> precontroleList = [SELECT id, createdDate FROM Controle__c];
        
        for (Controle__c controle: precontroleList) {
            System.debug('controle: ' + controle);
        }
        
        System.debug('precontroleList: ' + precontroleList);
        
        //Create Composition du foyer
        List<Conge__c> congeList = new List<Conge__c>();
        Conge__c conge6 = Test_Utils.createConge(acc6.Id, cont6.Id);
        conge6.Date_de_debut__c = System.today();
        conge6.Date_de_fin__c= System.today()+4;
        conge6.Vacances_hors_France__c = true;
        congeList.add(conge6);
        
        insert congeList;
        
        //Create Etiquette
        list<Etiquette__c> listEtiquetteToInsert = new list<Etiquette__c>();
        
        Etiquette__c etq8 = Test_Utils.createEtiquette(acc8.id, null, null, system.today(), system.today() + 10);
        etq8.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Mauvaise_Reception;
        listEtiquetteToInsert.add(etq8);
        
        Etiquette__c etq9 = Test_Utils.createEtiquette(acc9.id, null, null, system.today(), system.today() + 10);
        etq9.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Mouvement_Atypique;
        listEtiquetteToInsert.add(etq9);
        
        Etiquette__c etq10 = Test_Utils.createEtiquette(acc10.id, null, null, system.today(), system.today() + 10);
        etq10.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Foyer_temoin;
        listEtiquetteToInsert.add(etq10);
        
        Etiquette__c etq11 = Test_Utils.createEtiquette(acc11.id, null, null, system.today(), system.today() + 10);
        etq11.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Peu_Ecoute_Casque;
        listEtiquetteToInsert.add(etq11);
        
        Etiquette__c etq12 = Test_Utils.createEtiquette(acc12.id, null, null, system.today(), system.today() + 10);
        etq12.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Raisons_Personnelles;
        listEtiquetteToInsert.add(etq12);
        
        Etiquette__c etq13 = Test_Utils.createEtiquette(acc13.id, null, null, system.today(), system.today() + 10);
        etq13.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Refus_Temporaire_De_Participation;
        listEtiquetteToInsert.add(etq13);
        
        Etiquette__c etq15 = Test_Utils.createEtiquette(acc15.id, null, null, system.today(), system.today() + 10);
        etq15.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Profession_Atypique;
        listEtiquetteToInsert.add(etq15);
        
        insert listEtiquetteToInsert; 
        
        List<Task> taskToInsert = new List<Task>();
        Task task4 = Test_Utils.createTask();
        task4.WhatId = acc4.Id;
        task4.Subject = Label.TSK_Objet_Call;
        task4.CallDurationInSeconds = 1437;
        task4.Status = Label.TSK_Statut_Completed;
        task4.ActivityDate= Date.today() + 15;
        task4.CallStartTime__c = Date.today() - 1;
        taskToInsert.add(task4);
        
        Task task14 = Test_Utils.createTask();
        task14.WhatId = acc14.Id;
        task14.Subject = Label.TSK_Objet_Call;
        task14.Status = Label.TSK_Statut_Open;
        task14.ActivityDate= Date.today() + 15;
        task14.CallStartTime__c = Date.today() + 2;
        taskToInsert.add(task14);
        
        insert taskToInsert;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont3.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont6.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont10.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont13.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont14.id));
        Batch002_PrecodageControle bccfb = new Batch002_PrecodageControle();
        Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<Controle__c> controleList = [SELECT id, Libelle_de_pre_codage__c, Statut__c FROM Controle__c];
        
        for (Controle__c controle: controleList) {
            if(controle.Id == ctrl2.Id) {
                //System.assertEquals(null, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_StatutActif, controle.Statut__c);                
            }
            else if(controle.Id == ctrl3.Id) {
                System.assertEquals(null, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_StatutActif, controle.Statut__c);                
            }
            else if(controle.Id == ctrl4.Id) {
               // System.assertEquals(Label.CTRL_LibellePrecodage_Appel_Hier, controle.Libelle_de_pre_codage__c);
                //System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl5.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_FoyerSuspendu, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl6.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Hors_France, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl8.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Mauvaise_Reception, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl9.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Mouvement_Atypique, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl10.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Foyer_Temoin, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl11.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Peu_Ecoute_Casque, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl12.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Raisons_Personnelles, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl13.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Refus_Temporaire_De_Participation, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl14.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_RDV, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl15.Id) {
                System.assertEquals(Label.CTRL_LibellePrecodage_Profession_Atypique, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Precode, controle.Statut__c);                
            }
            else if(controle.Id == ctrl16.Id) {
                System.assertEquals(null, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_Statut_Traite, controle.Statut__c);                
            }
            else if(controle.Id == ctrl17.Id) {
                System.assertEquals(null, controle.Libelle_de_pre_codage__c);
                System.assertEquals(Label.CTRL_StatutActif, controle.Statut__c);                
            }
        }
        
        
    }
  }
    
}