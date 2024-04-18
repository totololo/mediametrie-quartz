@isTest
public class AP01_UpdatescheduledDate_Test {
    public static testMethod void Batch008_SMSviaNP6Test(){
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
        SM.City='Abscon';
        SM.Country='France';
        SM.postalCode='59215'; 
        SM.ServiceTerritoryId=ST.Id;
        SM.EffectiveStartDate=system.today();
        listeSM.add(SM);
        insert listeSM;
        
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.ShippingCity = 'HARBONNIERES';
        testAccount.ShippingCountry= 'FRANCE';
        testAccount.ShippingpostalCode = '80131';
        testAccount.ShippingStreet= '44 RUE DE BETHISY';
        testAccount.Numero_de_portable__c = '1111111111';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
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
        
        list<asset> listEquipement = new list<asset>();
        asset equipement1 = Test_Utils.createEquipement(testAccount.Id);
        listEquipement.add(equipement1);
        insert listEquipement;
        
        list<workOrder> listInterventions = new list<workOrder>();
        workOrder intervention1 = Test_Utils.createWorkOrder(testAccount.Id);
        intervention1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention1.AssetId = equipement1.Id;
        intervention1.Foyer_paneliste__c = foyerPaneliste.Id;
        intervention1.tech_testClass__c = true;
        insert intervention1;
        //listInterventions.add(intervention1);
        //insert listInterventions;
        
        list<serviceAppointment> listRendezVous = new list<serviceAppointment>();
        serviceAppointment rendezVous1 = Test_Utils.createSA(intervention1.id);
        rendezVous1.ContactId=membreDuFoyer1.id;
        rendezVous1.SchedStartTime = date.today() + 1;
        rendezVous1.SchedEndTime = date.today() + 2;
        rendezVous1.ServiceTerritoryId=ST.id;
        rendezVous1.Status = Label.RDV_Statut_Dispatche;
        listRendezVous.add(rendezVous1);
        insert listRendezVous; 
        AssignedResource ar = new AssignedResource(ServiceAppointmentId=rendezVous1.Id,ServiceResourceId=objServiceResource.Id);
        ar.EstimatedTravelTime=35;
        toInsert.add(ar);
        
        insert toInsert;
        
        test.startTest();
        AP01_UpdatescheduledDate.updateSAScheduleDates(toInsert);
        test.stopTest();
        
    }
}