//07/06/2023
//Lamiaa AAMOUM
//classe: getDerniereCommande
//couverture
@isTest
public class getDerniereCommande_Test {
    
    @isTest
    public static void getDerniereCommandeInformations_Test(){
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User userTest = [SELECT Id,Name FROM User WHERE profileId =:profile.id and Name='Lamiaa AAMOUM'  limit 1];
        userTest.Bypass_validation_rules__c=true;
        //userTest.Bypass_flows__c = false;
        userTest.Bypass_triggers__c= 'AP01_Foyer';
        userTest.Bypass_flows__c= true;
        update userTest;
       /*User userTest = new User();
        userTest.FirstName ='Test';
        userTest.LastName = 'User';
        userTest.Email='testuser@test.com';
        userTest.Username = 'testuser@example.com';
        userTest.Alias = 'tuser';
        userTest.CommunityNickname = 'tuser';
        userTest.TimeZoneSidKey = 'America/New_York';
        userTest.LocaleSidKey = 'en_US';
        userTest.EmailEncodingKey = 'UTF-8';
        userTest.ProfileId = profile.Id;
        userTest.Bypass_RDD__c=true;
        insert userTest;*/
        
            /*[SELECT Id,Name FROM User WHERE Name='Lamiaa AAMOUM'];
        userTest.Bypass_validation_rules__c=true;*/
        
        
        
        System.runAs(userTest){
            
        
        Account acc = new Account();
        acc.Name= 'accountTest';
        //acc.Nombre_de_points_cumules__c= 200;
        //acc.Nombre_de_points_debites__c =0;
        insert acc;
        
        Contact contact = new Contact();
        contact.FirstName = 'testFirstName';
        contact.LastName = 'testLasName';
        contact.Birthdate=Date.newInstance(1990, 05, 02);
        contact.Type__c = '1';
        contact.AccountId=acc.id;
        insert contact;
        
        Individu_Paneliste__c ind = new Individu_Paneliste__c();
        ind.Composition_du_foyer__c = contact.Id;
        ind.Lettre__c= 'B';
        insert ind;
        
        
        acc.Personne_de_reference__c= contact.id;
        acc.Contact_principal__c= contact.id;
            update acc;
        
        Foyer_paneliste__c fp = new Foyer_paneliste__c();
        //fp.RecordTypeId= 0123r000000gOkuAAE;
        //fp.Referentiel_Panel__c = 'AIP';
        fp.Numero_foyer__c= 765438;
        insert fp;
            
        
        Fidelisation__c fidelisation1 = new Fidelisation__c();
            //if(SkipValidation__c ==false){
                
            //}
        fidelisation1.RecordType=[SELECT Id FROM RecordType WHERE Name = 'Débit'];
        fidelisation1.Foyer__c= acc.Id;
        //fidelisation1.Composition_du_foyer__r.Contact__c= contact.Id;
        fidelisation1.Points_credites__c=300;
        fidelisation1.Points_debites__c=50;
        fidelisation1.Foyer_paneliste__c= fp.id;
        fidelisation1.Individu_paneliste__c= ind.id;
        fidelisation1.Composition_du_foyer__c= contact.id;
        //fidelisation1.Solde_de_points_a_creation__c = 200;
        
        insert fidelisation1;
        
        
        
        getDerniereCommande.wrapperType expectesWrapper = new getDerniereCommande.wrapperType();
        expectesWrapper.totalCommande = 1;
        List<Fidelisation__c> expectedFidelisations = new List <Fidelisation__c>();
        expectedFidelisations.add(fidelisation1);
        expectesWrapper.listCommande = expectedFidelisations;
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        getDerniereCommande.wrapperType result = getDerniereCommande.getInfo(1,10);
        //Assert.areEqual(expected, result);
            Test.stopTest();
        
        /*User userTest =[SELECT Id,Name FROM User WHERE Name='TEST COMMUNITY'];
        
        System.runAs(userTest){
            
            getDerniereCommande.wrapperType wrapper = getDerniereCommande.getInfo(1, 2);
            System.debug('getEquipementsduFoyer_Test wrapperType : '+ wrapper.totalCommande);
            System.assertNotEquals(0,wrapper.totalCommande);
        }*/
    }
    }
        

}