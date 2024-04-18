/*
* @author: Claire VEHRLE
* @date: 20/09/2021
* @ Description classe qui test SCHD013_CreationRequeteAIPNonRep
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@istest
public class SCHD013_CreationRequeteAIPNonRep_Test {
	 @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 20 * * ? *';
        String description = 'Création des requêtes AIP non répondantes';
        System.schedule(description, CRON_EXP , new SCHD013_CreationRequeteAIPNonRep());
    }
}