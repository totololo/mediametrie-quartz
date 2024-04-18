/*
* @author: Claire VEHRLE
* @date: 10/08/2023
* @ Description trigger that launches after the StatutDevice are updated
* @TestClass: 
* @Coverage:  %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/

trigger StatutDeviceAfterUpdate on Statut_Device_Equipement_Mesure__c (after update) {

    if(PAD.canTrigger('AP01_Statut_Device')) {
        
        AP01_Statut_Device.updateStatutDeviceNielsen(Trigger.new, Trigger.oldMap);
        
    }
}