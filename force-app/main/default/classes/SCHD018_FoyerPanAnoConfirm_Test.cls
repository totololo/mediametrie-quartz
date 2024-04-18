@isTest
public class SCHD018_FoyerPanAnoConfirm_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 20 * * ? *';
        String description = 'Anonymisation Foyer Panéliste';
        System.schedule(description, CRON_EXP , new SCHD018_FoyerPanAnonymisationConfirm());
    }
}