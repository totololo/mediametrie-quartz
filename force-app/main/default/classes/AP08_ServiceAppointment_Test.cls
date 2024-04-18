@isTest
public class AP08_ServiceAppointment_Test {
	
   public static testMethod void AP08_ServiceAppointment_Test(){
       
       
       //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account acc = Test_Utils.createFoyer();
        acc.Name='test';
        listFoyersToInsert.add(acc); 
		insert listFoyersToInsert;  
        
 Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.Type_de_panel__c = Label.RFP_Nom_PaME;
        refPanPaME.Name	= Label.RFP_TypePanel_PaME;
        insert refPanPaME;
    
		Foyer_Paneliste__c foyerPan = new Foyer_Paneliste__c();
        foyerPan.Referentiel_Panel__c = refPanPaME.Id;
        foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel;
        foyerPan.name = 'TestAP01_Contact';
        foyerPan.Foyer__c = acc.Id;
        insert      foyerPan;
    
        
        //Create workOrder
        	
        	workorder wo = new workorder ();
        	wo.AccountId=acc.id;
        	WO.Tech_TestClass__c=true;
       		wo.Foyer_paneliste__c=foyerPan.id;
        	insert wo;
        	id workorderid=wo.id;
         //create ServiceAppointment
       
         
         serviceAppointment SA = Test_Utils.createSA(workorderid); 
        
         SA.EarliestStartTime=system.today();
         SA.DueDate=system.today()+1;
         SA.Status='A planifié';
         SA.SchedStartTime= datetime.newInstance(2023,10, 15, 12, 33, 0);
         SA.SchedendTime= datetime.newInstance(2023,10, 17, 12, 33, 0);
     	serviceAppointment SA2 = Test_Utils.createSA(workorderid); 
        
        
       
         insert SA;
  
   
     Test.startTest();
       SA = [select SchedStartTime from ServiceAppointment ];
       system.assertEquals(30,SA.SchedStartTime.minute());
    
     Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock('rr'));
     TEST.stopTest();
    }
  
    
}