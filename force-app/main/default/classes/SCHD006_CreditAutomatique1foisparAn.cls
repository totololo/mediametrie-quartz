/*
*Planification du batch Batch005_CreditAutomatique1foisparAn
String CRON_EXP = '0 0 0 * ?';
String description = 'SCHD005_CreditAutomatique1foisparAn'
System.schedule(description, CRON_EXP, new Batch005_CreditAutomatique1foisparAn());

* @author: JSA EI
* @date: 10/09/2020
* @Test: SCHD006_CreditAutomatique1foisparAn_Test
* @Coverage: 100 %
*/
global without sharing class SCHD006_CreditAutomatique1foisparAn implements Schedulable{

global void execute(SchedulableContext ctx) {

String jobId = Database.executeBatch(new Batch006_CreditAutomatique1foisparAn());
}

}