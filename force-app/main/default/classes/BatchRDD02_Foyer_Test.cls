/*
* @Auteur Elia KARAM
* @date: 02/03/2022
* @Classe: BatchRDD02_Foyer
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD02_Foyer_Test {
    static testMethod void testMethod1() {
        List<Account> lstAccount= new List<Account>();
        
        Account foyer = new Account();
        foyer.Name ='Name1234';
        foyer.ShippingStreet='rue stalingrad';
        lstAccount.add(foyer);
        
        insert lstAccount;
        Account foyer1 = new Account();
        foyer1.Name ='Name12345';
        foyer1.ShippingStreet='rue stalingrad1';
        foyer1.Type_de_foyer__c = Label.ACC_Type_de_panel_AIP;
        lstAccount.add(foyer1);
        
        insert foyer1;
        
        List<Contact> contactToInsert = new List<Contact>();
        Contact compoFoyer = Test_Utils.createMembreFoyer(foyer.id); 
        compoFoyer.Lien_parente__c = 'Conjoint';
        compoFoyer.LastName = 'DUPONTT';
        contactToInsert.add(compoFoyer);
        
        
        Contact compoFoyer1 = Test_Utils.createMembreFoyer(foyer.id); 
        compoFoyer1.Lien_parente__c = 'Conjoint';
        compoFoyer1.LastName = 'DUPONT';
        contactToInsert.add(compoFoyer1);
        
        insert contactToInsert;
        
        foyer.Personne_de_reference__c = compoFoyer.Id;
        
        update foyer;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer.id));
        BatchRDD02_Foyer obj = new BatchRDD02_Foyer();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}