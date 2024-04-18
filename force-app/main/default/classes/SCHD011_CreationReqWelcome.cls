/*
*Planification du batch Batch009_Debit_RemiseSoldeAZero
String CRON_EXP = '0 0 22 ? * * *';
String description = 'Batch009_Debit_RemiseSoldeAZero';
System.schedule(description, CRON_EXP, new SCHD009_RemiseDesSoldesAZero());
*** Quotidienne 22:00 ***

* @author: Ayoub GHAMMAZ
* @date: 21/09/2021
* @ Description schedulable planifier chaque jour à 18h pour lancer le batch : Batch011_CreationRequeteWelcomeCal
* @TestClass: SCHD011_CreationReqWelcome_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class SCHD011_CreationReqWelcome  implements Schedulable {
     global void execute(SchedulableContext SC) {
        String jobID = database.executebatch(new Batch011_CreationRequeteWelcomeCal());
        
    }
}