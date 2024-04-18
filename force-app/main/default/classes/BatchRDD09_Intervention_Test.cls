/*
* @Auteur Claire VEHRLE
* @date: 10/03/2022
* @Classe: BatchRDD09_Intervention
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD09_Intervention_Test {

    @isTest
    Static void RDD_Intervention() {
        
        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
         System.runAs(u){
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Numero_de_portable__c = '0611111121';
        foyerList.add(foyer1);
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste1);
        
        Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste2.Name = 'Foyer Paneliste 2';
        foyerPaneliste2.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPanelisteList;
        
        WorkOrder interv = new WorkOrder();
        interv.AccountId = foyer2.Id;
        interv.Type_de_l_intervention__c = '1';
        interv.Actions__c = '1';        
        insert interv; 
               
        WorkOrder intervention = new WorkOrder();
        intervention.AccountId = foyer2.Id;
        intervention.foyer_Paneliste__c = foyerPaneliste2.Id;
        intervention.Type_de_l_intervention__c = '1';
        intervention.Actions__c = '1';        
        insert intervention;
                       
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(intervention.id));
        BatchRDD09_Intervention btch = new BatchRDD09_Intervention();        
        database.executeBatch(btch);
        Test.stopTest();
        
        List<WorkOrder> interventionBatch = [SELECT Id, Foyer_Paneliste__r.Id FROM WorkOrder WHERE AccountId = :foyer2.Id];
        
        System.assertEquals(foyerPaneliste2.Id, interventionBatch[0].Foyer_Paneliste__r.Id);
             
         }
    }
}