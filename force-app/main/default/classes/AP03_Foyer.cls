/*
* @author: Khaled Hammoudeh
* @date: 08/02/2021
* @ Description: classe qui fait appel get vers l'application experience des assets pour mettre à jour les équipements liés à un certain foyer
* @TestClass: 
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*  11.08.2021				  MZ		Modified getAssetsFromSipanelFuture and getAssetsFromSipanel to wait for the HTTP response
*										and return the error details to the flow
*/
global class AP03_Foyer {
    
    @InvocableMethod
    public static List<CalloutResponse> getAssetsFromSipanel(list<String> listAccountExternalIds) {
       
        system.debug('$$$ KHA' + listAccountExternalIds);
        HTTPResponse resp = getAssetsFromSipanelFuture(listAccountExternalIds);
        
        //If the response contains an error, cast it into a map
        Map<String, Object> mapResponse = new Map<String, Object>();
        Map<String, Object> mapError = new Map<String, Object>();
        if(resp.getStatus() != 'OK') {
            mapResponse = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            mapError = (Map<String, Object>) mapResponse.get('error');
        }
        
        //Build the response that will be sent back to the flow
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        returnValue.responseStatusCode = resp.getStatusCode();
        returnValue.responseErrorReference = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorReference')) ) ? (String) mapError.get('errorReference') : 'undefined';
        returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorDescription')) ) ? (String) mapError.get('errorDescription') : 'undefined';
        system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;
       
    }
    
    //@future (callout=true)
    public static HTTPResponse getAssetsFromSipanelFuture (list<String> listAccountExternalIds)
    {
        string endpoint = 'callout:Mulesoft_experience_API/' + label.Mulesoft_expAPI_assetPath + '/' 
                        + label.Mulesoft_expAPI_getAssets + '/' + listAccountExternalIds[0];
        string method = 'GET';
        HttpRequest req = creatHttpRequest(method, endpoint);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }
    
    public static HttpRequest creatHttpRequest(string method, string endpoint)
    {
        HttpRequest reqToReturn = new HttpRequest();
        reqToReturn.setHeader('client_id', label.Mulesoft_expAPI_clientId);
        reqToReturn.setHeader('client_secret', label.Mulesoft_expAPI_clientSecret);
        reqToReturn.setEndpoint(endpoint);
        reqToReturn.setMethod(method);
        
        return reqToReturn;
    }
    
    //Wrapper used to return the HTTP response to the visual flow
    public class CalloutResponse {
        @InvocableVariable
        public String responseStatus;
        
        @InvocableVariable
        public Integer responseStatusCode;
        
        @InvocableVariable
        public String responseErrorReference;
        
        @InvocableVariable
       	public String responseErrorDescription;
    }
}