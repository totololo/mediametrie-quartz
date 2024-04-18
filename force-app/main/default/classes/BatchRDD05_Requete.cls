/*
* @author: Claire VEHRLE
* @date: 09/03/2022
* @ Description Batch pour la RDD de l'objet Requête
* @TestClass: BatchRDD05_Requete
* @Coverage: 95 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD05_Requete implements Database.Batchable<sObject> {

    public Database.Querylocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([SELECT Id, AccountId, Foyer_Paneliste__c FROM Case WHERE Foyer_Paneliste__c = null]);
    }
    
    public void execute(Database.BatchableContext bc, List<Case> scope) {
        
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>();
        foyerFoyerPanelisteMap = getFoyerFoyerPaneliste();
        for(Case requete: scope) {
            if (requete.AccountId != null ) {
                requete.Foyer_Paneliste__c = foyerFoyerPanelisteMap.get(requete.AccountId);
            }
            else {
                requete.Foyer_Paneliste__c = null;
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
        Id recordTypeIdMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>(); 
        
        foyerPanelisteList = [SELECT Id, Foyer__r.Id FROM Foyer_paneliste__c WHERE RecordTypeId = :recordTypeIdMMATPaME];
        
        for(Foyer_paneliste__c foyerPaneliste: foyerPanelisteList) {
            foyerFoyerPanelisteMap.put(foyerPaneliste.Foyer__r.Id, foyerPaneliste.Id);
        }
        
        return foyerFoyerPanelisteMap;
    }
    
}