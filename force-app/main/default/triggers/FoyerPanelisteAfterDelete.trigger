/*
* @date: 27/04/2022
* Déclencheur à la supression "after"
* Description : Ajout/Suppression des valeurs du champ Types de panel sur Foyer
* @version 1.00   
* @Auteur Claire VEHRLE
* <Date of modification>   			<Author>   		 <Description of modification>
*/
trigger FoyerPanelisteAfterDelete on Foyer_paneliste__c (before delete) {

        if(PAD.canTrigger('AP08_FoyerPaneliste')) {
        List<Id> foyerIdList = new List<Id>();
        List<Id> foyerPanelisteIdList = new List<Id>();
        User user = [SELECT Bypass_RDD__c FROM User WHERE Id=:UserInfo.getUserId()];
        for(foyer_Paneliste__c foyerpaneliste: Trigger.Old) {
            foyerIdList.add(foyerpaneliste.Foyer__c);
            foyerPanelisteIdList.add(foyerpaneliste.Id);
        }
        System.debug('$$$Execution Delete AP08');
        AP08_FoyerPaneliste.foyerAModifier(foyerIdList, foyerPanelisteIdList, true, user.Bypass_RDD__c);
    }
}