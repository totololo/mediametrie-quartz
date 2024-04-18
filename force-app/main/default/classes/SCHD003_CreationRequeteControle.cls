/*
*Planification du batch Batch003_CreationRequeteControle
String CRON_EXP = '0 50 8 ? * *	*';
String description = 'Batch003_CreationRequeteControle';
System.schedule(description, CRON_EXP, new SCHD003_CreationRequeteControle());
*** Quotidienne 08:50 ***

* @author: Khaled Hammoudeh EIT
* @date: 10/03/2021
* @Test: SCHD003_CreationRequeteControle_Test
* @Coverage: 100 %
*/
global without sharing class SCHD003_CreationRequeteControle implements Schedulable{

global void execute(SchedulableContext ctx) {

String jobId = Database.executeBatch(new Batch003_CreationRequeteControle(),100);
}

}