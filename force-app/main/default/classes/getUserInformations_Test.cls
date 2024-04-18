@isTest
public class getUserInformations_Test {
    
    @isTest 
    static void testGetInformations() {
        setupTestData();
        User testUser = [SELECT Id,Tech_CanalPrivilegie__c FROM User WHERE Email = 'AnesUser@testorg.com'];
        
        // Run test
        System.runAs(testUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            getUserInformations.onLoadWrapper result = getUserInformations.getInformations();
            Test.stopTest();
            // add assertions to validate the result
            System.assertNotEquals(null, result);
            System.assertNotEquals(null, result.utilisateur);
            System.assertNotEquals(null, result.ChannelPrivilegeList);
        }
    }
    
    @isTest 
    static void testUpdateUserInformations() {
        setupTestData();
        User testUser = [SELECT Id, Email, MobilePhone,Tech_CanalPrivilegie__c FROM User WHERE Email = 'AnesUser@testorg.com'];
        
        // Run test
        System.runAs(testUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            String result = getUserInformations.updateUserInformations(testUser);
            Test.stopTest();
            // add assertions to validate the result
            System.debug('bastien result : ' + result);
            System.assertEquals('User Updated, Contact Updated', result);
        }
    }
    @isTest 
    static void testUpdateUserInformationsWithException() {
        setupTestData();
        User testUser = [SELECT Id, Email, MobilePhone,ProfileId,ContactId FROM User WHERE Email = 'AnesUser@testorg.com'];
        
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert testAccount2;
        
        Contact testContact2 = new Contact(LastName = 'Test', AccountId = testAccount2.Id,Type__c= '1',Birthdate=system.today().addYears(-43));
        insert testContact2;
        // Create a new user with the same email as testUser
        User testUser2 = new User(Alias = 'BzAnes', Email = 'AnesUser2@testorg.com', 
                                  EmailEncodingKey = 'UTF-8', LastName = 'Bz test2', LanguageLocaleKey = 'en_US', 
                                  LocaleSidKey = 'en_US', ProfileId = testUser.ProfileId, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'BzAnesUser@testorg.com',
                                  ContactId = testContact2.Id, Solde_de_point__c = '200');
        insert testUser2;
        
        // Set testUser's email to a new email
        testUser.Email = 'newAnesUser@testorg.com';
        
        // Run test
        System.runAs(testUser) {
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            String result = getUserInformations.updateUserInformations(testUser2);
            Test.stopTest();
            
            // add assertions to validate the result
            System.assertEquals('User Updated, Contact Updated', result);
        }
    }
    
    // Set up test data
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(LastName = 'Test',FirstName='Nade', AccountId = testAccount.Id, Birthdate = Date.newInstance(2000, 1, 1),type__c='1');
        insert testContact;
        
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
        insert referentiel;
        // Retrieve a portal profile
        Profile p = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1];
        UserLicense ul = [SELECT Id FROM UserLicense WHERE Name = 'Customer Community' LIMIT 1];
        
        User testUser = new User(Alias = 'AnesBz', Email = 'AnesUser@testorg.com', 
                                 EmailEncodingKey = 'UTF-8', LastName = 'Anes test', LanguageLocaleKey = 'en_US', 
                                 LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'AnesUser@testorg.com',
                                 ContactId = testContact.Id, Solde_de_point__c = '100');
        insert testUser;
        
        Foyer_paneliste__c testFoyer = new Foyer_paneliste__c(Name = 'Test Foyer',Referentiel_Panel__c = referentiel.Id);
        insert testFoyer;
        
        Individu_Paneliste__c testIndividu = new Individu_Paneliste__c(Name = 'Test Individu', Foyer_paneliste__c = testFoyer.Id, Composition_du_foyer__c = testContact.Id);
        insert testIndividu;
    }
}