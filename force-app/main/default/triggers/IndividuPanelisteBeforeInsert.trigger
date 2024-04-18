/*
* @date: 28/11/2022
* Déclencheur à la modification "before"
* Description :
* @version 1.00   
* @Auteur Bastien Pinard
* <Date of modification>   			<Author>   		 <Description of modification>
*/
trigger IndividuPanelisteBeforeInsert on Individu_Paneliste__c (before insert) {
    if(PAD.canTrigger('AP08_IndividuPaneliste')) {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            System.debug('$$$IndividuPanelisteBeforeUpdate AP08_IndividuPaneliste');
        List<Individu_Paneliste__c> ListNewIndPan  = new List<Individu_Paneliste__c>();
		Set<Id> setIndPan = new Set<Id>();
        for(Individu_Paneliste__c ind : Trigger.new){
            setIndPan.add(ind.Foyer_paneliste__c);
        }
        
        Map<Id, Foyer_paneliste__c> mapFoyerPan = new Map<Id, Foyer_paneliste__c>([SELECT Id, Referentiel_Panel__r.Type_de_panel__c, Statut_Foyer_paneliste__c FROM Foyer_paneliste__c WHERE Id IN:setIndPan AND Identifiant_foyer_pame__c!=:null AND Referentiel_Panel__r.Type_de_panel__c =:label.RFP_TypePanel_PaME]);
        
        
        for(Individu_Paneliste__c ind :Trigger.new){

            if(mapFoyerPan.get(ind.Foyer_paneliste__c) != null) {
            System.debug('$$$IndividuPanelisteBeforeUpdate AP08_IndividuPaneliste if');
                ListNewIndPan.add(ind);
            }
        }
        if(ListNewIndPan.size()>0 && ListNewIndPan != null){
            System.debug('$$$IndividuPanelisteBeforeUpdate AP08_IndividuPaneliste ListNewIndPan : ' + ListNewIndPan);
            AP08_IndividuPaneliste.newIndividuPaneliste(ListNewIndPan);
        }
    }
}