/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 09-29-2022
 * @last modified by  : Anes BOUZOUINA
**/
public with sharing class PilotageController{
    @auraEnabled(cacheable=true)
    public static list<listview> getListview(string objectName){
        system.debug('we are in the classe with objectName '+ objectName);
        system.debug([select Id,Name from listview where SobjectType =: objectName]);
        return[select Id,Name,SobjectType from listview where SobjectType =: objectName];
    }
}