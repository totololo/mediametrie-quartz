/*
 * *Planification du batch Batch027_SuppressionCookiesExpire
String CRON_EXP = '0 0 0 ? * * *';
String description = 'Batch027_SuppressionCookiesExpire';
System.schedule(description, CRON_EXP, new SCHD0019_CookiesExpiration());
*** Quotidienne XX:XX ***
* @author: Bastien Pinard
* @date: 09/10/2023
* @Test: 
* @Coverage: 
*/
global without sharing class SCHD0019_CookiesExpiration implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch027_SuppressionCookiesExpire());
    }
}