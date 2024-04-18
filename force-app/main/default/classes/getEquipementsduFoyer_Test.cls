@isTest
public class getEquipementsduFoyer_Test {
    @isTest
    static void tesEquipementsduFoyer(){
        
        Id RecordTypeAIP= Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get('AIP').getRecordTypeId();
        //Id RecordTypeAIP=[SELECT Id from RecordType where DeveloperName ='AIP' ];
        // Create test data
       Profile testProfile = [SELECT Id FROM Profile WHERE UserType = 'CspLitePortal' LIMIT 1];
        UserLicense ul = [SELECT Id FROM UserLicense WHERE Name = 'Customer Community' LIMIT 1];
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(
            AccountId = testAccount.Id,
            FirstName = 'Test First Name',
            LastName = 'Test Last Name',
            Birthdate = Date.newInstance(1990, 5, 2),
            Type__c = '1'
        );
        insert testContact;
        Referentiel_Panel__c referentiel = new Referentiel_Panel__c(Type_de_panel__c = 'AIP');
            insert referentiel;
        
        
        Foyer_paneliste__c testFoyerPaneliste = new Foyer_paneliste__c(
            Numero_foyer__c = 765438,
            RecordTypeId = RecordTypeAIP,
            Referentiel_Panel__c = referentiel.Id
        );
        insert testFoyerPaneliste;
        
        Individu_Paneliste__c testIndividuPaneliste = new Individu_Paneliste__c(
            Composition_du_foyer__c = testContact.Id,
            Foyer_paneliste__c = testFoyerPaneliste.Id
        );
        insert testIndividuPaneliste;
        
        Equipements_du_foyer__c testEquipement = new Equipements_du_foyer__c(
            Foyer__c = testAccount.Id,
            Type__c = '1',
            Batterie__c = 100,
            Emplacement__c = '1',
            Date_d_installation__c = Date.today(),
            Utilisateur_principal__r = testContact
        );
        insert testEquipement;
        asset poste = new asset();
        poste.AccountId=testAccount.id;
        poste.Foyer_paneliste__c=testFoyerPaneliste.id;
        poste.Type_de_materiel__c='34';
        poste.Audimetre__c='lkjo';
        insert poste;
        
        asset poste1 = new asset();
        poste1.AccountId=testAccount.id;
        poste1.Foyer_paneliste__c=testFoyerPaneliste.id;
        poste1.Type_de_materiel__c='31';
        poste1.Audimetre__c='ljhkojh';
        insert poste1;
        
        User testUser = new User(
            FirstName = 'Test UserBz',
            LastName = 'Test UserBz',
            Email = 'UserBz@example.com',
            Username = 'UserBz@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US',
              ContactId = testContact.Id,
            Bypass_flows__c = true
        );
        insert testUser;
        
        Test.startTest();
        System.runAs(testUser) {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            getEquipementsduFoyer.wrapperType result = getEquipementsduFoyer.getEquipementsduFoyer();
            
            
            if (result.equipements.size()>0){
                getEquipementsduFoyer.EquipmentWrapper equipment = result.equipements[0];
            
            //System.assertEquals('Poste TV', equipment.type);
            
                
            }
        }
        Test.stopTest();
    }
}