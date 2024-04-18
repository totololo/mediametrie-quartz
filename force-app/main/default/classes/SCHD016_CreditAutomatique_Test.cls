/*
* Description: Test class de SCHD016_CreditAutomatique
* @author: Nancy Al Kalach
* @date: 08/12/2021
*/
@istest
public class SCHD016_CreditAutomatique_Test { 
    @istest
    static void testSchedule() {
       String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD016_credit';
        System.schedule(description, CRON_EXP, new SCHD016_CreditAutomatique());
    }
    
}