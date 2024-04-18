/*
* @author: Ayoub GHAMMAZ
* @date: 16/07/2021
* @ Description classe qui test SchedulableCreateCAseBattery
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class SCHD014_CreateCaseForBattery_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 12 * * ? *';
        String description = 'Verifier batterie';
       System.schedule(description, CRON_EXP , new SCHD014_CreateCaseForBattery());
    }

}