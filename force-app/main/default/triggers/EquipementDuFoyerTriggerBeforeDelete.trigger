trigger EquipementDuFoyerTriggerBeforeDelete on Equipements_du_foyer__c (before delete) {    
     if(PAD.canTrigger('AP03_EquipementDuFoyer')) {
                AP03_EquipementDuFoyer.DeleteEquipements(trigger.old);
    }

}