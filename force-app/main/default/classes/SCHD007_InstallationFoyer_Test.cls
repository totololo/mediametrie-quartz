/*
* @author: Joyce Saidy
* @date: 05/10/2020
* @ Description Class that test SCHD007_InstallationFoyer 
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class SCHD007_InstallationFoyer_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD007_InstallationFoyer';
        System.schedule(description, CRON_EXP , new SCHD007_InstallationFoyer());
    }
    
}