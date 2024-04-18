/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-20-2022
* @last modified by  : Anes BOUZOUINA
**/
public with sharing class GetListsViews {
    
    @AuraEnabled(cacheable=true)
    public static List<listView> GetListsViews(String Queue, string Obj) {
        system.debug('we are in getListsViews class '+ Queue);
        List<Campaign> cam = [SELECT ID , File_d_attente__c,Ids_des_vues_de_liste__c  FROM CAMPAIGN where  CampagneID_Avaya__c =: Queue limit 1];
        system.debug('cam'+cam);
        if(cam.size()!=0 && cam[0].Ids_des_vues_de_liste__c!=null){
            List<String> strList = cam[0].Ids_des_vues_de_liste__c.split(',');
            system.debug('inside th if '+ strList);
            return  [select id ,Name  from listview where id =: strList and sobjectType =: Obj];
        }else return null;
        
        
    }
}