@istest
public class SCHD0018_RS_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD0018';
        System.schedule(description, CRON_EXP , new SCHD0018_RS());
    } 
}