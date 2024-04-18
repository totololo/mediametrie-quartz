/*
* @author: Claire VEHRLE
* @date: 27/10/2022
* @ Description trigger that launches after the Intervention
* @TestClass: AP01_WorkOrderTest
* @Coverage: 100 %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
*/
trigger InterventionAfterInsert on WorkOrder (After insert) {
    
    if(PAD.canTrigger('AP01_WorkOrder')) {
        List<WorkOrder> ListWorkOrder = new List<WorkOrder>();
        for(WorkOrder wo :trigger.New){
            if(wo.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Installation || wo.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Desinstallation){
                ListWorkOrder.add(wo);
            }
        }
        if (ListWorkOrder != null && ListWorkOrder.size()>0){
            AP01_WorkOrder.NewWorkOrderLineItems(ListWorkOrder);
        }
    } 
    
   
}