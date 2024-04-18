/*
* Déclencheur apex : Equipements_du_foyer__c
* @version 1.00   29/04/2022
* @Auteur Téoman Sertçelik 
*/

trigger EquipementDuFoyerTrigger on Equipements_du_foyer__c (after insert, before delete) {

    /*if(PAD.canTrigger('AP01_EquipementDuFoyer')) {
        if (Trigger.isAfter) {

            if (Trigger.isInsert) {
                AP01_EquipementDuFoyer.evaluateEquipementPosition(trigger.New, null); //trigger.oldMap null 
            }
             else if (Trigger.isUpdate) {
                AP01_EquipementDuFoyer.evaluateEquipementPosition(trigger.New, trigger.oldMap);
            }
           
        }
        else if(Trigger.isBefore){
            
            if (Trigger.isDelete){
                //AP01_EquipementDuFoyer.evaluateEquipementPositionDelete(trigger.New, trigger.oldMap);
            } 
        }
    }*/
}