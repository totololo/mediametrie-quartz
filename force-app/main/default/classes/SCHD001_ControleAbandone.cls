/*
*Planification du batch Batch001_ControleAbandone
String CRON_EXP = '0 0 22 ? * * *';
String description = 'Batch001_ControleAbandone';
String result = System.schedule(description, CRON_EXP, new SCHD001_ControleAbandone());
*** Quotidien 22:00 ***

* @author: JSA EI
* @date: 10/09/2020
* @Test: SCHD001_ControleAbandone_Test
* @Coverage: 100 %
*/
global without sharing class SCHD001_ControleAbandone implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch001_ControleAbandone());
    }
}