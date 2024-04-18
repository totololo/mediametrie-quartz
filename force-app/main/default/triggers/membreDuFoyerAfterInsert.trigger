/*
* Déclencheur à la création "after", de la classe AP01_MembreDuFoyer
* @version 1.00   28/1/2020
* @Auteur Khaled Hammoudeh
*/
trigger membreDuFoyerAfterInsert on Contact (after insert) {
    system.debug('to be deleted');
    String test = 'to be deleted';
    if(PAD.canTrigger('AP01_MembreDuFoyer')) {
        List<string> compoFoyerPanelAIPIdList = new List<string>();
        List<Contact> compoFoyerPanelAIPList = new List<Contact>();
        for(Contact compoFoyer: Trigger.new) {
            compoFoyerPanelAIPIdList.add(compoFoyer.Id);
        }
        compoFoyerPanelAIPList = [SELECT Id, AccountId FROM Contact 
                                  WHERE Id IN :compoFoyerPanelAIPIdList 
                                  AND Account.Types_de_Panel__c In (:Label.ACC_Types_de_Panel_AIP)];
        if(compoFoyerPanelAIPList.size() > 0 && compoFoyerPanelAIPList != null) {
            AP01_MembreDuFoyer.contactAIPToInsert(compoFoyerPanelAIPList);
        }
    }
}