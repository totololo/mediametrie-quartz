/*
* @author: Claire VEHRLE
* @date: 08/03/2022
* @ Description Batch pour la RDD de l'objet Contrôle
* @TestClass: BatchRDD06_Controle_Test
* @Coverage: 95 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/ 
public class BatchRDD06_Controle implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(Test.isRunningTest()){
            return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer_Paneliste__c, RecordTypeId FROM Controle__c
                                             WHERE foyer_paneliste__c != null 
                                             AND (Foyer__r.Type_de_foyer__c = :Label.ACC_Type_de_panel_PaME OR Foyer__r.Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat)]);
        }
        else{
            return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer_Paneliste__c, RecordTypeId FROM Controle__c
                                             WHERE foyer_paneliste__c = null 
                                             AND (Foyer__r.Type_de_foyer__c = :Label.ACC_Type_de_panel_PaME OR Foyer__r.Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat)]);
        }
    }
    
    public void execute(Database.BatchableContext bc, List<Controle__c> scope) {
        
        Map<Id, Id> foyerFoyerPanelisteMap = new Map<Id, Id>();
        Id recordTypeIdMMATPaME = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        foyerFoyerPanelisteMap = getFoyerFoyerPaneliste();
        for(Controle__c controle: scope) {
            controle.RecordTypeId = recordTypeIdMMATPaME;
            if (controle.Foyer__c != null ) {
                controle.Foyer_Paneliste__c = foyerFoyerPanelisteMap.get(controle.Foyer__c);
            }
            else {
                controle.Foyer_Paneliste__c = null;
            }
        }
        
        if(scope.size() > 0 && scope != null) {
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Contrôle Exception Error:' + ex.getmessage());
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