/*
* @author: Ayoub GHAMMAZ
* @date: 21/09/2021
* @ Description classe qui test SCHD011_CreationReqWelcome
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@istest
public class SCHD011_CreationReqWelcome_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 10 * * ? *';
        String description = 'Creation requete welcome call';
        System.schedule(description, CRON_EXP , new SCHD011_CreationReqWelcome());
    }
}