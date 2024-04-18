/*
*Planification du batch Batch016_CreditAutomatique
String CRON_EXP = '0 0 4 1 * ? *';
String description = 'Batch016_CreditAutomatique';
System.schedule(description, CRON_EXP, new SCHD016_CreditAutomatique());
*** Mensuelle Le 1er à 04:00 ***

* @author: Nancy Al Kalach
* @date: 09/12/2021
* @Test: SCHD016_CreditAutomatique_Test
* @Coverage: 100 %
*/
global without sharing class SCHD016_CreditAutomatique implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch016_CreditAutomatique(),50);
    }
    
}