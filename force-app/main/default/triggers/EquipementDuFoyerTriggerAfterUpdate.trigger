/*
* @author: XXXX
* @date: XXXX
* @ Description trigger that launches after Equipemetn du foyer are updated
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>		   <Author> 	 	  <Description of modification>
*     10/08/2023				Claire VEHRLE			Envoie modification à Nielsen
*/
trigger EquipementDuFoyerTriggerAfterUpdate on Equipements_du_foyer__c (after update) {
                
    if(PAD.canTrigger('AP02_EquipementDuFoyer')) {
        AP02_EquipementDuFoyer.UpdatePeripheriqueName(trigger.New, trigger.oldMap);      		
    }
    
    if(PAD.canTrigger('AP04_EquipementDuFoyer')) {
        AP04_EquipementDuFoyer.updateEquipementFoyer(trigger.New, trigger.oldMap);      		
    }
}