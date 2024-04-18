/*
*Planification du batch Batch021_RequeteSuiviSetMeter
String CRON_EXP = '0 50 8 ? * * *';
String description = 'Batch021_RequeteSuiviSetMeter';
System.schedule(description, CRON_EXP, new SCHD021_RequeteSuiviSetMeter());
*** Quotidienne 08:50 ***

* @author: Ayoub GHAMMAZ
* @date: 25/02/2022
* @ Description:
* @TestClass: SCHD021_RequeteSuiviSetMeter_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
global class SCHD021_RequeteSuiviSetMeter implements Schedulable {
    global void execute(SchedulableContext sc){
        database.executeBatch(new Batch021_RequeteSuiviSetMeter());
    }
}