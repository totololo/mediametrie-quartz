/*
* @author: Maribelle ZARAZIR EI
* @date: 08/2021
* @ Description Test class for SCHD009_RemiseDesSoldesAZero
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/

@isTest
public class SCHD009_RemiseDesSoldesAZero_test {
    
    @istest
    static void testSchedule(){
        String CRON_EXP = '0 0 22 ? * * *';
        String description = 'Batch009_Debit_RemiseSoldeAZero';
        System.schedule(description+system.now(), CRON_EXP, new SCHD009_RemiseDesSoldesAZero());
    }
}