trigger ServiceAppointmentBeforeUpdate on ServiceAppointment (before update, before insert) {
    
    if(PAD.canTrigger('AP02_UpdateTraficOnServiceAppointment')) {
        if(trigger.isupdate && trigger.isbefore){
            for (ServiceAppointment sa : trigger.new){
                if(trigger.oldMap.get(sa.id).status =='À planifier' && sa.status=='Planifié'){
                    sa.Tech_StatutSA__c=true;
                }
            }
            
            System.debug('in trigger'+AP02_ServiceAppointment_RecursiveHandler.runNumber);
            if(!AP02_ServiceAppointment_RecursiveHandler.schedStartDateUpdated){
                //AP02_UpdateTraficOnServiceAppointment.updateSchedDate(trigger.new, trigger.oldMap);
            }
        }  
    }
    
    if(PAD.canTrigger('AP08_ServiceAppointment')) {
        
        
        if((trigger.isupdate || trigger.isinsert) && trigger.isbefore){         
            for(ServiceAppointment SA:trigger.new){
                if(!system.isBatch())
                {
                    SA.tech_schedualdate__c = String.valueOf(SA.SchedStartTime?.format('HH:mm:SS'));
                }
            }
            AP08_ServiceAppointment.RoundSchedStart(trigger.new);
        } 
    }
    
    
    
    
    
}