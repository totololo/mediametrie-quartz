/*
* @author: Claire VEHRLE
* @date: 09/08/2023
* @ Description trigger that launches after the StatutDevice are insert
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/
trigger StatutDeviceAfterInsert on Statut_Device_Equipement_Mesure__c (after insert) {

    if(PAD.canTrigger('AP02_Statut_Device')) {
        if(Trigger.new.size()>0 && Trigger.new !=null){
            AP02_Statut_Device.autoIncrementIdDevice(Trigger.new);
        }
    } 
    
    if(PAD.canTrigger('AP01_Statut_Device')) {
        Set<Id> eqtFoyerIdList = new Set<Id>();
        for(Statut_Device_Equipement_Mesure__c statutDevice: Trigger.new) {
                eqtFoyerIdList.add(statutDevice.equipement_du_foyer__c);
        }
        
        if(Trigger.new.size()>0 && Trigger.new !=null){
            AP01_Statut_Device.creationStatutDeviceNielsen(eqtFoyerIdList);
        }
    }
        
}