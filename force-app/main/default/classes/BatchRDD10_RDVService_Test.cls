/*
* @Auteur Claire VEHRLE
* @date: 09/03/2022
* @Classe: BatchRDD10_RDVService
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD10_RDVService_Test {

    @isTest
    Static void RDD_RDVService() {
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

        List<Account> foyerList = new List<Account>();
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
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
        
        ServiceAppointment rdvService = new ServiceAppointment();
        rdvService.ParentRecordId = intervention.Id;
        
        insert rdvService;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(intervention.id));
        BatchRDD10_RDVService btch = new BatchRDD10_RDVService();
        database.executeBatch(btch);
        Test.stopTest();
        
        //List<ServiceAppointment> rdvServiceBatch = [SELECT Id, Foyer_Paneliste__r.Id FROM ServiceAppointment WHERE AccountId = :foyer2.Id];
        List<ServiceAppointment> rdvServiceBatch = [SELECT Id, Foyer_Paneliste__r.Id FROM ServiceAppointment];
        
        System.debug('$$$rdvServiceBatch: ' + rdvServiceBatch);
        
        System.assertEquals(foyerPaneliste2.Id, rdvServiceBatch[0].Foyer_Paneliste__r.Id);
    }
}