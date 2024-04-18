/*
*Planification du batch Batch009_Debit_RemiseSoldeAZero
String CRON_EXP = '0 0 22 ? * * *';
String description = 'Batch009_Debit_RemiseSoldeAZero';
System.schedule(description, CRON_EXP, new SCHD009_RemiseDesSoldesAZero());
*** Quotidienne 22:00 ***

* @author: 
* @date: 
* @Test: 
* @Coverage: 
*/
global without sharing class SCHD009_RemiseDesSoldesAZero implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch009_Debit_RemiseSoldeAZero());
    }
    
}