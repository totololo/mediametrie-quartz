/**
*Planification du batch Batch018_FoyerAnonymisation
String CRON_EXP = '0 0 1 ? * * *';
String description = 'Batch018_FoyerAnonymisation';
System.schedule(description, CRON_EXP, new SCHD018_FoyerPanAnonymisationConfirm());
*** Quotidienne 01:00 ***

*/
public with sharing class SCHD018_FoyerPanAnonymisationConfirm implements Schedulable  {
    
    public SCHD018_FoyerPanAnonymisationConfirm() {
    }

    public void execute(SchedulableContext sc){
        database.executeBatch(new Batch018_FoyerAnonymisation());
    }
}