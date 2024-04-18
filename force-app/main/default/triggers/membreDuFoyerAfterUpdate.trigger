trigger membreDuFoyerAfterUpdate on Contact (after update) {
    if(PAD.canTrigger('AP01_MembreDuFoyer') && !Userinfo.getUserName().Contains(Label.User_Technique_Username)){
        if(System.IsBatch() == false){
            AP01_MembreDuFoyer.checkSendContactToSIPanel(trigger.new, Trigger.oldMap);
        }
    }
    if(PAD.canTrigger('AP02_MembreDuFoyer')){
        AP02_MembreDuFoyer.checkContact(trigger.new, Trigger.oldMap);
    }
    
    if(PAD.canTrigger('AP03_MembreDuFoyer')){
        AP03_MembreDuFoyer.checkContact(trigger.new);
    }
    
    if(PAD.canTrigger('AP02_Commande')) {
        List<Contact> newListContact = new List<Contact>();
        for(Contact c : trigger.new){
            if(c.Salutation != null && Trigger.oldMap.get(c.Id).Salutation == null){
                newListContact.add(c);
            }
        }
        //AP02_Commande.sendOrderTrigger(newListContact);
    }
    /*
if(PAD.canTrigger('AP01_MembreDuFoyer') && UserInfo.getUserName() != Label.Mulesoft_integrationUser_username)
{
List<Schema.FieldSetMember> fields = Schema.SObjectType.Contact.fieldSets.Champs_envoyes_vers_sipanel.getFields();
list<string> listContactIdsToProcess = new list<string>();

for(Contact cont : trigger.new)
{
//if this tech field was changed, this means that the process "chute Individu" was launched and some fields were emptied
//we don't want to send those values again to SI Panel
if(cont.TECH_IndividuChute__c == trigger.oldMap.get(cont.Id).TECH_IndividuChute__c
&& (cont.Date_de_chute_individu__c == trigger.oldMap.get(cont.Id).Date_de_chute_individu__c || cont.Date_de_chute_individu__c != null)) { 
for(Schema.FieldSetMember contactField : fields)
{
if(cont.get(contactField.getFieldPath()) != trigger.oldMap.get(cont.Id).get(contactField.getFieldPath()))
{
listContactIdsToProcess.add(cont.CON_ExtId_SIPanel__c);
break;
}
}
}
}

if(listContactIdsToProcess.size() == 1 )
{
AP01_MembreDuFoyer.sendUpdatedContactToSiPanel(listContactIdsToProcess);
}

}
*/
}