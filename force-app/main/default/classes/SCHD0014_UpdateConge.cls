/*
*Planification du batch Batch008_SMSviaNP6
String CRON_EXP = '0 5 0 1/1 * ? *';
String description = 'BATCH0014_UpdateConge';
System.schedule(description, CRON_EXP, new SCHD0014_UpdateConge());


* @author: YH
* @date: 25/10/2021
* @Test: SCHD0014_UpdateConge_Test
* @Coverage: 100 %
*/
 global without sharing class SCHD0014_UpdateConge implements Schedulable{

global void execute(SchedulableContext ctx) {

String jobId = Database.executeBatch(new BATCH0014_UpdateConge(),20);
}
}