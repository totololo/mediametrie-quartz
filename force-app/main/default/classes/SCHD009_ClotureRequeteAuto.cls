/*
*Planification du batch Batch009_ClotureRequeteAutomatique
String CRON_EXP = '0 0 23 ? * * *';
String description = 'Batch009_ClotureRequeteAutomatique';
System.schedule(description, CRON_EXP, new SCHD009_ClotureRequeteAuto());
***Programmation Manuelle*** Quotidienne 23h

* @author: Ayoub GHAMMAZ
* @date: 20/09/2021
* @ Description schedulable planifier chaque jour à 18h pour lancer le batch : Batch009_ClotureRequeteAutomatique
* @TestClass: SCHD009_ClotureRequeteAuto_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/

global class SCHD009_ClotureRequeteAuto implements Schedulable {
    global void execute(SchedulableContext SC) {
        String jobID = database.executebatch(new Batch009_ClotureRequeteAutomatique());
        
    }
}