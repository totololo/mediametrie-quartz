global without sharing class SCHD025_MAJ_Etiquette implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch025_MAJ_Etiquette());
    }
    
}