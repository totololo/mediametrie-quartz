@isTest
public class getFoyerPanelisteInformations_Test {
    // Set up test data
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(LastName = 'Test',FirstName='Nad', AccountId = testAccount.Id, Type__c = '1',Birthdate=system.today().addYears(-45));
        insert testContact;
		
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
        insert referentiel;
        
        // Retrieve a portal profile
        Profile p = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1];
        UserLicense ul = [SELECT Id FROM UserLicense WHERE Name = 'Customer Community' LIMIT 1];
        
        User testUser = new User(Alias = 'AnesBz', Email = 'AnesUser@testorg.com', 
                                 EmailEncodingKey = 'UTF-8', LastName = 'Anes test', LanguageLocaleKey = 'en_US', 
                                 LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'AnesUser@testorg.com',
                                 ContactId = testContact.Id);
        insert testUser;
        
        Foyer_paneliste__c testFoyer = new Foyer_paneliste__c(Name = 'Test Foyer',Referentiel_Panel__c = referentiel.Id);
        insert testFoyer;
        
        Individu_Paneliste__c testIndividu = new Individu_Paneliste__c(Name = 'Test Individu', Foyer_paneliste__c = testFoyer.Id, Composition_du_foyer__c = testContact.Id);
        insert testIndividu;
    }
    
    @isTest 
    static void testGetInformations() {
        setupTestData();
        User testUser = [SELECT Id FROM User WHERE Email = 'AnesUser@testorg.com'];
        
        // Run test
        System.runAs(testUser) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            getFoyerPanelisteInformations.wrapperType result = getFoyerPanelisteInformations.getInformations(1, true);
            
            // Assertions to validate the result
            System.assertNotEquals(null, result);
            System.assertEquals(1, result.tableRows);
        }
    }
    
    @isTest 
    static void testGetInformationsWithFromSoldeFalse() {
        setupTestData();
        User testUser = [SELECT Id FROM User WHERE Email = 'AnesUser@testorg.com'];
        
        // Run test
        System.runAs(testUser) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            getFoyerPanelisteInformations.wrapperType result = getFoyerPanelisteInformations.getInformations(1, false);
            
            // Assertions to validate the result
            System.assertNotEquals(null, result);
            //... more assertions here
        }
    }
}