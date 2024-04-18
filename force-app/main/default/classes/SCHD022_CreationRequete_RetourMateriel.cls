/*
*Planification du batch Batch022_CreationRequete_RetourMateriel
String CRON_EXP = '0 0 3 ? * * *';
String description = 'Batch022_CreationRequete_RetourMateriel';
System.schedule(description, CRON_EXP, new SCHD022_CreationRequete_RetourMateriel());
*** Quotidienne 03:00 ***

* @author: YH
* @date: 27/01/2023
* @Test: SCHD022_CreationRequete_RetourMat_Test
* @Coverage: 100 %
*/
global without sharing class SCHD022_CreationRequete_RetourMateriel implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        String jobId = Database.executeBatch(new Batch022_CreationRequete_RetourMateriel());
    }
}