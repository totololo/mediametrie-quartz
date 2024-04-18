/*
*Planification du batch Batch002_PrecodageControle
String CRON_EXP = '0 40 8 ? * *	*';
String description = 'Batch002_PrecodageControle';
System.schedule(description, CRON_EXP, new SCHD002_PrecodageControle());
*** Quotidienne 08:40 ***

* @author: JSA EI
* @date: 14/09/2020
* @Test: SCHD002_PrecodageControle_Test
* @Coverage: 100 %
*/
global without sharing class SCHD002_PrecodageControle implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch002_PrecodageControle());
    }
    
}