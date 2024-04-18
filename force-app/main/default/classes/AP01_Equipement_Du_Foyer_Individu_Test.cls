/*
* @date: 28/09/2023
* @ Description Class qui teste AP01_Equipement_Du_Foyer_De_l_Individu
* @version 1.00   
* pourcentage : %
* @Auteur Claire VEHRLE
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP01_Equipement_Du_Foyer_Individu_Test {

    @isTest
    static void Get_Equipement_Du_Foyer_Individu() {
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
        insert foyerToInsert;
        
        List<Contact> contactToInsert = new List<Contact>();
        Contact compoFoyer = new Contact();
        compoFoyer.accountId = foyer1.Id;
        compoFoyer.FirstName = 'Prénom';
        compoFoyer.LastName = 'Nom';
        compoFoyer.Birthdate = Date.Today();
        compoFoyer.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer.Type__c = Label.CON_Type_MEMBRE;
        contactToInsert.add(compoFoyer);
        
        insert contactToInsert;
        
        List<Equipements_du_foyer__c> eqtFoyerToInsert = new List<Equipements_du_foyer__c>();
        Equipements_du_foyer__c eqtFoyer1 = new Equipements_du_foyer__c();
        eqtFoyer1.recordTypeId = recordTypeIdeqtFoyerPoste;
        eqtFoyer1.foyer__c = foyer1.Id;
        eqtFoyerToInsert.add(eqtFoyer1);
        
        Equipements_du_foyer__c eqtFoyer2 = new Equipements_du_foyer__c();
        eqtFoyer2.recordTypeId = recordTypeIdeqtFoyerDevice;
        eqtFoyer2.foyer__c = foyer1.Id;
        eqtFoyer2.Type__c = Label.EQF_Type_Smartphone;
        eqtFoyerToInsert.add(eqtFoyer2);
        
        insert eqtFoyerToInsert;
        
        Equipement_du_foyer_de_l_individu__c eqtInd = new Equipement_du_foyer_de_l_individu__c();
        eqtInd.Utilisation_de_l_equipement__c = 'Oui';
        eqtInd.Composition_du_foyer__c = compofoyer.Id;
        eqtInd.Equipement_du_foyer__c = eqtFoyer2.Id;
        
        insert eqtInd;
        
        MembreFoyerCallout_Mock fakeSendcompoFoyer = new MembreFoyerCallout_Mock(compoFoyer.Id);
        
        Test.startTest();
        AP01_Equipement_Du_Foyer_De_l_Individu.getEquipementFoyerIndividu(eqtFoyer2.Id);
        Test.stopTest();
    }
    
    @isTest
    static void Update_Equipement_Du_Foyer_Individu() {
        Id recordTypeIdeqtFoyerPoste = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Id recordTypeIdeqtFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerToInsert.add(foyer1);
        insert foyerToInsert;
        
        List<Contact> contactToInsert = new List<Contact>();
        Contact compoFoyer = new Contact();
        compoFoyer.accountId = foyer1.Id;
        compoFoyer.FirstName = 'Prénom';
        compoFoyer.LastName = 'Nom';
        compoFoyer.Birthdate = Date.Today();
        compoFoyer.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer.Type__c = Label.CON_Type_MEMBRE;
        contactToInsert.add(compoFoyer);
        
        insert contactToInsert;
        
        List<Equipements_du_foyer__c> eqtFoyerToInsert = new List<Equipements_du_foyer__c>();
        Equipements_du_foyer__c eqtFoyer1 = new Equipements_du_foyer__c();
        eqtFoyer1.recordTypeId = recordTypeIdeqtFoyerPoste;
        eqtFoyer1.foyer__c = foyer1.Id;
        eqtFoyerToInsert.add(eqtFoyer1);
        
        Equipements_du_foyer__c eqtFoyer2 = new Equipements_du_foyer__c();
        eqtFoyer2.recordTypeId = recordTypeIdeqtFoyerDevice;
        eqtFoyer2.foyer__c = foyer1.Id;
        eqtFoyer2.Type__c = Label.EQF_Type_Smartphone;
        eqtFoyerToInsert.add(eqtFoyer2);
        
        insert eqtFoyerToInsert;
        
        Equipement_du_foyer_de_l_individu__c eqtInd = new Equipement_du_foyer_de_l_individu__c();
        eqtInd.Utilisation_de_l_equipement__c = 'Oui';
        eqtInd.Composition_du_foyer__c = compofoyer.Id;
        eqtInd.Equipement_du_foyer__c = eqtFoyer2.Id;
        
        insert eqtInd;
        
        
        Test.startTest();
        List<Equipement_du_foyer_de_l_individu__c> eqtIndToUpdate = new List<Equipement_du_foyer_de_l_individu__c>();
        eqtInd.Utilisation_de_l_equipement__c = 'Non';
        eqtIndToUpdate.add(eqtInd);
        AP01_Equipement_Du_Foyer_De_l_Individu.updateEquipementFoyerIndividu(eqtIndToUpdate);
        Test.stopTest();
    }
    
}