/*
* @author: Bastien Pinard
* @date: 22/12/2022
* @ Description 
* @TestClass: BatchRDD013_Conventions_Test
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD13_ConventionsIndividu implements Database.Batchable<sObject> { 
    
    public Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, composition_du_foyer__r.Signature_convention_individuelle_meter__c, foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c,
            foyer_paneliste__c, name, composition_du_foyer__r.AccountId, composition_du_foyer__r.age__c, foyer_paneliste__r.Foyer__r.personne_de_reference__c
            FROM Individu_Paneliste__c 
            WHERE composition_du_foyer__r.Signature_convention_individuelle_meter__c != null
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Individu_Paneliste__c> scope) {
        List<Referentiel_convention__c> refConvList = [SELECT Id, Referentiel_Panel__r.Type_de_panel__c, Type_de_la_convention__c  
                                                       FROM Referentiel_convention__c 
                                                       WHERE Statut__c=:label.Ref_Conv_Statut_Actif];
        
        List<Convention__c> conventionToInsertList = new List<Convention__c>();
        List<Contact> compositionFoyerList = new List<Contact>();
        Map<Id, Id> individuPanelisteIdCompositionFoyerIdMap = new Map<Id, Id>();
        for(Individu_Paneliste__c indPan: scope) {
            if(indPan.foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_AIP) {
                if(indPan.composition_du_foyer__r.age__c >= 18) {
                    individuPanelisteIdCompositionFoyerIdMap.put(indPan.foyer_paneliste__c, indPan.composition_du_foyer__c);
                }
                else {
                    individuPanelisteIdCompositionFoyerIdMap.put(indPan.foyer_paneliste__c, indPan.foyer_paneliste__r.Foyer__r.personne_de_reference__c);
                }
            }
        }
        
        for(Individu_Paneliste__c indPan: scope) {
            Convention__c convention = new Convention__c();
            //Convention Individu PaME
            if (indPan.foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_PaME) {
                for(Referentiel_convention__c refConv : refConvList){
                    if(refConv.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_PaME && refConv.Type_de_la_convention__c == Label.RFC_Type_Convention_Individu){
                        convention.Referentiel_convention__c = refConv.Id;
                    }
                }
                convention.name = 'Convention Individu ' +  indPan.name;
                convention.composition_du_Foyer__c = indPan.Composition_du_Foyer__c;
                convention.Individu_Paneliste__c = indPan.Id;
                convention.Date_de_signature_de_la_convention__c = indPan.composition_du_foyer__r.Signature_convention_individuelle_meter__c;
                convention.Type_de_signature__c = Label.RFC_Type_Signature_Electronique;
                
            }
            
            conventionToInsertList.add(convention);
        }
                
        if(conventionToInsertList.size() > 0 && conventionToInsertList != null) {
            try{ 
                database.insert(conventionToInsertList, true);
            }Catch(exception ex){
                system.debug('Insert convention Exception Error:' + ex.getmessage());
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
    }
}