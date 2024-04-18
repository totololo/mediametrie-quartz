/*
* @author: Bastien Pinard
* @date: 19/12/2022
* @ Description Batch pour la RDD de l'objet Composition du foyer
* @TestClass: BatchRDD04_CompositionDuFoyer_Test
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD04_CompositionDuFoyer implements Database.Batchable<sObject> { 
    public Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Code_profession__c, CSP42__c, Date_de_suppression__c, Date_de_chute_individu__c 
            FROM Contact 
            WHERE (CSP42__c = null AND Code_profession__c != null) 
            OR (Date_de_chute_individu__c!=null AND Date_de_suppression__c=null)
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        for(Contact c : scope){            
            if(c.CSP42__c == null && c.Code_profession__c != null){
                String Csp42Value = String.valueOf(c.Code_profession__c);
                c.CSP42__c = Csp42Value.remove('.0');
            }

            if(c.Date_de_chute_individu__c != null && c.Date_de_suppression__c==null){
                c.Date_de_suppression__c = c.Date_de_chute_individu__c;
           }
        }
        
        if(scope.size() > 0 && scope != null) {
            Update scope;
            /*try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Composition du foyer Exception Error: ' + ex.getmessage());
            }*/
        }
    }
    
    public void finish(Database.BatchableContext bc) {
    }
}