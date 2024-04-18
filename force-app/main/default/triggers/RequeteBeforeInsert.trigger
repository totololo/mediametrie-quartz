trigger RequeteBeforeInsert on Case (before insert) {
    list<Case> ListCases2 = new list<Case>();
	for(case newCase : Trigger.new) {
         

            if (newCase.Origin==Label.CAS_Origine_Email && newCase.AccountId==null && newCase.contactid==null ){
            	ListCases2.add(newCase);
            }
        }
        	if(ListCases2!=null && ListCases2.size()>0)
        {
            
           // AP01_Requete.associerCaseContact(ListCases2); 
            
        }
}