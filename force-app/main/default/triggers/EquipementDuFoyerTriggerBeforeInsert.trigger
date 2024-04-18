trigger EquipementDuFoyerTriggerBeforeInsert on Equipements_du_foyer__c (before insert) {
    if(PAD.canTrigger('AP01_EquipementDuFoyer')) {
                AP01_EquipementDuFoyer.evaluateEquipementPosition(trigger.New);
    }
    
    if(PAD.canTrigger('AP02_EquipementDuFoyer')) {
                AP02_EquipementDuFoyer.EquipementName(trigger.New);
    }
}