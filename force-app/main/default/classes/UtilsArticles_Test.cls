@isTest
public class UtilsArticles_Test {
    
    static User setup(String nameUser) {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
        insert referentiel;
        Foyer_paneliste__c foyer = new Foyer_paneliste__c(Referentiel_Panel__c = referentiel.Id, Foyer_Paneliste_ExtId_SIPanel__c = '111');
        insert foyer;
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@test.com',
            type__c='1',
            AccountId = testAccount.Id,
            Birthdate = System.today().addYears(-30)
        );
        insert testContact;
        Individu_Paneliste__c individu = new Individu_Paneliste__c(Composition_du_foyer__c = testContact.Id, Foyer_paneliste__c = foyer.Id);
        insert individu;
        User u = new User(Alias = 'Alia', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName=nameUser, LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' limit 1].Id,
                          TimeZoneSidKey='America/Los_Angeles', UserName=nameUser+'@testorg.com',
                          ContactId = testContact.Id);
        insert u;
        return u;
    }
    
    @isTest
    static void testGetAllArticles() {
        User u = setup('user1');
        // Setting up the HttpCalloutMock to return the mock response
        String responseBody1 = '{' +
            '    "campaignId": "testCampaignId",' +
            '    "customerReference": "",' +
            '    "comments": "testComments",' +
            '    "CaseID": "testCaseId",' +
            '    "tryId": "testTryId"' +
            '}';
        
        // String responseBody = '{ "id_article": "1", "titre": "Anes", "message": "1 2 3 Viva .... ", "date_article": "Date", "redacteur": "Anes", "image": "Image", "video": "Video", "extrait": "Extrait", "sous_titre": "Subtitle", "type_article": "Type", "etat_article": "Etat", "Commentaires": "Comments", "NbComm": "NbComm", "Tags": "Tags", "Theme": ["Theme1", "Theme2"], "LL_Theme": ["LL_Theme1", "LL_Theme2"], "time_Z": 10, "dtDeb": "dtDeb", "dtFin": "dtFin", "typeSplash": "TypeSplash", "libBtn": "LibBtn", "dtMajArt": "dtMajArt", "accesPanelistes": "AccesPanelistes", "fl_lu": true, "fl_favoris": true, "fl_like": true, "nbLike": 1 }';
        String responseBody = '{ "id_article": "1", "titre": "Anes", "message": "1 2 3 Viva ...", "date_article": "Date", "redacteur": "Anes", "image": "Image", "video": "Video", "extrait": "Extrait", "sous_titre": "Subtitle", "type_article": "Type", "etat_article": "Etat", "Commentaires": "Comments", "NbComm": "NbComm", "Tags": "Tags", "Theme": ["Theme1", "Theme2"], "LL_Theme": ["LL_Theme1", "LL_Theme2"], "time_Z": 10, "dtDeb": "dtDeb", "dtFin": "dtFin", "typeSplash": "TypeSplash", "libBtn": "LibBtn", "dtMajArt": "dtMajArt", "accesPanelistes": "AccesPanelistes", "fl_lu": true, "fl_favoris": true, "fl_like": true, "nbLike": 1}';
        Test.startTest();
        System.runAs(u) {
            // Call your method here. The mock response will be returned when it makes the HTTP callout
            HttpCalloutMock mock = new HttpCalloutMockImpl(200, 'OK',responseBody);
            Test.setMock(HttpCalloutMock.class, mock);
            UtilsArticles.OnLoadWrapper articlesWrapper = UtilsArticles.getAllArticles(0, false);
            articlesWrapper = UtilsArticles.getAllArticles(0, true);
            //UtilsArticles art = new UtilsArticles();
        }
        Test.stopTest();
        // Add assertions to verify the behavior and expected results
        // Assuming the articlesWrapper contains expected data
        // System.assertNotEquals(null, articlesWrapper.articlesData, 'Expected articlesData to be populated');
    }
    
    @isTest
    static void testGetInfoArticle() {
        User u = setup('user2');
        System.runAs(u) {
            // Set the mock for the callout
            String responseBody = '{}'; // Set this to the JSON that you expect to receive from the callout
            HttpCalloutMock mock = new HttpCalloutMockImpl(200, 'OK', responseBody);
            Test.setMock(HttpCalloutMock.class, mock);
            // Prepare the parameters for the method
            String idArticle = '12345';  // replace with actual ID
            // Call the method
            String result = UtilsArticles.getInfoArticle(idArticle);
            // Asserts go here.
            System.assertNotEquals(null, result, 'Expected non-null result');
        }
    }
        
    @isTest
    static void testMakeLike() {
        User u = setup('user3');
        System.runAs(u) {
            // Set the mock for the callout
            String responseBody = '{}'; // Set this to the JSON that you expect to receive from the callout
            HttpCalloutMock mock = new HttpCalloutMockImpl(200, 'OK', responseBody);
            Test.setMock(HttpCalloutMock.class, mock);
            // Prepare the parameters for the method
            String idArticle = '12345';  // replace with actual ID
            Integer value = 1;  // replace with actual value
            // Call the method
            Test.startTest();
            UtilsArticles.makeLike(idArticle, value);
            Test.stopTest();            
        }
        // No assertion here as the method is void and does not return anything.
    }
    
    @isTest
    static void testGetCountAllarticles() {
        User u = setup('user4');
        System.runAs(u) {
            // Set the mock for the callout
            String responseBody = '{}'; // Set this to the JSON that you expect to receive from the callout
            HttpCalloutMock mock = new HttpCalloutMockImpl(200, 'OK', responseBody);
            Test.setMock(HttpCalloutMock.class, mock);
            // Call the method
            String result = UtilsArticles.GetCountAllarticles();
            // Asserts go here.
        }
    }

    // Continue adding other test methods as needed.
}