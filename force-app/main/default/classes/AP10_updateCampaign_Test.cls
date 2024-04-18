/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-19-2022
* @last modified by  : Anes BOUZOUINA
**/
@istest
public with sharing class AP10_updateCampaign_Test {
    
    @isTest static void testUpdateListView() {
        // Create test data
        Campaign testCampaign = new Campaign(CampagneID_Avaya__c = 'Test Queue',File_d_attente__c  = 'PRM-Groupe-1	',name='test Anes');
        insert testCampaign;
        
        List<SObject> testObjectList = new List<SObject>();
        testObjectList.add(new ListView(Id = '00B0Q000002i7jlUAA'));
        testObjectList.add(new ListView(Id = '00B0Q000003i7jlUAA'));
        
        // Call updateListView method
        AP10_updateCampaign.updateListView(testObjectList, 'Test Queue');
        
        // Verify results
        Campaign updatedCampaign = [SELECT Ids_des_vues_de_liste__c FROM Campaign WHERE Id = :testCampaign.Id];
        System.assertEquals('00B0Q000002i7jlUAA,00B0Q000003i7jlUAA', updatedCampaign.Ids_des_vues_de_liste__c);
    }
}