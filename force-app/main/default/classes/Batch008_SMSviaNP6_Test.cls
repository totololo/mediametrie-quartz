/*
* @author: Khaled Hammoudeh
* @date: 5/10/2020
* @ Description Class that test Batch008_SMSviaNP6  
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
@isTest
public class Batch008_SMSviaNP6_Test {
    public static testMethod void Batch008_SMSviaNP6Test(){
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        testAccount.Statut_audimetrique__c = Label.ACC_StatutAudimetrique_Present;
        testAccount.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        testAccount.Numero_de_portable__c = '1111111111';
        testAccount.Intervention_en_cours__c = false;
        listFoyersToInsert.add(testAccount); 
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
        Insert foyerPaneliste;
        
        
        //create contact
        list<contact> listMembreDuFoyer = new list<contact>();
        contact membreDuFoyer1 = Test_Utils.createMembreFoyer(testAccount.Id);
        membreDuFoyer1.Email = 'test@tes1.co';
        membreDuFoyer1.MobilePhone = '0687457220';
        membreDuFoyer1.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        membreDuFoyer1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        membreDuFoyer1.Classification__c = 'Ouvrier non qualifié';
        membreDuFoyer1.Code_profession__c = 35;
        listMembreDuFoyer.add(membreDuFoyer1);
        insert listMembreDuFoyer;
        
        //cretae asset
        list<asset> listEquipement = new list<asset>();
        asset equipement1 = Test_Utils.createEquipement(testAccount.Id);
        listEquipement.add(equipement1);
        insert listEquipement;
        testAccount.Intervention_en_cours__c = false;
        update testAccount;
        
        // create wo
        list<workOrder> listInterventions = new list<workOrder>();
        workOrder intervention1 = Test_Utils.createWorkOrder(testAccount.Id);
        intervention1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention1.AssetId = equipement1.Id;
        intervention1.Foyer_paneliste__c=foyerPaneliste.id;
        intervention1.Tech_TestClass__c=true;
        insert intervention1;
        //listInterventions.add(intervention1);
        //insert listInterventions;
       
        //create rdv
        list<serviceAppointment> listRendezVous = new list<serviceAppointment>();
        serviceAppointment rendezVous1 = Test_Utils.createSA(intervention1.id);
        rendezVous1.ContactId=membreDuFoyer1.id;
        rendezVous1.SchedStartTime = date.today() + 1;
        rendezVous1.SchedEndTime = date.today() + 2;
        rendezVous1.Status = System.Label.RDV_Statut_Dispatche;//Label.RDV_Statut_Dispatche
        listRendezVous.add(rendezVous1);
        insert listRendezVous; 
        
		//test
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SendSMSCallout_Mock());
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
		MembreFoyerCallout_Mock fakeGETAssets = new MembreFoyerCallout_Mock('ee');
        Test.setMock(HttpCalloutMock.class, fakeGETAssets); 
        Batch008_SMSviaNP6  btch = new Batch008_SMSviaNP6 ();
        //AP01_SendSMS.sendSMSViaNP6(listRendezVous);
        database.executeBatch(btch);
        Test.stopTest();
    }
}