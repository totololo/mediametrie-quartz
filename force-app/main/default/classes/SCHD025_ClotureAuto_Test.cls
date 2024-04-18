@istest
public class SCHD025_ClotureAuto_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'Batch025_ClotureAuto_CaseInactifMeter';
        System.schedule(description, CRON_EXP , new SCHD025_ClotureAuto());
    } 
}