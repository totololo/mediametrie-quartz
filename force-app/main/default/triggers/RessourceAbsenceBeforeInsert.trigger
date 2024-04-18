trigger RessourceAbsenceBeforeInsert on ResourceAbsence (before insert) {
 
    list<ResourceAbsence> ListRA = new list<ResourceAbsence>();
    for (ResourceAbsence ab:trigger.new){
        if (ab.type !=label.RA_Type_PauseDej ){
            ListRA.add(ab);
        }
    }
    if(PAD.canTrigger('AP06_ResourceAbsence')){
        if (ListRA.size()>0 && ListRA  !=null){
	        AP06_ResourceAbsence.InsertAbsence(trigger.new);
        }
    }
    
}