/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-14-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest(seealldata=true)
public class ContactFormulaire_Test {
    
    static void setup(String nameUser) {
        
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
        insert referentiel;
        Foyer_paneliste__c foyer = new Foyer_paneliste__c(Referentiel_Panel__c = referentiel.Id);
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
        
        List<Formulaire__mdt> testFormulaires = [
            SELECT DeveloperName, Label, Sous_type_portail__c, Sous_type_SF__c, Type_portail__c, Type_SF__c,Formulaire__c,user_type__c 
            FROM Formulaire__mdt
            limit 10
        ];
        system.debug('testFormulaires '+testFormulaires);
    }
    // Testing 'onPageInit' method
    @istest
    static void testOnPageInit() {
        setup('user1');
        
        // This is to avoid the MIXED_DML_OPERATION error.
        System.runAs(new User(Id = UserInfo.getUserId())) {
            // You need to provide the current page that the 'onPageInit' method needs to work on.
            // For each different page, you would need a different test method, or you could use a loop to iterate through multiple page names.
            // Assuming 'Commander', 'Absence', 'NousContacter', 'Planifier un RDV' are the possible page names.
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
            ContactFormulaire.onPageInit('Commander');
            ContactFormulaire.onPageInit('Absence');
            ContactFormulaire.onPageInit('NousContacter');
            ContactFormulaire.onPageInit('Planifier un RDV');
            
            
            Test.stopTest();
            
            // Assert statements to validate the behavior
            // For example, you may need to verify if a certain list in the onLoadWrapper object gets populated based on the currentPage and the contactType.
        }
    }
    
    // Add similar test methods for the other methods in your class
    @isTest
    static void testContactCgu() {
        setup('user2');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        ContactFormulaire.InitWhrapper result = ContactFormulaire.ContactCgu();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
      // Add similar test methods for the other methods in your class
    @isTest
    static void testContactCguPopUp() {
        setup('user2');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        ContactFormulaire.InitWhrapper result = ContactFormulaire.ContactCguPopUp();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateContactCgu() {
        setup('user3');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        ContactFormulaire.updateContactCgu();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testContactType() {
        setup('user4');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        String result = ContactFormulaire.contactType();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testGetSousType() {
        setup('user5');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        List<String> result = ContactFormulaire.getSousType('motif', 'Formulaire');
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testCreateNousContactezCase() {
        setup('user6');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        User u =[SELECT Id, ContactId, UserName
                 FROM User
                 WHERE UserName = 'user6@testorg.com'
                 LIMIT 1];
        
        
        //ContentVersion cv =[SELECT contentDocumentid FROM contentVersion limit 1 ];
        Id networkId = [SELECT Id FROM Network LIMIT 1].Id;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Document',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true,
            NetworkId = networkId
            
        ); 
        insert contentVersion;       
        System.runAs(u) {
            

            Boolean result = ContactFormulaire.CreateNousContactezCase('Autre', 'Autre','Abs', 'description', Date.today(), Date.today(),contentVersion.Id);
            
        }        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testCreateCommandeCase() {
        setup('user7');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        User u =[SELECT Id, ContactId, UserName
                 FROM User
                 WHERE UserName = 'user7@testorg.com'
                 LIMIT 1];
        System.runAs(u) {
            Boolean result = ContactFormulaire.createCommandeCase('Autre', 'Autre','', 'description', Date.today(), Date.today(),null);
            
        }
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testCreateRendezVousCase() {
        setup('user8');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        User u =[SELECT Id, ContactId, UserName
                 FROM User
                 WHERE UserName = 'user8@testorg.com'
                 LIMIT 1];
        System.runAs(u) {
            Boolean result = ContactFormulaire.createRendezVousCase('Autre', 'Autre', 'description',STRING.valueof(Date.today()),STRING.valueof(Date.today()));
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCreateAbsenceCase() {
        setup('user8');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        User u =[SELECT Id, ContactId, UserName
                 FROM User
                 WHERE UserName = 'user8@testorg.com'
                 LIMIT 1];
        System.runAs(u) {
            Boolean result = ContactFormulaire.CreateAbsenceCase('Autre', 'Autre', 'motif', 'description', STRING.valueof(Date.today()), STRING.valueof(Date.today()),null);
            
        }
        Test.stopTest();
    }
    
    @isTest
    static void testTypeValues() {
        setup('user01');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        List<ContactFormulaire.wrapperType> result = ContactFormulaire.typeValues();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testStatusValues() {
        setup('user02');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        List<ContactFormulaire.wrapperType> result = ContactFormulaire.statusValues();
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testGetFieldDependencies() {
        setup('user03');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        Map<String, List<String>> result = ContactFormulaire.getFieldDependencies('Case', 'Type', 'Sous_type__c');
        // Add assertions based on the expected behavior of the method
        Test.stopTest();
    }
    
    @isTest
    static void testgetPicklistValues() {
        setup('user003');
        contact cn=[select id,type__c from contact limit 1];
        Schema.DescribeFieldResult fieldResult = contact.type__c.getDescribe();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        List<Object> result = ContactFormulaire.getPicklistValues(contact.type__c);
        Test.stopTest();
    }
    
    
    private class HttpCalloutMockImpl implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Create a fake HTTP response
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