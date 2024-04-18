/**
* @description       : Docs avaya Apixit-Médiamétrie : CCTelDialer CRM  
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-26-2022
* @last modified by  : Anes BOUZOUINA
**/


public with sharing class AP09_WebService_Avaya {
    public static HttpResponse callRequest(String endpoint,String method, String body,string authorizationHeader ){
        String Url = label.URL_AVAYA+'/api/' + endpoint;
        Http http =new Http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(Url);
        req.setTimeout(120000);
        req.setMethod(method);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // secure the token 
        if(authorizationHeader== null)
            req.setHeader('Authorization', 'Bearer ' + 'pfs3MqFwRBuyocHFNsmC4Q/pG9GGgukUPRx9wE0TAIs/OGMvPNJ8mOYg6rCOpos4+caaNs64w1+WZAdCdFMALojDueM0GRa9yjXyKnIMx5TUGtZ4HrEThv2HW0uhG7YG');
        else req.setHeader('Authorization',authorizationHeader );
        req.setBody(body);
        HttpResponse res=http.send(req);
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         res.getStatusCode() + ' ' + res.getStatus());
            //SendBugEmail.SendBugEmail(string.valueof(res.getStatus()));
        } else {
            System.debug('response status = '+res.getStatus());
            System.debug('response body = '+res.getBody());
        }
        return res ; 
    }
    
    
    
    public static String GetTryInfo(String tryID) {
        system.debug('we are in getTryInfo method tryId = '+tryId);
        String tags = '{"tryId": "'+tryID + '" }';
        String Url = label.URL_AVAYA+'/api/GetTryInfo'+'?tryId='+tryId;
        Http http =new Http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint(Url);
        req.setTimeout(120000);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // secure the token 
        req.setHeader('Authorization', 'Bearer ' + 'pfs3MqFwRBuyocHFNsmC4Q/pG9GGgukUPRx9wE0TAIs/OGMvPNJ8mOYg6rCOpos4+caaNs64w1+WZAdCdFMALojDueM0GRa9yjXyKnIMx5TUGtZ4HrEThv2HW0uhG7YG');
        // req.setBody(body);
        HttpResponse res=http.send(req);
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         res.getStatusCode() + ' ' + res.getStatus());
            system.debug(' res.getBody() '+ res.getBody());
        } else {System.debug(res.getBody());}
        
        return res.getBody();}
    
    
    @AuraEnabled
    public static void AcceptTry(String tryID) {
        //call it frop lwc or visualfroce page because of waiting time 
        List<User> u = [select id,Name,username from User where id =: userInfo.getUserId() limit 1];
        String tags = '{"tryId": "'+tryID + '","agentId": "'+u[0].username+'","pbxAgentID": "\'\' ", "comments": "\'\' " }';
        system.debug('#### Input JSON in acceptTry: ' + tags); 
        callRequest( 'AcceptTry', 'POST',  tags , null );
    }
    
    @AuraEnabled
    public static void NotifyCallCleared(String tryID) {
        List<User> u = [select id,Name,username from User where id =: userInfo.getUserId() limit 1];
        String tags = '{"tryId": "'+tryID + '","agentId": "'+u[0].username+'","pbxAgentID": "\'\'", "comments": "\'\'" }';
        system.debug('#### we are in the  NotifyCallCleared method Input JSON: ' + tags); 
        callRequest( 'NotifyCallCleared', 'POST',  tags,null );
    }
    
    @future (callout=true)
    public static void QualifyTry(String tryID,String qualificationCase) {
        List<User> u = [select id,Name,username from User where id =: userInfo.getUserId() limit 1];
        
        String tags = '{"tryId": "'+tryID + '","agentId": "'+u[0].username+'","pbxAgentID": "\'\' ","qualificationCase": "'+qualificationCase+'", "comments": "\'\' " }';
        system.debug('#### Input JSON: ' + tags); 
        callRequest( 'QualifyTry', 'POST',  tags ,null );
    }
    
    
    @AuraEnabled
    public static void PrepareListOfCalls(List<Appel__c> appelLst, String Status) {
        String errorTxt ='';
        String userName = 'SalesforceDialerUser'; // app clientID
        String passWord = 'fEEjqVB0ZXvXwhotl0AQlvsm9nB/tic7VyBRjw+8JO2v7EYJrMMTGdHWiSd/3m+qfZikV1zw50tCNYJFBRsO+BVhDsRC3BWaaplftcAF934='; // app clientSecret
        
        system.debug('Hey we are in the PrepareListOfCalls class / Test Anes ');
        system.debug(appelLst);  
        String tags = '';
        String tel1=' ';
        String tel2=' ';
        
        for(Appel__c apItr:appelLst){
            //E.164 format
            if(apItr.Telephone1__c!=null && apItr.Telephone1__c!=''){
                tel1=apItr.Telephone1__c;
            }
            if(apItr.Telephone2__c!=null && apItr.Telephone2__c!=''){
                tel2=apItr.Telephone2__c;
            }
            
            
            if(tags == ''){
                tags =  '{"campaignID": "'+apItr.Campagne_Id_Avaya__c+'","telephone1": "'+tel1+'","telephone2": "'+tel2+'", "startingDateTime": "","customerReference": "'+apItr.account__c+'", "customerScreenPopupURL": "","maximumNumberOfTries":"0","ownerId": "SFDC", "status":"'+Status+'"  ,"comments": "' +apItr.Campaign__r.Temps_dattente__c+ '" },';
            }
            else {
                tags +=   '{"campaignID": "'+apItr.Campagne_Id_Avaya__c+'","telephone1": "'+tel1+'","telephone2": "'+tel2+'", "startingDateTime": "","customerReference": "'+apItr.account__c+'", "customerScreenPopupURL": "","maximumNumberOfTries":"0","ownerId": "SFDC", "status":"'+Status+'"  ,"comments": "' +apItr.Campaign__r.Temps_dattente__c+ '" },';
                
            }
            system.debug('#### Input tags: ' + tags); 
            
        }
        tags='['+tags.removeEnd(',')+']';
        //tags='[ { "campaignID": "TEST-WEB-SERVICE1", "telephone1": "+33630743325", "telephone2": "", "startingDateTime": "10112022173000", "customerReference": "Reference-06102022-001", "customerScreenPopupURL": "https://www.toto.com", "maximumNumberOfTries": 0, "ownerId": "SALESFORCE_USER ...", "status": "ACTIVE", "comments": "THIS IS A TESTING!" }, { "campaignID": "TEST-WEB-SERVICE1", "telephone1": "+33611562625", "telephone2": "", "startingDateTime": "10112022173000", "customerReference": "Reference-06102022-002", "customerScreenPopupURL": "https://www.avaya.com/toto", "maximumNumberOfTries": 0, "ownerId": "SALESFORCE_USER ...", "status": "ACTIVE", "comments": "THIS IS A TESTING!" }]';
        system.debug('#### Input JSON: ' + tags); 
        
        Blob headerValue = Blob.valueOf(userName + ':' + passWord);
        String authorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(headerValue);
        HttpResponse res= callRequest( 'PrepareListOfCalls', 'PUT',  tags, authorizationHeader );
        String str = res.getbody();
        system.debug('str '+str );
        MyData MyData = (MyData) JSON.deserialize(str,MyData.class);
        system.debug('MyData.preparedCallsResults '+MyData.preparedCallsResults);
        errorTxt = 'Erreur durant la création de quelques appels dans le CCTel Dialer  : ' + string.valueof(MyData) + '\n';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B003_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName('Batch Création des Appels dans le CCtel dialer');
        mail.setSubject(System.Label.BatchNotif_Creation_Appel+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch022_CreateAvayaCalls s\'est terminée.\n';
        
        if(MyData.numberOfCallsProcessedWithFailure>0){
            emailBody += 'Les résultats du retour du CCtel Dialer sont les suivantes :\n\n';
            emailBody += errorTxt;
        }
        else{
            emailBody += 'Aucune erreur n\'a été relevée.';
            
        }
        if(Status=='ACTIVE'){
            mail.setPlainTextBody(emailBody);
            if(!Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  } 
        }
    }
    
    
    public class MyData {
        String comments;
        String result;
        Integer numberOfCallsProcessedSuccessfully;
        Integer numberOfCallsProcessedWithFailure;
        List<MyDataPreparedCallsResults> preparedCallsResults = new List<MyDataPreparedCallsResults>();
    }
    public class MyDataPreparedCallsResults {
        String customerReference;
        String result;
        String comments;
    }
    
    
}