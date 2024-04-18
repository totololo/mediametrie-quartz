/*
* @author: Claire VEHRLE
* @date: 02/03/2023
* @ Description Batch pour la RDD de l'objet Action. Remplissage Foyer
* @TestClass: BatchRDD10_RDVService_Test
* @Coverage: 91 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD15_Action  implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        
        return Database.getQueryLocator([SELECT Id, WorkOrder.Foyer_Paneliste__c, Foyer_Paneliste__c, Sous_type_d_intervention__c, Actions__c 
                                         FROM WorkOrderLineItem WHERE Foyer_Paneliste__c = null]);
        
    }
    
    public void execute(Database.BatchableContext bc, List<WorkOrderLineItem> scope) {
        System.debug('$$$scope: ' + scope);
        for(WorkOrderLineItem action: scope) {
            System.debug('$$$action.WorkOrder.Foyer_Paneliste__c: ' + action.WorkOrder.Foyer_Paneliste__c);
            action.actions__c = action.Sous_type_d_intervention__c;
            if (action.WorkOrder.Foyer_Paneliste__c != null ) {
                System.debug('$$$ foyer Paneliste non null');
                action.Foyer_Paneliste__c = action.WorkOrder.Foyer_Paneliste__c;
            }
            else {
                action.Foyer_Paneliste__c = null;
            }
        }
        if(scope.size() > 0 && scope != null) {
            System.debug('$$$Update scope');
            //Update scope;
            try{ 
                database.update(scope, false);
                System.debug('Nscope' + scope);
            }Catch(exception ex){
                system.debug('Update Action Exception Error:' + ex.getmessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
    
}