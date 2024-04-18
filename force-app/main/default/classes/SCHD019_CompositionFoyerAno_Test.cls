@isTest
public class SCHD019_CompositionFoyerAno_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 20 * * ? *';
        String description = 'Anonymisation Composition du Foyer';
        System.schedule(description, CRON_EXP , new SCHD019_CompositionFoyerAnonymisation());
    }
}