@isTest
public class getRecordCampaign_Test {

    @isTest
    static void testGetCampaigns() {
        // Create test data
        List<Campaign> testCampaigns = new List<Campaign>();
        for(Integer i = 0; i < 5; i++) {
            testCampaigns.add(new Campaign(
                Name = 'Test Campaign ' + i,
                CampagneID_Avaya__c = 'TestCampaignID' + i
                // Add any other required fields here
            ));
        }
        insert testCampaigns;

        // Call the method to test
        Test.startTest();
        List<Campaign> campaigns = getRecordCampaign.getCampaigns();
        Test.stopTest();

        // Verify the results
        System.assertEquals(5, campaigns.size(), 'Expected 5 campaigns to be returned');
        System.assertEquals('Test Campaign 4', campaigns[0].Name, 'The first campaign should be the one with the highest name');
    }
}