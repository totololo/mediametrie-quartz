/*
* @author: XXXX
* @date: XXXX
* @ Description trigger that launches after Equipemetn du foyer are updated
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>		   <Author> 	 	  <Description of modification>
*     11/08/2023				Claire VEHRLE			Envoie Suppression à Nielsen
*/
trigger EquipementDuFoyerTriggerAfterDelete on Equipements_du_foyer__c (after delete) {
    if(PAD.canTrigger('AP01_EquipementDuFoyer')) {
        AP01_EquipementDuFoyer.evaluateEquipementPositionDelete(trigger.oldMap);
    }
    
    if(PAD.canTrigger('AP04_EquipementDuFoyer')) {
        Set<Id> foyerIdList = new Set<Id>();
        
        for(Equipements_du_foyer__c eqtFoyer:Trigger.old) {
            foyerIdList.add(eqtFoyer.foyer__c);
        }
        
        if(foyerIdList.size() > 0 && foyerIdList != null) {
            AP04_EquipementDuFoyer.suppressionEqtFoyer(foyerIdList); 
        }
        
    }
}