trigger AssignedResourceAfterInsert on AssignedResource (after insert) {
    // deactivated after SF fixed the issue - Sept 21, 2021
    /*
    if(PAD.canTrigger('AP01_UpdatescheduledDate'))
    {
        list<AssignedResource> ListAR= new List<AssignedResource>();
        for(AssignedResource AssRes :Trigger.new)
        {
            system.debug('AssRes.EstimatedTravelTime###'+AssRes.EstimatedTravelTime);
            if(AssRes.EstimatedTravelTime!=null)  
            {
                ListAR.add(AssRes);
            }
        }
        if(ListAR!=null && ListAR.size()>0)
        {
            AP01_UpdatescheduledDate.updateSAScheduleDates(ListAR);
        }
    }
    */
}