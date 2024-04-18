/*
* @author: Elia Karam
* @date: 09/03/2022
* @ Description Batch pour la RDD de l'objet Requête
* @TestClass: BatchRDD07_Etiquette
* @Coverage: 100 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD07_Etiquette implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
                
        return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer_Paneliste__c FROM Etiquette__c WHERE Foyer_Paneliste__c = null]);
    }
    
    public void execute(Database.BatchableContext bc, List<Etiquette__c> scope) {
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>();
        foyerFoyerPanelisteMap = getFoyerFoyerPaneliste();
        for(Etiquette__c etiquette: scope) {
            System.debug('$$$etiquette: ' + etiquette);
            if (etiquette.Foyer__c != null ) {
                etiquette.Foyer_Paneliste__c = foyerFoyerPanelisteMap.get(etiquette.Foyer__c);
            }
            else {
                etiquette.Foyer_Paneliste__c = null;
            }
        }
        
        if(scope.size() > 0 && scope != null) {
            //Update scope;
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Etiquette Exception Error:' + ex.getmessage());
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