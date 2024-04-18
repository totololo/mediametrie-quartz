/*
*

* @author: YH
* @date: 27/01/2023
* @Test: 
* @Coverage:
*/
@isTest
public class SCHD022_CreationRequete_RetourMat_Test {
    
    @istest
    static void testSchedule() {
        String CRON_EXP = '0 0 6 1/1 * ? *';
        String description = 'SCHD022_CreationRequete_RetourMat';
        System.schedule(description, CRON_EXP , new SCHD022_CreationRequete_RetourMateriel());
    } 
}