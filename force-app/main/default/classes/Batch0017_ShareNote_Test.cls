@isTest
public class Batch0017_ShareNote_Test {
	public static testMethod void Batch0017_ShareNote_Test(){
        
        contentNote note = new contentNote();
        note.Title='test'; 
        INSERT note;
            
       Test.startTest();
           
            batch0017_ShareNote btch = new batch0017_ShareNote();
            database.executeBatch(btch);
          
       Test.stopTest();     
	}

}