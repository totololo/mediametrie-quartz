/*
* Déclencheur à la modification "before", de la classe Ap01_Foyer
* @version 1.00   13/10/2020
* @Auteur JSA EI
*/
trigger FoyerBeforeUpdate on Account (before update) {
    if(PAD.canTrigger('AP01_Foyer'))
    {
        List<Account> ListNewAccount = new List<Account>();
        List<Account> accountCheckAddList = new List<Account>();
        for(Account acc :Trigger.new)
        {
            If(acc.ShippingPostalCode!=null &&acc.ShippingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode)
            {
                ListNewAccount.add(acc);
            }

            if( (acc.ShippingPostalCode!=null && acc.ShippingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode)
                ||(acc.ShippingCity!=null && acc.ShippingCity!=Trigger.oldMap.get(acc.Id).ShippingCity)
                || (acc.ShippingPostalCode!=null && acc.ShippingCity==null 
                    && (acc.ShippingCity!=Trigger.oldMap.get(acc.Id).ShippingCity || acc.ShippingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode)
                )
                ||(acc.ShippingPostalCode==null && acc.ShippingCity!=null 
                && (acc.ShippingCity!=Trigger.oldMap.get(acc.Id).ShippingCity || acc.ShippingPostalCode!=Trigger.oldMap.get(acc.Id).ShippingPostalCode)
                )
            )
            {
                accountCheckAddList.add(acc);
            }
        }
        if(ListNewAccount!=null && ListNewAccount.size()>0)
        {
            AP01_Foyer.MajTerritoireDeService(ListNewAccount);
        }

        if(accountCheckAddList!=null && accountCheckAddList.size()>0)
        {
            AP01_Foyer.validateAddress(accountCheckAddList);
        }
    }
}