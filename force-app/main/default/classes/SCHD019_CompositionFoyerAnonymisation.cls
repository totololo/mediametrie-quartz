/**
*Planification du batch Batch019_CompositionFoyerAnonymisation
String CRON_EXP = '0 0 2 ? * * *';
String description = 'Batch019_CompositionFoyerAnonymisation';
System.schedule(description, CRON_EXP, new SCHD019_CompositionFoyerAnonymisation());
*** Quotidienne 02:00 ***
*/
public with sharing class SCHD019_CompositionFoyerAnonymisation implements Schedulable {
    public SCHD019_CompositionFoyerAnonymisation() {

    }
    public void execute(SchedulableContext sc){
        database.executeBatch(new Batch019_CompositionFoyerAnonymisation());
    }
}