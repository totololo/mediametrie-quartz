/*
* @author: Maribelle ZARAZIR
* @date: 27/05/2021
* @ Description Class that test Batch00X_BatchModifiable 
*/

@isTest
public class Batch00X_BatchModifiable_Test {
    public static testMethod void Batch00X_CreditAutomatiqueTest(){
        
        //insert Account(foyer)
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Date_d_installation__c = date.newInstance(2021, 4, 21); //system.today()-60;
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;	 
        Test.startTest();
        Batch00X_BatchModifiable batch = new Batch00X_BatchModifiable();
        database.executeBatch(batch);
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Test.stopTest();
    }
}