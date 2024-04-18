public class AP01_UpdatescheduledDate {
public static void updateSAScheduleDates(list<AssignedResource> listAssignedResource) {
   Set<Id> IdSA = new Set<id>();
    map<Id,Decimal> MapTravelTimeSAid= New  map<Id,Decimal>();
     List<ServiceAppointment> ListSaRelated = new List<ServiceAppointment>();
     List<ServiceAppointment> ListSaRelatedToUpdate = new List<ServiceAppointment>();
    for(AssignedResource assRes:listAssignedResource)
    { 
        MapTravelTimeSAid.put( assRes.ServiceAppointmentId,assRes.EstimatedTravelTime);
    }
    if(MapTravelTimeSAid!=null && MapTravelTimeSAid.size()>0)
    {
    ListSaRelated=[select id,SchedStartTime,Duration,SchedEndTime from ServiceAppointment where ID IN:MapTravelTimeSAid.keyset()];
        }
    for(ServiceAppointment SA:ListSaRelated)
    {
        if(SA.SchedStartTime!=null)
        {
           SA.SchedStartTime=(SA.SchedStartTime).addMinutes(Integer.valueof(MapTravelTimeSAid.get(SA.id)));
            SA.SchedEndTime=SA.SchedStartTime.addMinutes(Integer.valueof(SA.Duration));
        ListSaRelatedToUpdate.add(SA);  
        }
     
    }
    if(ListSaRelatedToUpdate!=null && ListSaRelatedToUpdate.size()>0)
    {
        update ListSaRelatedToUpdate;
    }
}
}