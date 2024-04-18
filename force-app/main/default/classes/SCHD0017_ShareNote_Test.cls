@isTest
public class SCHD0017_ShareNote_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD0017_ShareNote';
        System.schedule(description, CRON_EXP , new SCHD0017_ShareNote());
    } 
}