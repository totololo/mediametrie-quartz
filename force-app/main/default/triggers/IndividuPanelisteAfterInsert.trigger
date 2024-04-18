/*
* @author: Claire VERLE
* @date: 25/02/2022
* @ Description trigger that launches Before the Individu Panéliste are inert
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*  		25/02/2022				Jérôme HE		AJout du lien meter google
*/
trigger IndividuPanelisteAfterInsert on Individu_paneliste__c (after insert) {
    
    if(PAD.canTrigger('AP01_IndividuPaneliste')) {
        List<String> idList = new List<String>();
        for(Individu_Paneliste__c indPan : Trigger.New){
            System.debug('$$$name ' + indPan.name);
            System.debug('$$$lettre ' + indPan.lettre__c);
            if(indPan.ID_Google__c != null) {
                idList.add(indPan.id);
            }
        }
        
        if(Trigger.isInsert){
            if(System.IsBatch() == false && System.isFuture() == false && idList != null && idList.size() > 0){ 
                AP01_IndividuPaneliste.provisioningGoogleFlow(idList);
            }
            
        }
    }
    
    if(PAD.canTrigger('AP06_IndividuPaneliste')) {
        
        /*Map<Individu_Paneliste__c, Foyer_paneliste__c> associationIndividuFoyerPaneliste = new Map<Individu_Paneliste__c, Foyer_paneliste__c>(); 
        List<Id> individuPanelisteIdList = new List<Id>();
        List<Individu_Paneliste__c> individuPanelisteToCheck = new List<Individu_Paneliste__c>();
        String erreur = '';
        
        for(Individu_Paneliste__c individuPaneliste: Trigger.New) {
            individuPanelisteIdList.add(individuPaneliste.Id);
        }
        
        System.debug('$$$ individuPanelisteIdList: ' + individuPanelisteIdList);
        
        individuPanelisteToCheck = [SELECT Composition_du_foyer__r.AccountId, Foyer_paneliste__r.Foyer__c, Type_de_Panel__c, Composition_du_foyer__r.Name,
                                    Composition_du_foyer__c, Foyer_paneliste__r.Name, Foyer_paneliste__r.referentiel_panel__r.Type_de_Panel__c, Foyer_paneliste__r.referentiel_panel__r.Name
                                    FROM Individu_Paneliste__c WHERE Id IN :individuPanelisteIdList];
        
        System.debug('$$$ individuPanelisteToCheck: ' + individuPanelisteToCheck);
        
        associationIndividuFoyerPaneliste = AP06_IndividuPaneliste.findIndividuPaneliste(individuPanelisteToCheck);
        
        
        if(!associationIndividuFoyerPaneliste.isEmpty()) {
            for (Individu_Paneliste__c individuPaneliste: associationIndividuFoyerPaneliste.KeySet()) {
                
                System.debug('$$$ individuPaneliste.Foyer_paneliste__r.Name: ' + individuPaneliste.Foyer_paneliste__r.Name);
                System.debug('indPan association foyer pan : ' + associationIndividuFoyerPaneliste.get(individuPaneliste));
                if(associationIndividuFoyerPaneliste.get(individuPaneliste) == null) {
                    erreur = erreur + 'Il n\'y a pas de Foyer Panéliste pour ce type de panel sur le Foyer de la composition du foyer choisie';
                }
                else {
                    erreur = erreur + '\n Le Foyer Panéliste correspondant à la composition du foyer ' + individuPaneliste.Composition_du_foyer__r.Name + ' (' + individuPaneliste.Composition_du_foyer__c + ') '+
                        'est le Foyer Panéliste: ' + associationIndividuFoyerPaneliste.get(individuPaneliste).Name + ' (' + associationIndividuFoyerPaneliste.get(individuPaneliste).Id + '). ';
                    
                }
                
            }
            System.debug('$$$ erreur: ' + erreur);
            Trigger.New[0].addError(erreur);
        }*/
    } 
    
    //added Téoman Sertçelik
    if(PAD.canTrigger('AP03_IndividuPaneliste') && !Userinfo.getUserName().Contains(Label.User_Technique_Username)) {
        AP03_IndividuPaneliste.indPanAEnvoyerAMulesoftInsert(Trigger.new);
    }
    
    if(PAD.canTrigger('AP07_IndividuPaneliste')) {
        AP07_IndividuPaneliste.checkIndividuPaneliste(Trigger.new);
    }
}