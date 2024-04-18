@isTest
public class SCHD0014_UpdateConge_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD0014_UpdateConge';
        System.schedule(description, CRON_EXP , new SCHD0014_UpdateConge());
    } 
}