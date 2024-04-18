/*
* @Auteur Elia KARAM
* @date: 04/03/2022
* @Classe: BatchRDD01_FoyerPaneliste
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD01_FoyerPaneliste_Test {
    static testMethod void testMethod1() {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++) {
            Account acc = new Account();
            acc.Name ='Name'+i;
            acc.Type_de_foyer__c = Label.ACC_Type_de_panel_PaME;
            acc.Numero_de_portable__c = '0123456789';
            //acc.Date_de_derniere_commande__c = 2020/10/01;
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();
        
        BatchRDD01_FoyerPaneliste obj = new BatchRDD01_FoyerPaneliste();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
    }
}