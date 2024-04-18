/*
*Planification du batch Batch026_ClotureCaseSansControle
String CRON_EXP = '0 0 20 ?	* *	*';
String description = 'Batch026_ClotureCaseSansControle';
System.schedule(description, CRON_EXP, new SCHD026_ClotureCaseSansControle());
*** Quotidienne 20:00 ***

* @author: Mikael chaaya
* @date: 20/07/2023
* @Test: Batch026_ClotureTest
* @Coverage: 100 %
*/
global class SCHD026_ClotureCaseSansControle  implements Schedulable{
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch026_ClotureCaseSansControle());
    }
}