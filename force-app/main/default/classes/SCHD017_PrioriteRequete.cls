/*
*Planification du batch Batch017_PrioriteRequete
String CRON_EXP = '0 10 * ? * *	*';
String description = 'Batch017_PrioriteRequete'
System.schedule(description, CRON_EXP, new SCHD017_PrioriteRequete());
*** Quotidienne Toutes les heures et 10 min ***

* @author: Claire VEHRLE
* @date: 28/01/2021
* @Test: SCHD017_PrioriteRequete_Test
* @Coverage: 100 %
*/
global without sharing class SCHD017_PrioriteRequete implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch017_PrioriteRequete());
    }
    
}