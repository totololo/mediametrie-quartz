/*
* Description: Test class de SCHD003_CreationRequeteControle
* @author: Khaled Hammoudeh
* @date: 10/03/2021
*/
@isTest
public class SCHD003_CreationRequeteControle_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD003_CreationRequeteControle';
       System.schedule(description, CRON_EXP , new SCHD003_CreationRequeteControle());
    
}
}