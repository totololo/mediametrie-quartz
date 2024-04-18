/*
* @Auteur Calire VEHRLE
* @date: 02/06/2022
* @Classe: BatchRDD01_FoyerPanelisteAIP
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@IsTest
public class BatchRDD01_FoyerPanelisteAIP_Test {
    static testMethod void testMethod1() {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++) {
            Account acc = new Account();
            acc.Name ='Name'+i;
            acc.Type_de_foyer__c = '4';
            //acc.Date_de_derniere_commande__c = 2020/10/01;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();
        
        BatchRDD01_FoyerPanelisteAIP obj = new BatchRDD01_FoyerPanelisteAIP();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}