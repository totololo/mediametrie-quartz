/*
* @date: 06/07/2022
* @ Description Class qui teste AP01_Commande . Associatée au declenchers : REqueteAfterUpdate & REqueteAfterInsert
* @version 1.00   
* pourcentage : 95%
* @Auteur Claire VEHRLE
 History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP00_Objet_Non_transforme_Test {

    @isTest
    static void foyerNonTransformeMMATPaME() {
        Account foyer = new Account();
        foyer.name = 'Foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyer.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        
        insert foyer;
        AP00_Objet_Non_transforme.foyerNonTransformeMMATPaME();
    }
    
    @isTest
    static void foyerNonTransformeAIP() {
        Account foyer = new Account();
        foyer.name = 'Foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyer.Type_de_foyer__c = Label.ACC_Type_de_panel_AIP;
        
        insert foyer;
        AP00_Objet_Non_transforme.foyerNonTransformeAIP();
    }
    
    @isTest
    static void compoFoyerNonTransformeMMATPaME() {
        Account foyer = new Account();
        foyer.name = 'Foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyer.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        
        insert foyer;
        
        Contact compoFoyer = new Contact();
        compoFoyer.AccountId = foyer.Id;
        compoFoyer.LastName = 'Compo Foyer';
        compoFoyer.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        compoFoyer.Code_profession__c = 132;
        compoFoyer.Birthdate = Date.today();
        compoFoyer.Type__c = Label.CON_Type_MEMBRE;
        compoFoyer.CON_ExtId_SIPanel__c = '122223456';
        
        insert compoFoyer;   
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer.Id));
        AP00_Objet_Non_transforme.compoFoyerNonTransformeMMATPaME();
        Test.stopTest();
    }
    
    @isTest
    static void compoFoyerNonTransformeAIP() {
        Account foyer = new Account();
        foyer.name = 'Foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyer.Type_de_foyer__c = Label.ACC_Type_de_panel_AIP;
        
        insert foyer;
        
        Contact compoFoyer = new Contact();
        compoFoyer.AccountId = foyer.Id;
        compoFoyer.LastName = 'Compo Foyer';
        compoFoyer.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        compoFoyer.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        compoFoyer.Code_profession__c = 132;
        compoFoyer.Birthdate = Date.today();
        compoFoyer.Type__c = Label.CON_Type_MEMBRE;
        compoFoyer.CON_ExtId_SIPanel__c = '122223456';
        
        insert compoFoyer;   
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer.Id));
        AP00_Objet_Non_transforme.compoFoyerNonTransformeAIP();
        Test.stopTest();
    }
}