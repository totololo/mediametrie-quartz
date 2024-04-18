/*
 * *Planification du batch Batch0018_MajCtrl_Precode_RS
String CRON_EXP = '0 0 6 ? * *	*';
String description = 'Batch0018_MajCtrl_Precode_RS';
System.schedule(description, CRON_EXP, new SCHD0018_RS());
*** Quotidienne XX:XX ***
* @author: YH
* @date: 29/11/2022
* @Test: 
* @Coverage: 100 %
*/
global without sharing class SCHD0018_RS implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch0018_MajCtrl_Precode_RS());
    }
}