@isTest
public class AP10_CreateAppels_Test {
    
    @isTest
    static void testCreateAppels() {
        // Test data setup
        List<Id> recordIdList = new List<Id>();
        recordIdList.add(createTestRecord('Case'));
        recordIdList.add(createTestRecord('Task'));
        recordIdList.add(createTestRecord('Etiquette__c'));
        recordIdList.add(createTestRecord('Account'));
        
        String campaignId = createTestCampaign();
        
        // Call the method under test
        Set<Appel__c> appels = AP10_CreateAppels.CreateAppels(recordIdList, campaignId);
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AcceptTryRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Perform assertions
        System.assertNotEquals(null, appels, 'CreateAppels() returned null');
        System.assertEquals(4, appels.size(), 'Incorrect number of appels created');
    }
    
    static Id createTestRecord(String objectType) {
        
        User adminUser =[SELECT Id,UserRoleId FROM User WHERE Profile.Name='System Administrator'And IsActive=true Limit 1];
        adminUser.Bypass_validation_rules__c=true;
        update adminUser;
        
        SObject obj;
        System.runAs(adminUser){
        
        if (objectType == 'Case') {
            //System.runAs(adminUser){
            obj = new Case(AccountId = createTestAccount());
            } else if (objectType == 'Task') {
            obj = new Task(WhatId = createTestAccount()); // Use WhatId instead of AccountId
        } else if (objectType == 'Etiquette__c') {
            obj = new Etiquette__c(Foyer__c = createTestAccount(),Nom_de_l_etiquette__c=/*'Pilote TvRouteur'*/'Foyer test');
        } else if (objectType == 'Account') {
            obj = new Account(Name = 'Test Account2',Statut_du_foyer__c='0', Type_de_foyer__c='1');
        }
        
        
        insert obj;
        }
        return obj.Id;
    
    }
    
    static Id createTestAccount() {
        Account acc = new Account(Name = 'Test Account',Statut_du_foyer__c='0', Type_de_foyer__c='1',Numero_de_telephone_fixe__c='0123456789',Numero_de_portable__c='0123456789');
        insert acc;
        return acc.Id;
    }
    
    static String createTestCampaign() {
        Campaign campaign = new campaign(Temps_dattente__c = 10,CampagneID_Avaya__c='ID1',Name='Anes Test');
        insert campaign;
        return campaign.Id;
    }
}