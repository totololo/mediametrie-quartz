@istest
public class SCHD026_ClotureCaseSansControle_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 20 ?	* *	*';
        String description = 'Batch026_ClotureCaseSansControle';
        System.schedule(description, CRON_EXP, new SCHD026_ClotureCaseSansControle());
    } 
}