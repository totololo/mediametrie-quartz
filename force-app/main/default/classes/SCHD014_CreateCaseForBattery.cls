/*
*Planification du batch Batch014_CreateCaseForBattery
String CRON_EXP = '0 5 0 ? * * *';
String description = 'Batch014_CreateCaseForBattery';
System.schedule(description, CRON_EXP, new SCHD014_CreateCaseForBattery());
*** Quotidienne 00:05 ***

* @author: Ayoub GHAMMAZ
* @date: 16/07/2021
* @ Description schedulable planifier chaque jour à 18h pour lancer le batch : Batch014_CreateCaseForBattery
* @TestClass: SCHD014_CreateCaseForBattery_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class SCHD014_CreateCaseForBattery  implements Schedulable {
    global void execute(SchedulableContext SC) {
      String jobID = database.executebatch(new Batch014_CreateCaseForBattery());
   }

}