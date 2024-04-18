/*
* @author: Marliatou D.
* @date: 24/01/2023
* @ Description Batch RDD des équipements du foyer sur les actions
* @TestClass: BatchRDD14_RemplirEquipementAction_Test
* @Coverage: 100 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/


public class BatchRDD14_RemplirEquipementAction implements Database.Batchable<sObject>, Database.Stateful {
    
     public List<WorkOrderLineItem> start(Database.BatchableContext bc) {
        
        List<WorkOrderLineItem> ActionList = new List<WorkOrderLineItem>();
        
        ActionList = [SELECT Id, Equipement__c, Equipement_du_foyer__c, Foyer__c, Equipement__r.ASS_ExtId_SIPanel__c    
                            FROM WorkOrderLineItem WHERE Equipement__c != null AND Foyer__c != null AND Equipement_du_foyer__c = null];
        
        return ActionList;
    }
    
    public void execute(Database.BatchableContext bc, List<WorkOrderLineItem> scope) {
        
        List<Id> AccountIdList = new List<Id>();
        List<String> postExtIdList = new List<String>();
        List<Equipements_du_foyer__c> equipementDuFoyerList = new List<Equipements_du_foyer__c>();
        Map<String, Id> equipementFoyerMap = new Map<String, Id>();
        
        for (WorkOrderLineItem action: scope) {
            postExtIdList.add(action.Equipement__r.ASS_ExtId_SIPanel__c);
        }
        
        equipementDuFoyerList = [SELECT Id, Uuid_Poste__c, type__c
                                 FROM Equipements_du_foyer__c 
                                 WHERE Uuid_Poste__c IN :postExtIdList];
        
        for (Equipements_du_foyer__c eqtFoyer: equipementDuFoyerList) {
            System.debug('$$$eqtFoyer.Type__c: ' + eqtFoyer.Type__c);
            equipementFoyerMap.put(eqtFoyer.Uuid_Poste__c, eqtFoyer.Id);
        }
        
        for(WorkOrderLineItem action: scope) {
            System.debug('$$$equipementFoyerMap.get(action.Equipement__r.ASS_ExtId_SIPanel__c ): '+ equipementFoyerMap.get(action.Equipement__r.ASS_ExtId_SIPanel__c ));
            if(equipementFoyerMap.get(action.Equipement__r.ASS_ExtId_SIPanel__c ) != null) {
                action.Equipement_du_foyer__c = equipementFoyerMap.get(action.Equipement__r.ASS_ExtId_SIPanel__c );
            }
        }        
        
        if(scope.size() > 0 && scope != null) {
            //Update scope;
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Remplacement des équipements sur les actions Exception Error:' + ex.getmessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext BC) {}


}