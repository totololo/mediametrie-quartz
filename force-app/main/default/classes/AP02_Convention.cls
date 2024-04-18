/*
* @author: Khaled Hammoudeh
* @date: 04/03/2022
* @ Description: Classe qui évoque le flux mulesoft pour récupérer la signature de la convention de Google
* @TestClass: AP02_Convention_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
22/04/2022                   Téoman Sertçelik   modified endpoint + getSigantureConventionFromGoogleFuture to take fpextids + contactextid
* */
public class AP02_Convention {
    
    @InvocableMethod
    public static List<CalloutResponse> getSigantureConventionFromGoogle(list<String> listIndividuPanelisteIds) {
        
        string messageToDisplay = '';
        //system.debug('$$$ KHA' + listAccountExternalIds);
        HTTPResponse resp = getSigantureConventionFromGoogleFuture(listIndividuPanelisteIds);
        
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
    
    //Téoman modified endpoint + getSigantureConventionFromGoogleFuture to take fpextids + contactextid
    //@future (callout=true)
    public static HTTPResponse getSigantureConventionFromGoogleFuture (list<String> listIndividuPanelisteIds)
    {
        HTTPResponse res;
        List<Individu_paneliste__c> listIndividuPanelisteToGet = [SELECT Id, 
                                                                  Composition_du_foyer__c,
                                                                  Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
                                                                  FROM Individu_paneliste__c
                                                                  WHERE Id IN : listIndividuPanelisteIds ]; //LIMIT 1
        
        for(Individu_Paneliste__c ind : listIndividuPanelisteToGet) {
            
            string endpoint = 'callout:Mulesoft_experience_API/'+'api/'+ Label.Mulesoft_Xapp_MM_Sync_Google + '/v1/' + label.Mulesoft_expAPI_agreementsPath 
                + '?flow=' + label.Mulesoft_flow_parameter_google_to_sf
                + '&uuid=' + ind.Composition_du_foyer__c
                + '&uid=' + ind.Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            
            string method = 'POST';
            HttpRequest req = creatHttpRequest(method, endpoint);
            
            system.debug('$$$ KHA ' + endpoint);
            
            Http http = new Http();
            res = http.send(req);
            System.debug(res.getBody());
        }
        
        return res;
    }
    
    public static HttpRequest creatHttpRequest(string method, string endpoint)
    {
        HttpRequest reqToReturn = new HttpRequest();
        reqToReturn.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
        reqToReturn.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
        reqToReturn.setHeader('Accept', 'application/json');
        reqToReturn.setHeader('Content-Type', 'application/json');
        reqToReturn.setEndpoint(endpoint);
        reqToReturn.setMethod(method);
        if(method=='PUT' || method=='POST'){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('description', 'test');
            gen.writeEndObject();
            reqToReturn.setBody(gen.getAsString());
        }
        
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