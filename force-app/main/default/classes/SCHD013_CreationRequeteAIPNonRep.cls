/*
*Planification du batch Batch013_CreationRequeteAIPNonRep
String CRON_EXP = '0 30	8 ?	* *	*';
String description = 'Batch013_CreationRequeteAIPNonRep';
System.schedule(description, CRON_EXP, new SCHD013_CreationRequeteAIPNonRep());
*** Quotidienne 08:30 ***

* @author: Claire VEHRLE
* @date: 17/11/2021
* @ Description schedulable planifier chaque jour à --h pour lancer le batch : Batch013_CreationRequeteAIPNonRep
* @TestClass: SCHD013_CreationRequeteAIPNonRep_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class SCHD013_CreationRequeteAIPNonRep implements Schedulable {
    global void execute(SchedulableContext SC) {
        String jobID = database.executebatch(new Batch013_CreationRequeteAIPNonRep());
        
    }
}