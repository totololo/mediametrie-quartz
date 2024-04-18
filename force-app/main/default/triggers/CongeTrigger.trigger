/*
* @author: Maribelle ZARAZIR
* @date: 31/03/2021
* @ Description: Quand un congé est créé, il faut mettre à jour le foyer et/ou contact associé
* @TestClass: AP01_Conge_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*  09/04/2021         MZ      Quand un congé est modifié ou supprimé, il faut aussi mettre à jour le foyer et/ou contact associé
*/
trigger CongeTrigger on Conge__c (after insert, after update, after delete, before insert,before update) {
    if(UserInfo.getUserName() != Label.Mulesoft_integrationUser_username) {
        if(trigger.isInsert && trigger.isAfter) {
            //AP01_Conge.sendRelatedObjectToSIPanel(trigger.new);
            system.debug('conge created or updated');
            AP01_Conge.determineCongePrincipal(trigger.new); //272 
          //AP01_Conge.sendConge(trigger.new,trigger.oldmap);
        } else if(trigger.isDelete) {
            system.debug('conge deleted');
            //AP01_Conge.sendRelatedObjectToSIPanel(trigger.old);
            AP01_Conge.determineCongePrincipal(trigger.old); //272
        }
        else if(trigger.isupdate && trigger.isBefore ) {
              AP01_Conge.congeAnterieurExistant(trigger.new);
              //AP01_Conge.sendConge(trigger.new,trigger.oldmap);
              //AP01_Conge.determineCongePrincipal(trigger.new); //272
        }else if(trigger.isBefore && trigger.isInsert ) {
               AP01_Conge.congeAnterieurExistant(trigger.new); //846
        }
        
        
    }
}