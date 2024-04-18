/*
* @Auteur : Téoman Sertçelik
* @date: 17/03/2022
* @Classe:  Batch018_FoyerAnonymisation
* @Coverage: 98%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
08/04/2022                      Téoman Sertçelik    Fix : test to pass following realized apex triggers validation on insert 
Commented line 106:  //equipFoyer1.Utilisateur_principal__c  = ctToAno.Id;
*/

@isTest
public with sharing class Batch018_FoyerAnonymisation_Test {
    
    @isTest
    public static void testAno() {
        
        Id recordTypeIdControleAIP = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdRequeteControle = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();
        Id recordTypeIdEquipementFoyer = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        Id recordTypeIdFidelisationCredit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer;AP01_IndividuPaneliste';
        update u;
        
        System.runAs(u){
            
            Account acc1 = new Account();
            acc1.Name = 'Foyer1';
            acc1.ShippingPostalCode = '98222';
            acc1.ShippingState = 'France';
            acc1.ShippingCountry = 'PHUKET';
            acc1.ShippingStreet = 'toto';
            acc1.ShippingCity = 'paname';
            insert acc1; 
            
            Contact ctToAno = new Contact();
            ctToAno.A_anonymiser__c = true;
            ctToAno.Date_d_anonymisation__c = null;
            ctToAno.FirstName = 'firstNameAno';
            ctToAno.LastName = 'lastNameAno';
            ctToAno.AccountId = acc1.Id;
            ctToAno.Lien_de_parente_stat__c = '2'; 
            ctToAno.Type__c = '1';
            ctToAno.Birthdate = system.today();
            ctToAno.Lien_parente__c = '3';
            ctToAno.CSP42__c = '1';
            ctToAno.CSP4__c = '2';
            insert ctToAno;
            
            Referentiel_Panel__c refPan = new Referentiel_Panel__c();
            refPan.Name	= Label.RFP_Nom_AIP;
            refPan.Type_de_panel__c =  Label.RFP_TypePanel_AIP;
            insert refPan;            
            
            Foyer_paneliste__c fp1 = new Foyer_paneliste__c();
            fp1.Foyer__c = acc1.Id;
            fp1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
            fp1.Membre_du_foyer__c = ctToAno.Id;
            fp1.Referentiel_Panel__c = refPan.Id;
            //fp1.Panel_de_reference__c = refPan.Id;
            fp1.Name = 'FoyerPan1';
            fp1.Demande_d_anonymisation__c = true;
            fp1.Date_d_anonymisation__c = null;
            fp1.A_anonymiser__c = true;
            fp1.Tech_FP_Anonym_SF__c= False;
            fp1.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Chute_definitive;
            fp1.Date_de_chute_temporaire__c = date.newInstance(2021, 02, 27);
            fp1.Date_de_chute__c = date.newInstance(2021, 02, 28);
            insert fp1;
            
            Controle__c ctrl = new Controle__c();
            ctrl.RecordTypeId = recordTypeIdControleAIP;
            ctrl.Foyer__c = acc1.Id;
            ctrl.Foyer_paneliste__c = fp1.Id; 
            ctrl.Name = 'ctrl1';
            ctrl.Statut__c = Label.CTRL_Statut_Actif;
            insert ctrl;
            
            Asset ass = new Asset();
            ass.RecordTypeId = recordTypeIdEquipementDeMesureAIP; 
            ass.Name = 'ass1';
            ass.Reference_produit__c = 'ROA01V1';
            ass.AccountId = acc1.Id;
            ass.Foyer_paneliste__c = fp1.Id;
            insert ass;
            
            WorkType typeTravail = new WorkType();
            typeTravail.name = Label.TYP_Name_TypeParDefaut;
            typeTravail.EstimatedDuration = 10.00;
            insert typeTravail;
            
            WorkOrder wrkO = new WorkOrder();
            wrkO.AssetId = ass.Id;
            wrkO.AccountId = acc1.Id;
            wrkO.Foyer_paneliste__c	= fp1.Id;
            wrkO.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
            wrkO.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
            wrkO.WorkTypeId = typeTravail.Id;
            insert wrkO;
            
            Case cs  = new Case();
            cs.RecordTypeId = recordTypeIdRequeteControle;
            cs.ContactId = ctToAno.Id;
            cs.Origin = 'Appel Entrant';
            cs.AccountId = acc1.Id;
            cs.Foyer_paneliste__c = fp1.Id;
            cs.Date_d_anonymisation__c = null;
            insert cs;
            
            
            Equipements_du_foyer__c equipFoyer1 = new Equipements_du_foyer__c();
            equipFoyer1.RecordTypeId = recordTypeIdEquipementFoyer;
            //equipFoyer1.Utilisateur_principal__c  = ctToAno.Id;
            equipFoyer1.Foyer_paneliste__c = fp1.Id;
            equipFoyer1.Name = 'equipmt1';
            equipFoyer1.Date_d_anonymisation__c = null; 
            insert equipFoyer1;
            
            Individu_Paneliste__c ind1 = new Individu_Paneliste__c();
            ind1.Foyer_paneliste__c = fp1.Id;
            ind1.Composition_du_foyer__c = ctToAno.Id;
            ind1.Lettre__c = 'F';
            ind1.Date_d_anonymisation__c = null;
            insert ind1; 
            
            Fidelisation__c fid  = new Fidelisation__c(); 
            fid.RecordTypeId = recordTypeIdFidelisationCredit;
            fid.Foyer_paneliste__c = fp1.Id;
            fid.Individu_paneliste__c = ind1.Id;
            fid.Foyer__c = acc1.Id;
            fid.Composition_du_foyer__c = ctToAno.Id;
            fid.Motif_de_credit__c='1';
            fid.Type_de_mouvement__c = '6';
            insert fid;
            
            ServiceAppointment srv = new ServiceAppointment();
            srv.Foyer_paneliste__c = fp1.Id;
            srv.ContactId = ctToAno.Id;
            //srv.AccountId = acc1.Id;
            srv.ParentRecordId = wrkO.Id; 
            //srv.Date_d_anonymisation__c = null;
            //srv.Intervention__c = wrkO.Id;
            srv.EarliestStartTime = system.today();
            srv.DueDate = system.today();
            srv.Duration = 1;
            srv.Status = 'À planifier';
            insert srv;
            
            Order ordr = new Order(); 
            ordr.Foyer_paneliste__c = fp1.Id;
            ordr.AccountId = acc1.Id;
            ordr.Status = '1';
            ordr.EffectiveDate = system.today();
            insert ordr;
            MembreFoyerCallout_Mock fakeSendCont = new MembreFoyerCallout_Mock(ctToAno.Id);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, fakeSendCont);
            Batch018_FoyerAnonymisation ano = new Batch018_FoyerAnonymisation();
            Id batchId = Database.executeBatch(ano);
            Test.stopTest();
            
            List<Account> testAccount = [select id , Date_d_anonymisation__c from Account where Date_d_anonymisation__c != null];
            System.assertEquals(1, testAccount.size() ); 
            List<Foyer_paneliste__c> testFoyerPan = [select id , Date_d_anonymisation__c from Foyer_paneliste__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testFoyerPan.size() ); 
            List<Controle__c> testControle = [select id , Date_d_anonymisation__c from Controle__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testControle.size() ); 
            List<WorkOrder> testWorkOrdr = [select id , Date_d_anonymisation__c from WorkOrder where Date_d_anonymisation__c != null];
            System.assertEquals(1, testWorkOrdr.size() ); 
            List<Case> testCase = [select id , Date_d_anonymisation__c from Case where Date_d_anonymisation__c != null];
            System.assertEquals(1, testCase.size() ); 
            List<Equipements_du_foyer__c> testEqmtFoyer = [select id , Date_d_anonymisation__c from Equipements_du_foyer__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testEqmtFoyer.size() ); 
            List<Fidelisation__c> testFidelisation = [select id , Date_d_anonymisation__c from Fidelisation__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testFidelisation.size() );
            List<ServiceAppointment> testServiceAppt =  [select id , Date_d_anonymisation__c from ServiceAppointment where Date_d_anonymisation__c != null];
            System.assertEquals(1, testServiceAppt.size() );
            List<Order> testOrdr =  [select id , Date_d_anonymisation__c from Order where Date_d_anonymisation__c != null];
            System.assertEquals(1, testOrdr.size() );
        }
    }
}