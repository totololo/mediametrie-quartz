/*
* @author: Elia Karam
* @date: 09/03/2022
* @ Description Batch pour la RDD de l'objet Requête
* @TestClass: BatchRDD08_Fidelisation
* @Coverage: 88 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD08_Fidelisation implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(Test.isRunningTest()){
             return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer_Paneliste__c FROM Fidelisation__c WHERE Foyer_Paneliste__c != null]);
            }
            else{
                return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer_Paneliste__c FROM Fidelisation__c WHERE Foyer_Paneliste__c = null]);
            }
        
    }
    
    public void execute(Database.BatchableContext bc, List<Fidelisation__c> scope) {
        
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>();
        foyerFoyerPanelisteMap = getFoyerFoyerPaneliste();
        for(Fidelisation__c fidelisation: scope) {
            if (fidelisation.Foyer__c != null ) {
                fidelisation.Foyer_Paneliste__c = foyerFoyerPanelisteMap.get(fidelisation.Foyer__c);
            }
            else {
                fidelisation.Foyer_Paneliste__c = null;
            }
        }
        
        if(scope.size() > 0 && scope != null) {
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Fidelisation Exception Error:' + ex.getmessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
    
    public Map<Id, Id> getFoyerFoyerPaneliste() {
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        Id recordTypeIdMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>(); 
        
        foyerPanelisteList = [SELECT Id, Foyer__c FROM Foyer_paneliste__c WHERE RecordTypeId = :recordTypeIdMMATPaME];
        
        for(Foyer_paneliste__c foyerPaneliste: foyerPanelisteList) {
            foyerFoyerPanelisteMap.put(foyerPaneliste.Foyer__c, foyerPaneliste.Id);
        }
        
        return foyerFoyerPanelisteMap;
    }
    
   
}