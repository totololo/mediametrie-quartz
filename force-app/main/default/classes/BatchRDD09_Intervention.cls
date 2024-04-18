/*
* @author: Claire VEHRLE
* @date: 09/03/2022
* @ Description Batch pour la RDD de l'objet Intervention
* @TestClass: BatchRDD09_Intervention_Test
* @Coverage: 95 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD09_Intervention implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([SELECT Id, AccountId, Foyer_Paneliste__c, sous_type_d_intervention__c, actions__c FROM WorkOrder WHERE Foyer_Paneliste__c = null]);
        
    }
    
    public void execute(Database.BatchableContext bc, List<WorkOrder> scope) {
        
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>();
        foyerFoyerPanelisteMap = getFoyerFoyerPaneliste();
        for(WorkOrder intervention: scope) {
            intervention.actions__c = intervention.sous_type_d_intervention__c;
            if (intervention.AccountId != null ) {
                intervention.Foyer_Paneliste__c = foyerFoyerPanelisteMap.get(intervention.AccountId);
            }
            else {
                intervention.Foyer_Paneliste__c = null;
            }
        }
        if(scope.size() > 0 && scope != null) {
            //Update scope;
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Intervention Exception Error:' + ex.getmessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
    
    public Map<Id, Id> getFoyerFoyerPaneliste() {
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>(); 
        Id recordTypeIdMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        foyerPanelisteList = [SELECT Id, Foyer__r.Id FROM Foyer_paneliste__c WHERE RecordTypeId = :recordTypeIdMMATPaME];
        
        for(Foyer_paneliste__c foyerPaneliste: foyerPanelisteList) {
            foyerFoyerPanelisteMap.put(foyerPaneliste.Foyer__r.Id, foyerPaneliste.Id);
        }
        
        return foyerFoyerPanelisteMap;
    }
    
}