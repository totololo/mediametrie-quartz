/*
* @date: 25/11/2022
* Déclencheur à la modification "before"
* Description :
* @version 1.00   
* @Auteur Bastien Pinard
* <Date of modification>   			<Author>   		 <Description of modification>
*/
trigger FoyerPanelisteBeforeUpdate on Foyer_paneliste__c (before update) {
    if(PAD.canTrigger('AP09_FoyerPaneliste')) {
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        List<Referentiel_Panel__c> refPanMMPaME = [SELECT Id, Name, Type_de_panel__c FROM Referentiel_Panel__c WHERE Type_de_panel__c=:label.RFP_TypePanel_MMAT OR Type_de_panel__c=:label.RFP_TypePanel_PaME];
        Map<String, Id> mapRefPan = new Map<String, Id>();
        for(Referentiel_Panel__c ref : refPanMMPaME){
            if(ref.Type_de_panel__c==label.RFP_TypePanel_MMAT){
                mapRefPan.put('MMT',ref.Id); 
            } else if(ref.Type_de_panel__c==label.RFP_TypePanel_PaME){
                mapRefPan.put('PAME',ref.Id); 
            }
        }
        for(Foyer_paneliste__c Pan :Trigger.new){
            if(
                Pan.Statut_Foyer_Paneliste__c != Trigger.oldMap.get(Pan.id).Statut_Foyer_Paneliste__c &&
                Pan.Statut_Foyer_Paneliste__c==label.PAN_Statut_Panel_Installe &&
                (Pan.Referentiel_Panel__c == mapRefPan.get('MMT') ||
                 Pan.Referentiel_Panel__c == mapRefPan.get('PAME'))
            ) {                
                foyerPanelisteList.add(Pan);
            }
        }
        if(foyerPanelisteList.size()>0 && foyerPanelisteList != null){
            AP09_FoyerPaneliste.newIdFoyer(foyerPanelisteList);
        }
    }
    
    
}