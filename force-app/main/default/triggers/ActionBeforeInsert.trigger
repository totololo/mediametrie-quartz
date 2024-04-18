/*
* @author: Claire VEHRLE
* @date: 27/10/2022
* @ Description trigger that launches after the Actions
* @TestClass: AP01_WorkOrderTest
* @Coverage: 100 %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/
trigger ActionBeforeInsert on WorkOrderLineItem (before insert) {

    if(PAD.canTrigger('AP01_WorkOrder')) {
        AP01_WorkOrder.UpdateDurationWorkOrderLineItems(trigger.New);
    }
    
}