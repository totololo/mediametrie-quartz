@isTest
public class SCHD025_MAJ_Etiquette_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD025_MAJ_Etiquette';
       System.schedule(description, CRON_EXP , new SCHD025_MAJ_Etiquette());
    }

}