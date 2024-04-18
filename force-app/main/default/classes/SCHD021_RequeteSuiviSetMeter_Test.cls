/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 25/02/2022
* @Classe:  Batch021_RequeteSuiviSetMeter
* @Coverage: 93%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class SCHD021_RequeteSuiviSetMeter_Test {
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 15 * * ? *';
        String description = 'Vérifier équipement non restitues';
        System.schedule(description, CRON_EXP , new SCHD021_RequeteSuiviSetMeter());
    }
   
}