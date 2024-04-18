/*
* @Auteur Claire VEHRLE
* @date: 09/03/2022
* @Classe: BarchRDD15_Action
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD15_Action_Test {

    @isTest
    Static void RDD_Action() {
         
         User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
         u.Bypass_workflows__c = true;
         u.Bypass_flows__c = true;
         u.Bypass_triggers__c = 'AP01_WorkOrder; AP08_FoyerPaneliste';
         update u;
        
        System.runAs(u){
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

        List<Account> foyerList = new List<Account>();
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
        foyer2.Nombre_tv__c = '3';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        
        Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste2.Name = 'Foyer Paneliste 2';
        foyerPaneliste2.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPanelisteList;
        
        WorkOrder intervention = new WorkOrder();
        intervention.AccountId = foyer2.Id;
        intervention.Type_de_l_intervention__c = '1';
        intervention.Actions__c = '1';
        intervention.Foyer_paneliste__c = foyerPaneliste2.Id;
        
        insert intervention;
        
        WorkOrderLineItem action = new WorkOrderLineItem();
        action.Foyer__c = foyer2.Id;
        action.Actions__c = '1';
        action.WorkOrderId = intervention.Id;
        
        insert action;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(intervention.id));
        BatchRDD15_Action btch = new BatchRDD15_Action();
        database.executeBatch(btch);
        Test.stopTest();
        
        //List<ServiceAppointment> rdvServiceBatch = [SELECT Id, Foyer_Paneliste__r.Id FROM ServiceAppointment WHERE AccountId = :foyer2.Id];
        WorkOrderLineItem actionList = [SELECT Id, Foyer_Paneliste__c FROM WorkOrderLineItem];
        
        System.debug('$$$actionList: ' + actionList);
        
         
            
        }
    }
}