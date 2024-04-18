/*
* @author: Khaled Hammoudeh
* @date: 30/10/2020
* @ Description Class that tests AP01_SendSMS
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
@istest
public class AP01_SendSMS_Test {
    
    public static testMethod void testSendSMS(){
         
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
         u.Bypass_flows__c = true;
         u.Bypass_triggers__c = 'AP01_IndividuPaneliste';
         update u;
        
        System.runAs(u){
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        testAccount.Statut_audimetrique__c = Label.ACC_StatutAudimetrique_Present;
        testAccount.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        testAccount.Numero_de_portable__c = '1111111111';
        testAccount.Intervention_en_cours__c = false;
        
        listFoyersToInsert.add(testAccount); 
        
        account testAccount2 = Test_Utils.createFoyer();
        testAccount2.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        testAccount2.Statut_audimetrique__c = Label.ACC_StatutAudimetrique_Present;
        testAccount2.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        testAccount2.Numero_de_portable__c = '0987365417';
        testAccount2.Adresse_e_mail_principale__c=null;
        testAccount2.Intervention_en_cours__c = false;
                

        listFoyersToInsert.add(testAccount2); 
        insert listFoyersToInsert;
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.name = Label.RFP_Nom_PaME;
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.foyer__c = testAccount.Id;
        foyerPaneliste.name = 'FOyer Pan';
        foyerPaneliste.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste.Intervention_en_cours__c = false;
        foyerPaneliste.Foyer_Paneliste_ExtId_SIPanel__c='ijoijnjn';
        Insert foyerPaneliste;
        
        Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
        foyerPaneliste2.foyer__c = testAccount2.Id;
        foyerPaneliste2.name = 'FOyer Pan2';
        foyerPaneliste2.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste2.Intervention_en_cours__c = false;
        foyerPaneliste2.Foyer_Paneliste_ExtId_SIPanel__c='ijoadaijnjn';
        Insert foyerPaneliste2;
        
        list<contact> listMembreDuFoyer = new list<contact>();
        contact membreDuFoyer1 = Test_Utils.createMembreFoyer(testAccount.Id);
        membreDuFoyer1.Email = 'test@tes1.com';
        membreDuFoyer1.MobilePhone = '0687457220';
        membreDuFoyer1.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        membreDuFoyer1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        membreDuFoyer1.Classification__c = 'Ouvrier non qualifié';
        membreDuFoyer1.Code_profession__c = 35;
        membreDuFoyer1.Nombre_d_heures_travaillees__c=3;
        membreDuFoyer1.Type__c='0';
        
        contact membreDuFoyer2 = Test_Utils.createMembreFoyer(testAccount2.Id);
        
        membreDuFoyer2.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        membreDuFoyer2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        membreDuFoyer2.Classification__c = 'Ouvrier non qualifié';
        membreDuFoyer2.Code_profession__c = 34;
        membreDuFoyer2.Nombre_d_heures_travaillees__c=2;
        membreDuFoyer2.Type__c='0';
        listMembreDuFoyer.add(membreDuFoyer2);
        insert listMembreDuFoyer;
        
        list<asset> listEquipement = new list<asset>();
        asset equipement1 = Test_Utils.createEquipement(testAccount.Id);
        equipement1.Audimetre__c = '214365';
        listEquipement.add(equipement1);
        
        asset equipement2 = Test_Utils.createEquipement(testAccount2.Id);
        equipement2.Audimetre__c = '658709';
        listEquipement.add(equipement2);
        
        insert listEquipement;
        
        testAccount.Intervention_en_cours__c = false;
        update testAccount;
       
        list<workOrder> listInterventions = new list<workOrder>();
        workOrder intervention1 = Test_Utils.createWorkOrder(testAccount.Id);
        intervention1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention1.Actions__c='1';
        intervention1.Foyer_paneliste__c=foyerPaneliste.id;
        intervention1.AssetId = equipement1.Id;
        intervention1.Tech_TestClass__c=true;
        insert intervention1;
         testAccount2.Intervention_en_cours__c = false;
        update testAccount;
        workOrder intervention2 = Test_Utils.createWorkOrder(testAccount2.Id);
        intervention2.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention2.Actions__c='1';
        intervention2.Tech_TestClass__c=true;
        intervention2.Foyer_paneliste__c=foyerPaneliste2.id;
        intervention2.AssetId = equipement2.Id;
        
        insert intervention2;
        
        //listInterventions.add(intervention1);
        //insert listInterventions;
        
        list<serviceAppointment> listRendezVous = new list<serviceAppointment>();
        serviceAppointment rendezVous1 = Test_Utils.createSA(intervention1.id);
        rendezVous1.SchedStartTime = date.today() + 1;
        rendezVous1.SchedEndTime = date.today() + 2;
        rendezVous1.Status = Label.RDV_Statut_Planifie;
        rendezVous1.ContactId=membreDuFoyer1.id;
        listRendezVous.add(rendezVous1);
        
        serviceAppointment rendezVous2 = Test_Utils.createSA(intervention2.id);
        rendezVous2.SchedStartTime = date.today() + 1;
        rendezVous2.SchedEndTime = date.today() + 3;
        rendezVous2.Status = Label.RDV_Statut_Dispatche;
        rendezVous2.Contact=membreDuFoyer2;
        listRendezVous.add(rendezVous2);
        insert listRendezVous;
       	rendezVous2.Contact.MobilePhone='0612909872';
        rendezVous2.Contact.Email='test@gmail.com';
        update rendezVous2;
        //To pass deployment
        Conge__c conge = Test_Utils.createConge(testAccount.Id, membreDuFoyer1.Id);
        Case case1 = Test_Utils.createCase(testAccount.Id);
        case1.Foyer_paneliste__c=foyerPaneliste.id;
                System.debug('Bastien case1 foyerPaneliste : ' + foyerPaneliste.foyer__c);
                System.debug('Bastien case1 AccountId : ' + case1.AccountId);

        insert case1;
        Etiquettes_et_controles__c etc = Test_Utils.createEtqCtrl();
        Evenement__c evenement = Test_Utils.createEvenement(equipement1.Id);
        Test_Utils.createEtiquette(testAccount.Id, membreDuFoyer1.Id, equipement1.Id, Date.today(), Date.today() + 6);
        Test_Utils.createControle(testAccount.Id, membreDuFoyer1.Id, equipement1.Id, case1.Id, Date.today());

        Conge__c conge2 = Test_Utils.createConge(testAccount2.Id, membreDuFoyer2.Id);
        Case case2 = Test_Utils.createCase(testAccount2.Id);
         case2.Foyer_paneliste__c=foyerPaneliste2.id;
                System.debug('Bastien case2 foyerPaneliste : ' + foyerPaneliste2.foyer__c);
                System.debug('Bastien case2 AccountId : ' + case2.AccountId);

        insert case2;
        
        List<Case> qsvz = [
            select  id, AccountId, Foyer_paneliste__r.Foyer__c from Case
        ];
                System.debug('Bastien qsvz : ' + qsvz[0].Foyer_paneliste__r.Foyer__c);
                System.debug('Bastien qsvz : ' + qsvz[0].AccountId);
        
                 System.debug('Bastien qsvz : ' + qsvz[1].Foyer_paneliste__r.Foyer__c);
                System.debug('Bastien qsvz : ' + qsvz[1].AccountId);
        List<Account> qsvdrydryz = [
            select  id, Name  from Account
        ];
                System.debug('Bastien qsvdrydryz : ' + qsvdrydryz);
        
        Etiquettes_et_controles__c etc2 = Test_Utils.createEtqCtrl();
        Evenement__c evenement2 = Test_Utils.createEvenement(equipement2.Id);
        Test_Utils.createEtiquette(testAccount2.Id, membreDuFoyer2.Id, equipement2.Id, Date.today(), Date.today() + 6);
        Test_Utils.createControle(testAccount2.Id, membreDuFoyer2.Id, equipement2.Id, case2.Id, Date.today());
        
        Test.startTest(); 
        SmsNp6_Manager.SendMessage(null, null, null); 
        Test.setMock(HttpCalloutMock.class, new SendSMSCallout_Mock());  
        SmsNp6_Manager.GetallFields();  
        SmsNp6_Manager.recipient testWrap2=new SmsNp6_Manager.recipient(); 
        testWrap2.value='test';
        testWrap2.id='1221';
        SmsNp6_Manager.copies testWrap1=new SmsNp6_Manager.copies(); 
        testWrap1.value='test2';
        testWrap1.id='12212';
        SmsNp6_Manager.attachments testWrap3=new SmsNp6_Manager.attachments(); 
        testWrap3.name='test3';
        testWrap3.mime='12212';
        SmsNp6_Manager.content testWrap4=new SmsNp6_Manager.content(); 
        testWrap4.type='test3';
        testWrap4.html='12212';
        testWrap4.text='test4';
        testWrap4.amp='000';
        SmsNp6_Manager.dataStr testWrap5=new SmsNp6_Manager.dataStr(); 
        testWrap5.myvar='test3';
        testWrap5.myproduct='12212';
        AP01_SendSMS.sendSMSViaNP6(listRendezVous);
        Test.stopTest();
            
        }
    }
}