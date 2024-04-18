/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-21-2022
 * @last modified by  : Anes BOUZOUINA
 
Création des appels dans le CCtel dialer 


**/
public with sharing class CallBat22FromLwc {
    @AuraEnabled
    public static void CallBat22FromLwc() {
        system.debug('we are in the CallBat22FromLwc met');
        Id batchCancel = database.executebatch(new Batch022_CancelAvayaCalls(),100);
        

    }
}