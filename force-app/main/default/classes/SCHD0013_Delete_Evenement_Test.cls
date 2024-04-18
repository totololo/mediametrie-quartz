@istest
public class SCHD0013_Delete_Evenement_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD0013_delete';
        System.schedule(description, CRON_EXP , new SCHD0013_Delete_Evenement());
    } 
}