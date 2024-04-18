/*
*Planification du batch Batch008_SMSviaNP6
String CRON_EXP = '0 0 9 ? * * *'
String description = 'SCHD008_SMSviaNP6'
System.schedule(description, CRON_EXP, new Batch008_SMSviaNP6());
*** Quotidienne 09:00 ***

* @author: JSA EI
* @date: 05/10/2020
* @Test: SCHD008_SMSviaNP6_Test
* @Coverage: 100 %
*/
global without sharing class SCHD008_SMSviaNP6 implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch008_SMSviaNP6());
    }
}