/*
* @author: Youssef Hamrouni
* @date: 24/09/2021
* @ Description Class that test BATCH012_Delete_Controle
* COVERAGE 100%
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest

public class Batch0013_delete_Evenement_Test {

    public static testMethod void Batch0013_delete_Evenement_Test(){
        
     String errorTxt = '';
    Boolean containsErrors = false;
    
        
        // create event
      list<Evenement__c> liste = new list<Evenement__c>();
       Evenement__c e = new Evenement__c();
       e.CreatedDate=system.today()-60;   
       e.Etat__c='TV_ON';
        liste.add(e);
        insert liste;
        system.debug('date test'+e.CreatedDate);
        system.debug('siz test'+liste.size());
        Test.startTest();
	 		
            Batch0013_Delete_Evenement obj = new Batch0013_Delete_Evenement();
            DataBase.executeBatch(obj); 
        Test.stopTest();
        
        list<Evenement__c> l = [select id from Evenement__c];
        system.debug('size test'+l.size());
        System.assertEquals(0,l.size(),'error');
        
    }
}