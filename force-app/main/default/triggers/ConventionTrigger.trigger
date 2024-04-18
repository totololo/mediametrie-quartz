/*
* @author: Téoman Sertçelik
* @date: 24/03/2022
* @ Description trigger that launches after are created //  
* @Handler class: AP01_Convention
* History
* <Date of modification>	   <Author> 	   <Description of modification>
*/

trigger ConventionTrigger on Convention__c (after insert, after update) {
    
 if (Trigger.isAfter) {

            if (Trigger.isInsert) {
               AP01_Convention.sendConvention(trigger.New, null); //trigger.oldMap null 
            }
           /*  else if (Trigger.isUpdate) {
               AP01_Convention.sendConvention(trigger.New, trigger.oldMap);
            } */
      }

}