/**
* @description       : Class for the création of 'appels'
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-21-2022
* @last modified by  : Anes BOUZOUINA
**/
public  class AP10_CreateAppels {
    public static Set<Appel__c> CreateAppels(list<id> recordIdLst,String CampaignId ) {
        set<Id> accountIdSet =new set<Id>();
        Map<Id,Id> AccountToCase = new map<Id,Id>();
        Map<String,List<ID>> idMap = new Map<String,List<ID>>();
        for (Id idItr : recordIdLst){
            if (idMap.containsKey(idItr.getSObjectType().getDescribe().getName())){
                idMap.get(idItr.getSObjectType().getDescribe().getName()).add(idItr);}
            else{
                idMap.put(idItr.getSObjectType().getDescribe().getName(),new List<ID> {idItr});
            }
        }  
        system.debug('map of id : '+idMap);
        //  accountIdSet.addAll(GenerateAccounIds(idMap,'Case'));
        List<sobject> sObjectIds = new List<sobject>();
        if(idMap.get('Case')!=null){
            sObjectIds.addAll([select id,accountId from case where id in : idMap.get('Case')]);}
        if(idMap.get('Task')!=null){
            sObjectIds.addAll([select id,accountId from Task where id in : idMap.get('Task')]);}
        if(idMap.get('Etiquette__c')!=null){
            sObjectIds.addAll([select id,foyer__c from Etiquette__c where id in : idMap.get('Etiquette__c')]);}
        if(idMap.get('Account')!=null){
            system.debug(idMap.get('Account'));
                system.debug([select id from Account where id in : idMap.get('Account')]);
            sObjectIds.addAll([select id from Account where id in : idMap.get('Account')]);}
        system.debug('sObjectIds'+sObjectIds);
        if(sObjectIds.size()>0){
            for (sObject caseItr : sObjectIds) {
                system.debug('caseItr = '+caseItr);
                if( Id.valueOf(caseItr.get('Id').tostring()).getSObjectType().getDescribe().getName()=='Etiquette__c' ){
                    system.debug((Id.valueOf(caseItr.get('foyer__c').toString()))) ;  
                    accountIdSet.add(Id.valueOf(caseItr.get('foyer__c').toString()));}
                   else if ( Id.valueOf(caseItr.get('Id').tostring()).getSObjectType().getDescribe().getName()=='Account' ){
                    accountIdSet.add(Id.valueOf(caseItr.get('Id').toString()));
                } 
                     else if ( Id.valueOf(caseItr.get('Id').tostring()).getSObjectType().getDescribe().getName()=='Case' ){
                    AccountIdSet.add(Id.valueOf(caseItr.get('accountId').toString()));
                    AccountToCase.put(Id.valueOf(caseItr.get('accountId').toString()),Id.valueOf(caseItr.get('Id').tostring()));
                         
                } 
                else if (caseItr.get('accountId')!=null){
                    accountIdSet.add(Id.valueOf(caseItr.get('accountId').toString()));
                }
                
            }
            system.debug('accountId =' + accountIdSet);           
        }
        
        Set<Appel__c> apSet = new Set<Appel__c>();
        if(accountIdSet.size()>0){
            for(String idItr : accountIdSet){
                if(AccountToCase.get(idItr)!=null){
                    apSet.add(new Appel__c(Account__c= idItr , Campaign__c = CampaignId,caseId__c=AccountToCase.get(idItr)));}
                else{apSet.add(new Appel__c(Account__c= idItr, Campaign__c = CampaignId));}
                
            }
           system.debug('apSet = ' + apSet);
        }
        return apSet;
    }    
}