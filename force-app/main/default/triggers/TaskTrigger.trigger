/*
* Déclencheur à la création "before", de la classe TaskTriggerHandler
* @version 1.00   26/07/2021
* @Auteur youssef hamrouni
*/


trigger TaskTrigger on Task (before insert) {
    new TaskTriggerHandler().run();

}