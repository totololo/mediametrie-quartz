/*
*Planification du batch Batch025_ClotureAuto_CaseInactifMeter
String CRON_EXP = '0 10 8 ?	* *	*';
String description = 'Batch025_ClotureAuto_CaseInactifMeter';
System.schedule(description, CRON_EXP, new SCHD025_ClotureAuto());
*** Quotidienne 08:10 ***

* @author: Mikael chaaya
* @date: 30/03/2023
* @Test: Batch025_ClotureAuto_CaseInactifMeter
* @Coverage: 100 %
*/
global class SCHD025_ClotureAuto  implements Schedulable{
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch025_ClotureAuto_CaseInactifMeter());
    }
}