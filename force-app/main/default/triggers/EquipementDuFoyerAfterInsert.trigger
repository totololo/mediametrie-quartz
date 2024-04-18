/*
* @author: Claire VEHRLE
* @date: 17/08/2023
* @ Description trigger that launches after Equipement du foyer are inserted
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>		   <Author> 	 	  <Description of modification>
*/
trigger EquipementDuFoyerAfterInsert on Equipements_du_foyer__c (after insert) {
    
    if(PAD.canTrigger('AP05_EquipementDuFoyer')) {
        Map<Id, List<Equipements_du_foyer__c>> foyerEqtFoyerMap = new Map<Id, List<Equipements_du_foyer__c>>();
        
        for(Equipements_du_foyer__c eqtFoyer:Trigger.new) {
            if(foyerEqtFoyerMap.get(eqtFoyer.foyer__c) != null) {
                foyerEqtFoyerMap.get(eqtFoyer.foyer__c).add(eqtFoyer);
            }
            else {
                foyerEqtFoyerMap.put(eqtFoyer.foyer__c, new List<Equipements_du_foyer__c>{eqtFoyer});
            }
        }
        if(foyerEqtFoyerMap != null){
            AP05_EquipementDuFoyer.creationEqtFoyerSuFoyerPanMesurePlateForme(foyerEqtFoyerMap);
        }
    }
}