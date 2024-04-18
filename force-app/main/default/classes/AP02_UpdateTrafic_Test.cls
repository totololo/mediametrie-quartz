@isTest
public class AP02_UpdateTrafic_Test {
    public static testMethod void AP02_UpdateTrafic_Test(){
        user u = new user ();
        u.id = UserInfo.getUserId();
        List<AssignedResource> toInsert = new List<AssignedResource>();
        ServiceResource objServiceResource=new ServiceResource();
        objServiceResource.Name='Test Resource';
        objServiceResource.RelatedRecordId= UserInfo.getUserId();
        objServiceResource.ResourceType='T';
        objServiceResource.IsActive=True; 
        objServiceResource.Numero_de_station__c=1234 ;
        insert objServiceResource;   
        
        //operating hours
        list<OperatingHours> listeoh = new list<OperatingHours>();
        OperatingHours oh = new OperatingHours();        
        oh.Name = 'TestOH';
        listeoh.add(oh);
        insert listeoh;
        
        //Create Territoire
        List<ServiceTerritory> ListeST = new List<ServiceTerritory>();
        ServiceTerritory ST = new ServiceTerritory();
        ST.Name = 'test terr';
        ST.OperatingHoursId=oh.Id;
        ST.IsActive=true;
        ListeST.add(ST);
        insert ListeST;     
        
        //membre territoire
        list<ServiceTerritoryMember> listeSM = new list<ServiceTerritoryMember>();
        ServiceTerritoryMember SM = new ServiceTerritoryMember();
        SM.ServiceResourceId=objServiceResource.Id;
        SM.TerritoryType='P';
        SM.City='Paris';
        SM.Country='France';
        SM.postalCode='75012';
        SM.street = 'Place de la Nation';
        SM.ServiceTerritoryId=ST.Id;
        SM.EffectiveStartDate=system.today();
        listeSM.add(SM);
        insert listeSM;
        
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        //testAccount.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        testAccount.Statut_audimetrique__c = Label.ACC_StatutAudimetrique_Present;
        testAccount.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        testAccount.ShippingCity = 'PARIS 17E ARRONDISSEMENT';
        testAccount.ShippingCountry= 'FRANCE';
        testAccount.ShippingpostalCode = '75017';
        testAccount.ShippingStreet= '10 RUE BROCHANT';
        testAccount.Numero_de_portable__c = '1111111111';
        testAccount.Intervention_en_cours__c = false;
        listFoyersToInsert.add(testAccount); 
        insert listFoyersToInsert;
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.Type_de_panel__c = Label.RFP_Nom_PaME;
        refPanPaME.Name	= Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPan = new Foyer_Paneliste__c();
        foyerPan.Referentiel_Panel__c = refPanPaME.Id;
        foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel;
        foyerPan.name = 'TestAP01_Contact';
        foyerPan.Foyer__c = testAccount.Id;
        foyerPan.Foyer_Paneliste_ExtId_SIPanel__c = 'AZE34';
        foyerPanelisteToInsert.add(foyerPan);
        Insert foyerPanelisteToInsert;
        
        WorkType workType = new WorkType();
        workType.name = Label.TYP_Name_TypeParDefaut;
        workType.EstimatedDuration = 0;
        insert worktype;
              
        workOrder intervention1 = Test_Utils.createWorkOrder(testAccount.Id);
        intervention1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention1.foyer_paneliste__c = foyerPan.Id;
        intervention1.Actions__c = Label.WOR_Sous_type_d_intervention_Nouveau_foyer;
        insert intervention1;
        
        
        list<serviceAppointment> listRendezVous = new list<serviceAppointment>();
        serviceAppointment rendezVous1 = Test_Utils.createSA(intervention1.id);
        //rendezVous1.ContactId=membreDuFoyer1.id;
        //rendezVous1.SchedStartTime = date.today() + 1;
        rendezVous1.SchedStartTime = DateTime.newInstance(date.today().year(), date.today().month(), date.today().day()+1, 9,0,0);
        //rendezVous1.SchedEndTime = date.today() + 2;
        rendezVous1.SchedEndTime  = DateTime.newInstance(date.today().year(), date.today().month(), date.today().day()+1, 9,50,0);      
        rendezVous1.ServiceTerritoryId=ST.id;
       	rendezVous1.Tech_StatutSA__c=true;
        rendezVous1.Status = Label.RDV_Statut_Dispatche;
        listRendezVous.add(rendezVous1);
        insert listRendezVous; 
        System.debug('test'+rendezVous1.Id);
        AssignedResource ar = new AssignedResource(ServiceAppointmentId=rendezVous1.Id,ServiceResourceId=objServiceResource.Id);
        ar.EstimatedTravelTime=32;
        toInsert.add(ar);
        
        
		// create trafic ajouté
		Trafic_Added__c trafic = new Trafic_Added__c() ;
        trafic.Arriving_Time__c = 'Entre 9 et 10 H';
        trafic.Arriving_Department__c = '75';
        trafic.Added_Percentage__c = decimal.valueOf('40');
        insert trafic;
        

        insert toInsert; 
        /*
        serviceAppointment serviceToTest = [SELECT Id, SchedStartTime,SchedEndTime, Trafic_Additionnel__c FROM serviceAppointment WHERE Id =: rendezVous1.Id];
		System.assertEquals(9, serviceToTest.SchedStartTime.hour());
        System.assertEquals(40, serviceToTest.SchedStartTime.minute());
        */
    }
}