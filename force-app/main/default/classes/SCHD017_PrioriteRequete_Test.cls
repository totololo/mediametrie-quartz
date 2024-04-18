/*
* Description: Test class de SCHD017_PrioriteRequete
* @author: Claire VEHRLE
* @date: 28/01/2022
*/
@isTest
public class SCHD017_PrioriteRequete_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD017_PrioriteRequete';
        System.schedule(description, CRON_EXP , new SCHD017_PrioriteRequete());
        
    }
}