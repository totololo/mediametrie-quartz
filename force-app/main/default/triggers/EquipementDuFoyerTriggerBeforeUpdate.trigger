trigger EquipementDuFoyerTriggerBeforeUpdate on Equipements_du_foyer__c (before update) {
list <Equipements_du_foyer__c> listtoupdate = new list <Equipements_du_foyer__c>();
    for (Equipements_du_foyer__c eq: trigger.new){
        if (eq.Fournisseur__c != trigger.oldMap.get(eq.id).Fournisseur__c){
            listtoupdate.add(eq);
        }
    }
    
    if (listtoupdate.size()>0){
        if(PAD.canTrigger('AP02_EquipementDuFoyer')) {
            AP02_EquipementDuFoyer.EquipementName(listtoupdate);
        }
    }
    
}