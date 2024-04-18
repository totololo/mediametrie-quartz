/**
* @description       :  data processing and creation of appels 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-26-2022
* @last modified by  : Anes BOUZOUINA
**/
global class Batch022_CreateAppel implements Database.Batchable<sObject>, Database.AllowsCallouts { 
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug(' start Anes');
        String query='SELECT id,Ids_des_vues_de_liste__c,CampagneID_Avaya__c,File_d_attente__c   from campaign ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<campaign> scope){
        List<Id> idOfRecordslst=new List<Id>();
        system.debug(' execute Anes '+scope);
        //map of campaign id and list of listview Ids 
        Map<String,List<String>> CampIdListViewMap = New Map<String,List<String>>();
        for(campaign campaignItr:scope){
            if (CampIdListViewMap.containsKey(campaignItr.Id)){
                (CampIdListViewMap.get(campaignItr.Id)).addAll(campaignItr.Ids_des_vues_de_liste__c.split(','));}
            else{
                CampIdListViewMap.put(campaignItr.Id,new List<String>());
                if(campaignItr.Ids_des_vues_de_liste__c!=null)
                (CampIdListViewMap.get(campaignItr.Id)).addAll(campaignItr.Ids_des_vues_de_liste__c.split(','));
            }
        }
        system.debug('anes JSON '+JSON.serialize(CampIdListViewMap));
        
        // Map of map of campaignid, sobjecttype of listview and list of listview 
        Map<string,Map<String,list<listview>>> CampTypeListviewMap =new Map<string,Map<String,list<listview>>>();
        for(String campItr : CampIdListViewMap.keySet()){
            CampTypeListviewMap.put(campItr,new map<String,List<listview>>());
            //Max 5 campaigns so we can query over a loop , take a look in the Specs 
            List<listview> listviewLst=[select id, name, DeveloperName ,SobjectType from listview where id =: CampIdListViewMap.get(campItr) ];
            for(listview lvItr:listviewLst){
                if (CampTypeListviewMap.get(campItr).containsKey(lvItr.SobjectType)){
                    CampTypeListviewMap.get(campItr).get(lvItr.SobjectType).add(lvItr);
                }
                else{
                    CampTypeListviewMap.get(campItr).put(lvItr.SobjectType,new List<listview> {lvItr});
                }
            }
        }
        //RestAPI
        integer itr = 0;
        Map<String,List<String>> CampRecMap = new Map<String,List<String>>();
        HttpRequest req = new HttpRequest();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('CampTypeListviewMap '+CampTypeListviewMap);
        for(String campItr :  CampTypeListviewMap.keySet()){
            //create a map element with campaignID
            campRecMap.put(campItr,new List<String>());
            for(String typeItr :  CampTypeListviewMap.get(campItr).keySet()){
                List<listview> listviewlst = CampTypeListviewMap.get(campItr).get(typeItr);
                for(listview listviewItr : listviewlst ){
                    system.debug('listviewItr '+listviewItr.Id);
                    Integer indexOfId;
                    String endPoinURL = baseUrl+'/services/data/v50.0/sobjects/'+ typeItr +'/listviews/'+ listviewItr.Id +'/results';
                    req.setEndpoint(endPoinURL);
                    req.setMethod('GET');
                    req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
                    Http http = new Http();
                    HttpResponse response = http.send(req);
                    if( response.getStatusCode() == 200 ) {
                        system.debug('anes' + JSON.serialize(response.getBody()));
                        JSON2Apex classJson = (JSON2Apex)JSON.deserialize(response.getBody(), JSON2Apex.class);
                        system.debug('anes classJson.records' + JSON.serialize(classJson.records));
                        // system.debug('classJson '+classJson);
                        // system.debug('classJson.records '+classJson.records);
                        if(classJson.records != null && classJson.records.size()>0  ){
                            for(Integer i =0; i< (((classJson.records[0]).columns).size()) ;i++){
                                if (classJson.records[0].columns[i].fieldNameOrPath=='Id'){
                                    indexOfId=i;
                                    break;}
                            }           
                            for(Integer i =0; i < classJson.records.size() ;i++){
                                // fill the map create in the line 88
                                 campRecMap.get(campItr).add(classJson.records[I].columns[indexOfId].value);
                            }      
                        }  
                    }
                }
            }   
        }
            system.debug('idOfRecordslst  '+JSON.serialize(campRecMap));
            Set<Appel__c> apSet = new Set<Appel__c>();
            if(campRecMap!=null){
                for(String key : campRecMap.keyset()){
                    //Appel can created for an account twice..
                    if(campRecMap.get(key).size()!=0){
                    apSet.addAll(AP10_CreateAppels.CreateAppels(campRecMap.get(key), key));}
                }
            }
	system.debug('apSet '+apSet);
            if(apSet.size()>0){
                //Can't insert a set so convert to a list 
                List<Appel__c> apExistinglist = [select id,account__c from appel__c where createddate =today];
                Map<String, List<Appel__c>> appelMap = new Map<String, List<Appel__c>>();
                List<Appel__c> aplist = new List<Appel__c>();
                list<id> idCompteLst = new List<Id>();

                for(Appel__c appItr : apExistinglist){
                    idCompteLst.add(appItr.Account__c);
                }

                for(Appel__c appItr : apSet){
                    if (!appelMap.containsKey(appItr.Account__c) && !idCompteLst.contains(appItr.Account__c) ){
                        appelMap.put(appItr.Account__c,new List<Appel__c> {appItr});
                    }
                }
                for(String appItr: appelMap.keyset()) {
                    aplist.addAll(appelMap.get(appItr));
                }
                system.debug('aplist '+aplist);
                insert aplist ;
            }
            
       
    }
    
    global void finish(Database.BatchableContext BC){
        //avaya method work with max 100 records 
      Id batchJobId = Database.executeBatch(new Batch022_CreateAvayaCalls(), 100);
    }


}