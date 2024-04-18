@isTest
private class welcomeEmailController_Test {
    @isTest static void testGetUserInfo() {
        // Create test data
        // 
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
        insert referentiel;
        
        Foyer_Paneliste__c testFoyer = new Foyer_Paneliste__c(Name = 'Test Foyer', Referentiel_Panel__c = referentiel.Id, Foyer_Paneliste_ExtId_SIPanel__c='799');
        insert testFoyer;
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        contact testComposition = new contact(lastName = 'Test Composition',FirstName='tryuh', accountid=testAccount.id, type__c = '1',Birthdate=system.today().addYears(-33));
        insert testComposition;
        
        Individu_Paneliste__c testIndividu = new Individu_Paneliste__c(Composition_du_foyer__c = testComposition.Id, Foyer_paneliste__c = testFoyer.Id);
        insert testIndividu;
        
        // Initialize controller and set contactId
        WelcomeEmailController controller = new WelcomeEmailController();
        controller.contactId = testComposition.Id;
        
        // Call getUserInfo method and verify results
       Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        WelcomeEmailController.UserInfo result = controller.getUserInfo();
        System.assertEquals('0.00', result.SoldeDePoints);
        System.assertEquals('Test Foyer', result.NumeroPanel);
    }
}