/**
*²² @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 11-22-2022
* @last modified by  : Anes BOUZOUINA
**/
public with sharing class CommunicatorController {
    @AuraEnabled
    public static string IncomingEventMethod(String v ) {
        MyData MyData = (MyData) JSON.deserialize(v,MyData.class);
        system.debug('MyData '+MyData);
        if ( MyData.uui.contains('|')){
            String tryId = MyData.uui.substringAfter('|');
            system.debug('it\'s a fantome call tryId = '+tryId); 
            system.debug('it\'s a fantome call agentId = '+MyData.agentId); 
            // you call it from jscontroller for making the freeze time 
            String res= AP09_WebService_Avaya.GetTryInfo(tryId);
            MyDataGetTryInfo MyDataGetTryInfo = (MyDataGetTryInfo) JSON.deserialize(res,MyDataGetTryInfo.class);
            system.debug('res '+res);
            system.debug('MyDataGetTryInfo '+MyDataGetTryInfo);
            system.debug(' String.valueOf( MyDataGetTryInfo.customerReference ) '+ String.valueOf(MyDataGetTryInfo.customerReference));
            // get le t'emps d'attente
            List<Campaign> campLst = [select CampagneID_Avaya__c,Temps_dattente__c   from campaign Limit 1 ] ;
            //AP09_WebService_Avaya.AcceptTry(tryID);
            //list<Case> cs = [select id, Avaya_UUI_tech__c from case where status='nouveau' and type='contrôle' and AccountId =:  String.valueOf(MyDataGetTryInfo.customerReference) limit 1];
            list<appel__c> cs = [select id, CaseId__c,Account__c from appel__c where createdDate = today and Account__c =:  String.valueOf(MyDataGetTryInfo.customerReference) limit 1];
            // list<Case> cs = [select id from case where status='nouveau' and type='contrôle' and AccountId = '0017E00001L0fs4QAB' limit 1];
            
            String info ;
            if(cs.size()!=0 && cs[0].CaseId__c!=null && cs[0].CaseId__c!=''){
                info = '{"tryId": "'+tryID + '","comments": "' + MyDataGetTryInfo.comments+'", "CaseId": "'+cs[0].CaseId__c+'" }';
                list<Case> caseToUpdate = [select id,Avaya_UUI_tech__c from case where id =: cs[0].CaseId__c limit 1];
                system.debug(caseToUpdate[0]);
                caseToUpdate[0].Avaya_UUI_tech__c= MyData.uui;
                update caseToUpdate[0];
                
            }else{
                info = '{"tryId": "'+tryID + '","comments": "' + MyDataGetTryInfo.comments+'", "CaseId": "'+String.valueOf(MyDataGetTryInfo.customerReference)+'" }';
                list<Account> accountToUpdate = [select id,Avaya_UUI_tech__c from Account where id =: String.valueOf(MyDataGetTryInfo.customerReference) limit 1];
                 system.debug(accountToUpdate);
                system.debug(String.valueOf(MyDataGetTryInfo.customerReference));
                accountToUpdate[0].Avaya_UUI_tech__c= MyData.uui;  
                update accountToUpdate[0];
            }
            //if(cs.size()>0){
           // cs[0].Avaya_UUI_tech__c= MyData.uui;
            //update cs;}
            // info = '{"tryId": "'+tryID + '","comments": "' + MyDataGetTryInfo.comments+'", "CaseId": "'+'5007E00000CyLJVQA3'+'" }';
            
            system.debug('info : '+info);
            system.debug('info : '+ JSON.serialize((MyDataGetTryInfo) JSON.deserialize(info,MyDataGetTryInfo.class)));
            system.debug('Anes '+JSON.serialize((MyDataGetTryInfo) JSON.deserialize(info,MyDataGetTryInfo.class))) ;         
            return JSON.serialize((MyDataGetTryInfo) JSON.deserialize(info,MyDataGetTryInfo.class));
            // }
            // else return null;
        }
        else return null; 
        
    }
    
    @AuraEnabled
    public static String ReleasedEventMethod(String v ) {
        MyData MyData = (MyData) JSON.deserialize(v,MyData.class);
        system.debug('MyData in ReleasedEventMethod controller'+MyData);
        system.debug('MyData.uui'+MyData.uui);
        if ( MyData.uui.contains('|')){
            system.debug('MyData.uui'+MyData.uui);
            String tryId = MyData.uui.substringAfter('|');
            AP09_WebService_Avaya.NotifyCallCleared(tryId);
            // to optimize
            String query = 'select id,uui__c,createddate from task where uui__c=\''+MyData.uui+'\' order by CreatedDate  desc limit 1';
            system.debug('query = '+ query );
            list<Task> tsk = Database.query(query);
            system.debug( 'tsk.id ' + tsk[0].id);
            if(tsk.size()!=0) return tsk[0].id;
            else return null;
            
        }
        else return null ; 
    }
    
    
    
    @AuraEnabled
    public static void AcceptTry(String tryId) {
        system.debug('we are in acceptTry controller '+tryId);
        AP09_WebService_Avaya.AcceptTry(tryId);
    }
    
    
    public class MyData {
        String ani;
        String dnsi;
        String eventSource;
        String eventType;
        String queue;
        String ucid;
        String uui;
        String agentId;
    }
    
    public class MyDataGetTryInfo {
        String campaignId;
        String customerReference;
        String comments;
        String CaseID;
        String tryId;
    }
    
    
    
}