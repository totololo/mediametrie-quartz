/*
* Déclencheur à la création "after", de la classe Ap01_Foyer
* @version 1.00   13/10/2020
* @Auteur JSA EI
*/
trigger FoyerAfterInsert on Account (after insert) {
    if(PAD.canTrigger('AP01_Foyer'))
    {
          /*List<Account> ListNewAccount = new List<Account>();
        Id recordTypeIdNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_NonEquipe).getRecordTypeId();
        for(Account Acc :Trigger.new)
        {
          if(Acc.Statut_du_foyer__c==Label.ACC_Statut_du_foyer_Recrute && Acc.RecordTypeId != recordTypeIdNonEquipe)//Changed by ER for MEDIAMETRIE-261 
          {
              ListNewAccount.add(Acc);
          }
        }
        if(ListNewAccount!=null && ListNewAccount.size()>0)
        {
             AP01_Foyer.NouvelleReq(ListNewAccount);
        }*/
    }
}