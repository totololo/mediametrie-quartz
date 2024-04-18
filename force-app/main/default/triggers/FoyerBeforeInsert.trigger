/*
* Déclencheur à la création, de la classe Ap01_Foyer
* @version 1.00   02/09/2020
* @Auteur JSA EI
*/
trigger  FoyerBeforeInsert on Account (before insert) {
    if(PAD.canTrigger('AP01_Foyer'))
    {
    List<Account> ListNewAccount = new List<Account>();
    for(Account Acc :Trigger.new)
    {
        If(Acc.ShippingPostalCode!=null)
        {
            ListNewAccount.add(Acc);
        }
    }
    if(ListNewAccount!=null && ListNewAccount.size()>0)
    {
       AP01_Foyer.MajTerritoireDeService(ListNewAccount);
    }
    }
}