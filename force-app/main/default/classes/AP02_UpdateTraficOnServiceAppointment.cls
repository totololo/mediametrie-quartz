public class AP02_UpdateTraficOnServiceAppointment {
    
    public static void updateSchedDate (list<ServiceAppointment> listeSa, Map<Id,ServiceAppointment> oldSAs){
        
        set<Id> serviceAppointmentIds = new Set<Id>();
        set<String> traficAddedToQuery = new Set<String>();
        Integer i;
        String arrivingTime;
        
        system.debug('listeSa' + listeSa);
        system.debug('listeSa' + listeSa[0].SchedStartTime);
        
        for (ServiceAppointment sa : listeSa){
            if(sa.SchedStartTime!=null ){
                system.debug('sa.SchedStartTime' + sa.SchedStartTime);
                system.debug('sa.Status first' + sa.Status);
                serviceAppointmentIds.add(sa.Id);
                i = sa.SchedStartTime.hour()+1 ; 
                arrivingTime = 'Entre ' + sa.SchedStartTime.hour() + ' et ' + i + ' H';
                traficAddedToQuery.add(sa.Departement__c + arrivingTime);                
            }
              
        }
        if(traficAddedToQuery!=null && traficAddedToQuery.size()>0 ){
            system.debug('traficAddedToQuery : ' + traficAddedToQuery);
            
            // map of Service App and its assigned resource
            Map<Id, List<AssignedResource>> mapSAAssignedResource = new Map<Id, List<AssignedResource>>();            
            for(AssignedResource ar : [SELECT id, ServiceAppointmentId, EstimatedTravelTime, ServiceAppointment.SchedStartTime, 
                                       ServiceAppointment.SchedEndTime, ServiceAppointment.Departement__c 
                                       FROM AssignedResource 
                                       WHERE ServiceAppointmentId in : serviceAppointmentIds]) {
                                           if(mapSAAssignedResource.containsKey(ar.ServiceAppointmentId)) {
                                               List<AssignedResource> aResource = mapSAAssignedResource.get(ar.ServiceAppointmentId);
                                               aResource.add(ar);
                                               mapSAAssignedResource.put(ar.ServiceAppointmentId, aResource);
                                           } else {
                                               mapSAAssignedResource.put(ar.ServiceAppointmentId, new List<AssignedResource> { ar });
                                           }
                                       }
            
            system.debug('mapSAAssignedResource : ' + mapSAAssignedResource);
            
            if(mapSAAssignedResource.size()>0  ){
                // map : key concatination variable , value : trafic added
                Map<String, Trafic_Added__c> mapKeyTrafic = new Map<String, Trafic_Added__c> ();
                for(Trafic_Added__c tr : [SELECT id,Added_Percentage__c, Arriving_Department__c, Arriving_Time__c,TECH_DEPARTMENT_ARRIVINGTIME__c
                                          FROM Trafic_Added__c 
                                          WHERE TECH_DEPARTMENT_ARRIVINGTIME__c in: traficAddedToQuery ]){
                                              //clé unique donc pas d'écrasement
                                              mapKeyTrafic.put(tr.TECH_DEPARTMENT_ARRIVINGTIME__c, tr);       
                                          }
                
                system.debug('mapKeyTrafic : '+mapKeyTrafic);
                
                for (ServiceAppointment sa : listeSa ){
                    
                    system.debug('sa.id ' + sa.id);
                    system.debug('mapSAAssignedResource '+ mapSAAssignedResource);
                    system.debug('mapSAAssignedResource.get(sa.Id) ' + mapSAAssignedResource.get(sa.Id));
                    
                    List<AssignedResource> listAR = mapSAAssignedResource.get(sa.Id);
                    system.debug('sa.SchedStartTime : '+sa.SchedStartTime);
                     

                    if(sa.SchedStartTime!=null ){
                         system.debug('sa.Status' + sa.Status);

                        i = sa.SchedStartTime.hour()+1 ; 
                        arrivingTime = 'Entre ' + sa.SchedStartTime.hour() + ' et ' + i + ' H';
                        Trafic_Added__c trafic = mapKeyTrafic.get(sa.Departement__c + arrivingTime);
                        if(trafic !=null){
                            //un service appointment a un toujours un seul assigned resource 
                            for ( AssignedResource resource : listAR){
                                if(resource.EstimatedTravelTime !=null){
                                Decimal addedTime = resource.EstimatedTravelTime *  (trafic.Added_Percentage__c)  /100;
                                system.debug('EstimatedTravelTime : '+resource.EstimatedTravelTime);
                                system.debug('Added_Percentage__c : '+trafic.Added_Percentage__c);
                                system.debug('addedTime : '+addedTime);
                                
                                sa.Trafic_Additionnel__c = addedTime ;
                                system.debug('sched start time before update : ' + resource.ServiceAppointment.SchedStartTime);
                                
                                resource.ServiceAppointment.SchedStartTime = resource.ServiceAppointment.SchedStartTime.addMinutes(Integer.valueof(addedTime));
                                	system.debug('new start time : ' + resource.ServiceAppointment.SchedStartTime);
                                resource.ServiceAppointment.SchedEndTime = resource.ServiceAppointment.SchedEndTime.addMinutes(Integer.valueof(addedTime));
                                   system.debug('sched start time after update : ' +sa.SchedStartTime);   
                                if(resource.EstimatedTravelTime!=0){
                                    AP02_ServiceAppointment_RecursiveHandler.schedStartDateUpdated = true;
                               	
                                }
                                }
                            }                     
                        }else {
                            sa.Trafic_Additionnel__c = 0 ;
                        } 
                    }
                }  
            }
        }
    }   
}