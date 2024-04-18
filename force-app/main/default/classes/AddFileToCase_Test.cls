@isTest(seeAllData=true)
public class AddFileToCase_Test {
    
    @isTest
    static void testAddAttachment() {

        Id userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'MM' Limit 1].Id;

        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator'And IsActive=true Limit 1];
        adminUser.Bypass_flows__c=true;
        adminUser.Bypass_RDD__c=true;
        adminUser.Bypass_validation_rules__c=true;
        adminUser.IsActive = true;
        adminUser.UserRoleId = userrole;
        update adminUser;

        System.runAs(adminUser){
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;

            Contact testContact = new Contact(LastName = 'Test', Firstname = 'kjnijb', AccountId = testAccount.Id, Birthdate = Date.newInstance(2000, 1, 1), Type__c = '1');
            insert testContact;


            Profile p = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' AND Name = 'Customer Community User' LIMIT 1];

            Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
            insert referentiel;

            Foyer_paneliste__c testFoyer = new Foyer_paneliste__c(Name = 'Test Foyer', Referentiel_Panel__c = referentiel.Id);
            insert testFoyer;

            Individu_Paneliste__c testIndividu = new Individu_Paneliste__c(Name = 'Test Individu', Foyer_paneliste__c = testFoyer.Id, Composition_du_foyer__c = testContact.Id);
            insert testIndividu;
            

            ////
            Account testAccount2 = new Account(Name = 'Test Account 2');
            insert testAccount2;
    
            Contact testContact2 = new Contact(LastName = 'Test', AccountId = testAccount2.Id, Type__c = '1', Birthdate = Date.newInstance(2000, 3, 1));
            insert testContact2;
    
            User testUser = new User(
                Alias = 'tel',
                Email = 'tslam@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Bz test2',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'lamiaauniquetestclass@testorg.com',
                ContactId = testContact2.Id,
                Solde_de_point__c = '200',
                Bypass_flows__c = true,
                Bypass_RDD__c = true,
                Bypass_process_builders__c = true
            );
            testUser.IsActive = true;
            insert testUser;
    
            // UserLicense ul = [SELECT Id FROM UserLicense WHERE Name = 'Customer Community' LIMIT 1];
    		//List<ContentVersion> cdi = [SELECT ContentDocumentId from ContentVersion LIMIT 1];
            
            ContentVersion testContentVersion = new ContentVersion();
            testContentVersion.Title = 'Test File';
            testContentVersion.PathOnClient = 'testfile.txt';
            testContentVersion.VersionData = Blob.valueOf('Test file content');
            
            //testContentVersion.ContentDocumentId =cdi.get(0).id;
            insert testContentVersion;
            
            //list<ContentVersion> acc = [SELECT contentDocumentid FROM ContentVersion WHERE Id=testContentVersion.id];
            
            Case testCase = new Case();
            insert testCase;
    
             List<Formulaire__mdt> fmdtList = ContactFormulaire.contactType() == 'AIP' ? 
                                     [SELECT Sous_type_SF__c, Type_SF__c FROM Formulaire__mdt WHERE Type_portail__c = 'Autre' AND Sous_Type_portail__c = 'Autre' AND Formulaire__c ='Absence' AND user_type__c = 'AIP' LIMIT 1] :
                                     [SELECT Sous_type_SF__c, Type_SF__c FROM Formulaire__mdt WHERE Type_portail__c = 'Autre' AND Sous_Type_portail__c = 'Autre' AND Formulaire__c ='Absence' AND user_type__c = 'AIP' limit 1];
    
            Test.startTest();
            System.runAs(testUser) {
                test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
                Boolean result = AddFileToCase.addAttachment(
                    '0013X00003Qh9jIQAR',
                    'Autre',
                    'Autre',
                    'motif',
                    'description',
                    String.valueOf(Date.today()),
                    String.valueOf(Date.today()),
                    '',
                    'Absence',
                    '',
                    ''
                );
                
                //AddFileToCase.insertAttachment(testContentVersion.id,testCase.id);
    
                System.assertEquals(false, result);
                
                
                
                
            }
            Test.stopTest();
        }
    }
    
    //deuxiemeM
    
     @isTest
    static void testAddAttachmentAutre() {

        Id userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'MM' Limit 1].Id;

        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator'And IsActive=true Limit 1];
        adminUser.Bypass_flows__c=true;
        adminUser.Bypass_RDD__c=true;
        adminUser.Bypass_validation_rules__c=true;
        adminUser.IsActive = true;
        adminUser.UserRoleId = userrole;
        update adminUser;

        System.runAs(adminUser){
            Account testAccount = new Account(Name = 'Test Account');
            insert testAccount;

            Contact testContact = new Contact(LastName = 'Test', Firstname = 'kjnijb', AccountId = testAccount.Id, Birthdate = Date.newInstance(2000, 1, 1), Type__c = '1');
            insert testContact;


            Profile p = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' AND Name = 'Customer Community User' LIMIT 1];

            Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
            insert referentiel;

            Foyer_paneliste__c testFoyer = new Foyer_paneliste__c(Name = 'Test Foyer', Referentiel_Panel__c = referentiel.Id);
            insert testFoyer;

            Individu_Paneliste__c testIndividu = new Individu_Paneliste__c(Name = 'Test Individu', Foyer_paneliste__c = testFoyer.Id, Composition_du_foyer__c = testContact.Id);
            insert testIndividu;
            


  
            User testUser = new User(
                Alias = 'tel',
                Email = 'tslam@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Bz test2',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'lamiaauniquetestclass@testorg.com',
                ContactId = testContact.Id,
                Solde_de_point__c = '200',
                Bypass_flows__c = true,
                Bypass_RDD__c = true,
                Bypass_process_builders__c = true
            );
            testUser.IsActive = true;
            insert testUser;
    
            // UserLicense ul = [SELECT Id FROM UserLicense WHERE Name = 'Customer Community' LIMIT 1];
    
            ContentVersion testContentVersion = new ContentVersion();
            testContentVersion.Title = 'Test2 File';
            testContentVersion.PathOnClient = 'testfile.txt';
            testContentVersion.VersionData = Blob.valueOf('Test file content');
            insert testContentVersion;
    
             Formulaire__mdt fmdt = ContactFormulaire.contactType() == 'AIP' ? 
                                     [SELECT Sous_type_SF__c, Type_SF__c FROM Formulaire__mdt WHERE Type_portail__c = 'Autre' AND Sous_Type_portail__c = 'Autre' AND Formulaire__c = 'Planifier un RDV' AND user_type__c = 'AIP' LIMIT 1] :
                                     [SELECT Sous_type_SF__c, Type_SF__c FROM Formulaire__mdt WHERE Type_portail__c = 'Autre' AND Sous_Type_portail__c = 'Autre' AND Formulaire__c = 'Planifier un RDV' AND user_type__c = 'AIP' LIMIT 1];
    
            Test.startTest();
            System.runAs(testUser) {
                test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
                Boolean result = AddFileToCase.addAttachment(
                    '0013X00003Qh9jIQAR',
                    'Autre',
                    'Autre',
                    'motif',
                    'description',
                    String.valueOf(Date.today()),
                    String.valueOf(Date.today()),
                    '',
                    'Planifier un RDV',
                    '15:00-17:00',
                     ''
                );
    
                
            }
            Test.stopTest();
        }
    }
    //findeuxiemeM
   
    
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{'+
                             '    "defaultValue": {'+
                             '        "label": "Default Entry",'+
                             '        "value": "default_value"'+
                             '    },'+
                             '    "values": ['+
                             '        {'+
                             '            "label": "First Value",'+
                             '            "value": "first_value"'+
                             '        },'+
                             '        {'+
                             '            "label": "Second Value",'+
                             '            "value": "second_value"'+
                             '        },'+
                             '        {'+
                             '            "label": "Third Value",'+
                             '            "value": "third_value"'+
                             '        }'+
                             '    ]'+
                             '}');
            response.setStatusCode(200);
            return response;
        }
    }
}