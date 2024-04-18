/*
* @author: Claire VEHRLE
* @date: 09/03/2022
* @ Description Batch pour la RDD de l'objet Rendez-vous de Service
* @TestClass: BatchRDD10_RDVService_Test
* @Coverage: 91 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD10_RDVService  implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        
        return Database.getQueryLocator([SELECT Id, Intervention__r.Foyer_Paneliste__c, Foyer_Paneliste__c FROM ServiceAppointment WHERE Foyer_Paneliste__c = null]);
        
    }
    
    public void execute(Database.BatchableContext bc, List<ServiceAppointment> scope) {
        
        for(ServiceAppointment rdvService: scope) {
            if (rdvService.Intervention__r.Foyer_Paneliste__c != null ) {
                rdvService.Foyer_Paneliste__c = rdvService.Intervention__r.Foyer_Paneliste__c;
            }
            else {
                rdvService.Foyer_Paneliste__c = null;
            }
        }
        if(scope.size() > 0 && scope != null) {
            //Update scope;
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Rendez-vous de Service Exception Error:' + ex.getmessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
    
}