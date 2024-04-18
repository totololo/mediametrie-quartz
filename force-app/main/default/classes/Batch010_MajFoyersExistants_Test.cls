/*
* @author: Elissa Rafka
* @date: 11/08/2021
* @ Description Class that tests Batch010_MajFoyersExistants
* History
* <Date of modification>   <Author>    <Description of modification>
*/

@isTest
public class Batch010_MajFoyersExistants_Test {
    public static testMethod void Batch010_MajFoyersExistants(){
        list<Account> listFoyersToUpdate = new list<Account>();
        Id rTFoyerNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId();
        
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        testAccount.RecordTypeId = rTFoyerNonEquipe;
        listFoyersToUpdate.add(testAccount);
        
        account testAccount1 = Test_Utils.createFoyer();
        testAccount1.Numero_de_portable__c = '0611111121';
        testAccount1.RecordTypeId = rTFoyerNonEquipe;
        listFoyersToUpdate.add(testAccount1);
        
        insert listFoyersToUpdate;
        
        Test.startTest();
        Batch010_MajFoyersExistants btch = new Batch010_MajFoyersExistants();
        database.executeBatch(btch);
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id));
        Test.stopTest();
    }
}