/*
* Déclencheur à la modification "after", de la classe AP02_Foyer
* @version 1.00   22/01/2021
* @Auteur Khaled Hammoudeh
*/
trigger foyerAfterUpdate on Account (after update) {
    
    System.debug('TRIGGER TRIGGERED ');
    System.debug('trigger new >> ' + trigger.new.size());
    Boolean isInterchanged = false;
    for(Account a : trigger.new) {
        System.debug('TRIGGER tech field >> ' + a.TECHi_is_WorkOrder_Changed__c);
        system.debug(' old map value >>' + trigger.oldMap.get(a.Id).get('TECHi_is_WorkOrder_Changed__c'));
        isInterchanged = a.TECHi_is_WorkOrder_Changed__c != trigger.oldMap.get(a.Id).get('TECHi_is_WorkOrder_Changed__c') ? true : false;
        if(isInterchanged) {
            break;
        }
    }
    
    /*if(PAD.canTrigger('AP02_Foyer')) {
AP02_Foyer.checkSendAccountToSIPanel(trigger.new, trigger.oldMap);

if(AP02_Foyer_RecursiveHandler.firstRun || isInterchanged || Test.isRunningTest()) {
AP02_Foyer.checkSendAccountToSIPanel(trigger.new, trigger.oldMap);
AP02_Foyer_RecursiveHandler.firstRun = false;
}  
}*/
    
    /*
    if(PAD.canTrigger('AP04_Foyer')){
        AP04_Foyer.UpdateAddress(trigger.new, trigger.oldMap);
        List<Account>FoyerToUpdate = new List<Account>();
        for(Account accn :Trigger.new){
            for(Account acco : trigger.old){
                if(accn.Personne_de_reference__c !=acco.Personne_de_reference__c && accn.id == acco.id){
                    FoyerToUpdate.add(accn);
                }
            }
            
        }
        if(FoyerToUpdate.size()>0 && FoyerToUpdate!=null){
            AP04_Foyer.MajRefFoyer(FoyerToUpdate);
        }
    }
    }*/
    //optimized version
	if (PAD.canTrigger('AP04_Foyer')) {
    	AP04_Foyer.UpdateAddress(trigger.new, trigger.oldMap);
        
        //Enlever le 03-04-2023 PNL-4415
        /*
    	List<Account> FoyerToUpdate = new List<Account>();
    	for (Account acc : Trigger.new) {
        	if (acc.Personne_de_reference__c != Trigger.oldMap.get(acc.Id).Personne_de_reference__c) {
            	FoyerToUpdate.add(acc);
        	}
    	}
    	if (!FoyerToUpdate.isEmpty()) {
       	 AP04_Foyer.MajRefFoyer(FoyerToUpdate);
    	}
		*/
	}
    
    if(PAD.canTrigger('AP05_Foyer') && !Userinfo.getUserName().Contains(Label.User_Technique_Username)) {
        if(System.IsBatch() == false && System.isFuture() == false){
            AP05_Foyer.envoyerFoyerMulesoft(Trigger.new, Trigger.oldMap); 
        }
    }

    
    /*
if(PAD.canTrigger('AP02_Foyer') && UserInfo.getUserName() != Label.Mulesoft_integrationUser_username)
{
List<Schema.FieldSetMember> fields = Schema.SObjectType.Account.fieldSets.Champs_envoyes_vers_sipanel.getFields();
list<string> listAccountsIdsToProcess = new list<string>();

for(Account acc : trigger.new)
{
for(Schema.FieldSetMember accountField : fields)
{
if(acc.get(accountField.getFieldPath()) != trigger.oldMap.get(acc.Id).get(accountField.getFieldPath()))
{
listAccountsIdsToProcess.add(acc.ACC_ExtId_SIPanel__c);
break;
}
}
}

if(listAccountsIdsToProcess.size() == 1 )
{
AP02_Foyer.sendAccountToSiPanel(listAccountsIdsToProcess);
}

}
*/
    
}