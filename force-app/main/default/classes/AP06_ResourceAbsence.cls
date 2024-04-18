/*
* @author: Youssef Hamrouni
* @date: 16/08/2021
* @ Description: cette classe interdit de déposer une absence sur la mm plage horaire d'un rdv
* @TestClass: AP06_ResourceAbsence_Test
* @Coverage: 95%
* History
* 
*/
public class AP06_ResourceAbsence {
public static void InsertAbsence(list<ResourceAbsence> listeAb ) {

   list<id> SaListeId = new list<id>();
   list<id> Idliste = new list<id>();
   for (ResourceAbsence ab:listeAb){
        Idliste.add(ab.ResourceId);
            }
    list<AssignedResource> ListeAR= [select id,ServiceAppointmentId,ServiceResourceId from AssignedResource where ServiceResourceId in: Idliste ];
    map<id,list<id>> MapRDV = new map<id, list<id>>();
   
    system.debug(Idliste);
    system.debug(ListeAR.size());
    for (ResourceAbsence absence: listeAb){
        list<id> ServiceAppointmentIds= new list<id>();
        
    	for (AssignedResource a:ListeAR){
            if (a.ServiceResourceId==absence.ResourceId){
                ServiceAppointmentIds.add(a.ServiceAppointmentId);
                SaListeId.add(a.ServiceAppointmentId);
            }
       		
        }
            MapRDV.put(absence.ResourceId,ServiceAppointmentIds);
    }
    system.debug(MapRDV.values());
    
    
    list<ServiceAppointment> listeRDV= [select id,SchedStartTime,SchedEndTime from ServiceAppointment where id in:SaListeId ];
    map<id,ServiceAppointment> mapSA = new map<id,ServiceAppointment>();
    for(ServiceAppointment rdv:listeRDV){
       mapSA.put(rdv.id,rdv);
    }
    for (ResourceAbsence ab:listeAb){ 
        list<id> listeRdvs = new list<id>();
       
  		listeRdvs=mapRDV.get(ab.ResourceId);
        for (id rdvid:listeRdvs){
            
            ServiceAppointment sa = mapSA.get(rdvid);
            system.debug(ab.start);
            system.debug(ab.end);
            system.debug(sa.SchedStartTime);
            system.debug(sa.SchedEndTime);
            if ((ab.start >= sa.SchedStartTime && ab.start <= sa.SchedEndTime) || (ab.End>= sa.SchedStartTime && ab.End <= sa.SchedEndTime) ||( ab.Start<=sa.SchedStartTime && ab.End>=sa.SchedEndTime)){
                system.debug('test2');
                ab.addError(system.label.RA_Message_Erreur);
                
            }
        }
    
    }   
}
}