/*
* @author: Ayoub GHAMMAZ
* @date: 20/09/2021
* @ Description classe qui test SCHD009_ClotureRequeteAuto
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@istest
public class SCHD009_ClotureRequeteAuto_Test {
	 @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 20 * * ? *';
        String description = 'fermeture des requetes';
        System.schedule(description, CRON_EXP , new SCHD009_ClotureRequeteAuto());
    }
}