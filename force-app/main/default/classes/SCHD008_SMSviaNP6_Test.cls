/*
* @author: Joyce Saidy
* @date: 05/10/2020
* @ Description Class that test SCHD008_SMSviaNP6 
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
@isTest
public class SCHD008_SMSviaNP6_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD008_SMSviaNP6';
        System.schedule(description, CRON_EXP , new SCHD008_SMSviaNP6());
    } 
}