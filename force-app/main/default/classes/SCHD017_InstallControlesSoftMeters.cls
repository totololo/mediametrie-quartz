/*
*Planification du batch Batch017_InstallControlesSoftMeters
String CRON_EXP = '0 40 8 ?	* *	*';
String description = 'Batch017_InstallControlesSoftMeters';
System.schedule(description, CRON_EXP, new SCHD017_InstallControlesSoftMeters());
*** Quotidienne 08:40 ***

* @author: Ayoub GHAMMAZ
* @date: 27/01/2022
* @ Description schedulable planifier chaque jour à 18h pour lancer le batch : Batch017_InstallControlesSoftMeters
* @TestClass: SCHD017_InstallControlesSoftMeters_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class SCHD017_InstallControlesSoftMeters implements Schedulable {
    global void execute(SchedulableContext SC) {
      String jobID = database.executebatch(new Batch017_InstallControlesSoftMeters());
   }

}