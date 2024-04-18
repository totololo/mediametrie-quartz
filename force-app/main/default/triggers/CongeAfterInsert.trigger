/*
* @author: Maribelle ZARAZIR
* @date: 31/03/2021
* @ Description: Quand un congé est créé, il faut mettre à jour le foyer et/ou contact associé
* @TestClass: AP01_Conge_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*  
*/
trigger CongeAfterInsert on Conge__c (after insert) {
    //if(UserInfo.getUserName() != Label.Mulesoft_integrationUser_username) {
    //    AP01_Conge.sendRelatedObjectToSIPanel(trigger.new);
    //}
}