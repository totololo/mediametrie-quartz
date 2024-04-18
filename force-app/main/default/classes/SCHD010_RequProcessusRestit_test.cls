/*
* @author: Ayoub GHAMMAZ
* @date: 08/09/2021
* @ Description classe qui test SCHD010_RequeteProcessusRestit
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@istest
public class SCHD010_RequProcessusRestit_test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 15 * * ? *';
        String description = 'Vérifier équipement non restitues';
        System.schedule(description, CRON_EXP , new SCHD010_RequeteProcessusRestit());
    }
    
}