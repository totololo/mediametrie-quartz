/*
*Planification du batch Batch0017_ShareNote
String CRON_EXP = '0 0 21 ? * * *';
String description = 'batch0017_ShareNote';
System.schedule(description, CRON_EXP, new SCHD0017_ShareNote());
*** Quotidienne 21:00 ***

* @author: YH
* @date: 13/06/2022
* @Test: SCHD0014_UpdateConge_Test
* @Coverage: 100 %
*/
global without sharing class SCHD0017_ShareNote implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new batch0017_ShareNote());
    }
}