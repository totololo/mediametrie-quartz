@isTest
public class AP06_ResourceAbsence_Test {
	public static testMethod void AP06_ResourceAbsencetest(){
           
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account acc = Test_Utils.createFoyer();
        acc.Name='test';
        listFoyersToInsert.add(acc); 
		insert listFoyersToInsert;  
        
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.name = Label.RFP_Nom_PaME;
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.foyer__c = acc.Id;
        foyerPaneliste.name = 'FOyer Pan';
        foyerPaneliste.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste.Intervention_en_cours__c = false;
        Insert foyerPaneliste;
        
        //creation service ressource
        ServiceResource sr=new ServiceResource();
        sr.Name='Test Resource';
        sr.RelatedRecordId=UserInfo.getUserId();
        sr.ResourceType='T';
        sr.IsActive=True;
        sr.Description='description';
        sr.Numero_de_station__c=1;
        insert sr;  
        
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
        SM.ServiceResourceId=sr.Id;
        SM.TerritoryType='P';
        SM.ServiceTerritoryId=ST.Id;
        SM.EffectiveStartDate=system.today();
        listeSM.add(SM);
        insert listeSM;
        
        //Create workOrder
        	//List<WorkOrder> w = [SELECT id from WorkOrder];
        	workorder wo = new workorder ();
        	wo.AccountId=acc.id;
        	WO.Tech_TestClass__c=true;
        WO.Foyer_paneliste__c=foyerPaneliste.id;
        insert wo;
        	id workorderid=wo.id;
        	
         //create ServiceAppointment
       
         list<serviceAppointment> listServiceAppointmentToInsert = new list<serviceAppointment>();
         serviceAppointment SA = Test_Utils.createSA(workorderid); 
        
         SA.EarliestStartTime=system.today();
         SA.DueDate=system.today()+1;
         SA.Status=' planifié';
         SA.SchedStartTime=system.today();
         SA.SchedendTime=system.today()+1;
         listServiceAppointmentToInsert.add(SA); 
         insert listServiceAppointmentToInsert;
         //insert SA;
   
        //create assigned ressource
        AssignedResource ar = new AssignedResource();
        ar.ServiceResourceId=sr.Id;
        ar.ServiceAppointmentId=SA.Id;
        insert ar;
        
      // create absence
      list<ResourceAbsence> listeab = new list<ResourceAbsence>();
      ResourceAbsence ab = new ResourceAbsence();
      ab.Start=system.today()+2; 
      ab.End=system.today()+3;
      ab.ResourceId=sr.Id;
      listeab.add(ab);
      insert listeab;
     Test.startTest();
     Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock('rr'));
     TEST.stopTest();
    }
    
}