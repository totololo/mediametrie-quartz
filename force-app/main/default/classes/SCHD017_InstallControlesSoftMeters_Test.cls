/*
* @author: HE Jérôme
* @date: 29/03/2022
* @ Description classe qui test SCHD017_InstallControlesSoftMeters
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class SCHD017_InstallControlesSoftMeters_Test {
     @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 12 * * ? *';
        String description = 'batch soft meter';
       System.schedule(description, CRON_EXP , new SCHD017_InstallControlesSoftMeters());
    }

}