/*
* @author: Bastien Pinard
* @date: 09/10/2023
* @Description 
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
global  class Batch027_SuppressionCookiesExpire implements Database.Batchable<sObject> {

    global List<CookieConsent__c> start(Database.BatchableContext bc) {
                System.debug('Batch027_SuppressionCookiesExpire');
		Date months = Date.today().addMonths(-13);
        List<CookieConsent__c> scope = [
            SELECT id 
            FROM CookieConsent__c 
            WHERE CreatedDate < :months
        ];
        System.debug(scope);
        return scope;
    }

    global void execute(Database.BatchableContext bc, List<CookieConsent__c> scope) {
        System.debug(scope);
        if(scope != null && scope.size() > 0){
            try{ 
                database.delete(scope);
            }Catch(exception ex){    
                 System.debug('Erreur durant cookie consent delete : ' + ex.getMessage() );
            }
        }
    }


    global void finish(Database.BatchableContext bc) {

    }
}