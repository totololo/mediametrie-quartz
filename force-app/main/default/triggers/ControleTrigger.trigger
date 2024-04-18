/*
* Déclencheur à la création "after", de la classe ControleTriggerHandler
* @version 1.00   29/03/2021
* @Auteur Elio Bou Habib
*/
trigger ControleTrigger on Controle__c (before insert, after insert, before update, after update, before delete, after delete, after unDelete) 
{
    new ControleTriggerHandler().run();
}