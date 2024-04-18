/*
* @author: Joyce Saidy
* @date: 05/10/2020
* @ Description Class that test SCHD001_ControleAbandone 
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class SCHD001_ControleAbandone_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD001_ControleAbandone';
       System.schedule(description, CRON_EXP , new SCHD001_ControleAbandone());
    }

}