/*
*Planification du batch Batch0013_Delete_Evenement
String CRON_EXP = '0 0 3 1 * ? *';
String description = 'Batch0013_Delete_Evenement';
String result = System.schedule(description, CRON_EXP, new SCHD0013_Delete_Evenement());
*** Mensuelle le 1er à 03:00 ***


* @author: YH
* @date: 25/10/2021
* @Test: 
* @Coverage: 100 %
*/
global without sharing class SCHD0013_Delete_Evenement implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch0013_Delete_Evenement());
    }
}