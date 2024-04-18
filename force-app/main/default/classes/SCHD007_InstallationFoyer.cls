/*
*Planification du batch Batch007_InstallationFoyer
String CRON_EXP = A preciser
String description = 'SCHD007_InstallationFoyer'
System.schedule(description, CRON_EXP, new Batch007_InstallationFoyer());

* @author: JSA EI
* @date: 05/10/2020
* @Test: SCHD007_InstallationFoyer_Test
* @Coverage: 100 %
*/
global without sharing class SCHD007_InstallationFoyer implements Schedulable{

global void execute(SchedulableContext ctx) {

String jobId = Database.executeBatch(new Batch007_InstallationFoyer());
}
}