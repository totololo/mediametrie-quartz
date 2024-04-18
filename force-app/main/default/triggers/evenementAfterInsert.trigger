/*
* @author: Khaled Hammoudeh
* @date: 05/10/2020
* @ Description trigger that launches after the events/évènements coming from O-COM are created in Salesforce
* @TestClass: AP01_Evenement_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
trigger evenementAfterInsert on Evenement__c (after insert) {
    
    if(PAD.canTrigger('AP01_Evenement'))
    {
        list<Evenement__c> listEvenements = new list<Evenement__c>();
        for(Evenement__c evenement : trigger.new)
        {
            if(evenement.Etat__c == Label.EVENT_Etat_TV_ON && evenement.Meter__c != Null)
            {
                listEvenements.add(evenement);
            }
        }
        
        if(listEvenements.size() > 0)
        {
            AP01_Evenement.updateEtiquettesStatus(listEvenements);
        }
    }

}