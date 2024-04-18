/*
* Description: Test class de SCHD002_PrecodageControle
* @author: JSA EI
* @date: 14/09/2020
*/
@isTest
public class SCHD002_PrecodageControle_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD002_PrecodageControl';
       System.schedule(description, CRON_EXP , new SCHD002_PrecodageControle());
    
}
}