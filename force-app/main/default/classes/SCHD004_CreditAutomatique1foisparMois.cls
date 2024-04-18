/*
*Planification du batch Batch004_CreditAutomatique1foisparMois
String CRON_EXP = '0 0 0 * ?';
String description = 'SCHD004_CreditAutomatique1foisparMois'
System.schedule(description, CRON_EXP, new Batch004_CreditAutomatique1foisparMois());

* @author: JSA EI
* @date: 10/09/2020
* @Test: SCHD004_CreditAutomatique_Test
* @Coverage: 100 %
*/
global without sharing class SCHD004_CreditAutomatique1foisparMois implements Schedulable{

global void execute(SchedulableContext ctx) {

String jobId = Database.executeBatch(new Batch004_CreditAutomatique1foisparMois());
}

}