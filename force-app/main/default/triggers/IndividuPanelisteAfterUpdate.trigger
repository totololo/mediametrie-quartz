/*
* @author: Jérôme HE
* @date: 25/02/2022
* @ Description 
* @TestClass: AP01_IndividuPaneliste_Test
* @Coverage: -- %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/ 
trigger IndividuPanelisteAfterUpdate on Individu_Paneliste__c (after update) {
    
    List<Id> individuPanelisteIdChute = new List<Id>();
    List<Individu_paneliste__c> individuPanelisteANePasChuter = new List<Individu_paneliste__c>();
    
    if(PAD.canTrigger('AP01_IndividuPaneliste')){
       //AP01_IndividuPaneliste.individuPanhandlerafterUpdate(Trigger.new,Trigger.old);
    }
    
    // MAK - Deprovisionning google 
    if(PAD.canTrigger('AP02_IndividuPaneliste')) {
        AP02_IndividuPaneliste.deprovisionningGoogle(Trigger.new, Trigger.oldMap);
    }
        
    if(PAD.canTrigger('AP07_IndividuPaneliste')) {
        AP07_IndividuPaneliste.checkIndividuPaneliste(Trigger.new);
    }
    
    if(PAD.canTrigger('AP04_IndividuPaneliste')) {
        for (Individu_paneliste__c indPan: Trigger.new) {
            if (Trigger.newMap.get(indPan.id).Date_de_chute_de_l_individu__c != null) {
                individuPanelisteIdChute.add(indPan.Id);
            }
        }
        
        if(individuPanelisteIdChute.size() != 0 && !individuPanelisteIdChute.isEmpty()) {
            individuPanelisteANePasChuter = AP04_IndividuPaneliste.empecherChuteCompositionFoyerMonopanel(individuPanelisteIdChute);
            
            for(Individu_paneliste__c indPan:individuPanelisteANePasChuter) {
                Trigger.New[0].addError('L\'individu paneliste ' + indPan.Name + ' (' + indPan.Id + ') ne peut pas être chuté. ' + 
                                        'Le foyer est monopanel ou les autres foyers panéliste sont chutés et qu\'il est le dernière ' +
                                       	'individu panéliste du foyer ou sa composition du foyer est le contact principale du foyer');
            }
        }
        
    }
    
    if(PAD.canTrigger('AP03_IndividuPaneliste') && !Userinfo.getUserName().Contains(Label.User_Technique_Username)) {
        if(System.IsBatch() == false && System.isFuture() == false){
        	AP03_IndividuPaneliste.indPanAEnvoyerAMulesoftUpdate(Trigger.new, Trigger.oldMap);
		}
    }
    
    
}