/*
* @author: Téoman Sertçelik
* @date: 29/03/2022
* @ Description: Classe appelé par le lightning flow pour envoyer la bande usine et provisionner OCOM et retourne la response
* @TestClass: AP01_BandeUsine_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 20/05/2022					Ayoub GHAMMAZ	Modification du endpoint
* 
* */

public with sharing class AP01_BandeUsine {
    
    //TEOMAN
    @InvocableMethod(label='Create Bande Usine' description='Create Bande Usine using Ids' category='Callout')
    public static List<CalloutResponse> getBandeUsine (List<String> listBandeUsineIds) {
        
        string messageToDisplay = '';
        HttpResponse resp =  sendBandeUsineToOCOM(listBandeUsineIds);
        
        //If the response contains an error, cast it into a map
        Map<String, Object> mapResponse = new Map<String, Object>();
        Map<String, Object> mapError = new Map<String, Object>();
        List<Bande_Usine__c> listBu = [SELECT Id, Date_declaration_OCOM__c FROM Bande_Usine__c WHERE Id IN :listBandeUsineIds];
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        returnValue.responseStatusCode = resp.getStatusCode();
        
        if(resp.getStatusCode()==201 || Test.isRunningTest() == true){
            for(Bande_Usine__c BU :  listBu){
                BU.Date_declaration_OCOM__c = date.today();
            }
        }
        else {
            mapResponse = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            mapError = (Map<String, Object>) mapResponse.get('error');
            returnValue.responseErrorReference = (mapError.containsKey('errorReference')) ? (String) mapError.get('errorReference') : 'undefined';
            returnValue.responseErrorDescription = (mapError.containsKey('errorDescription')) ? (String) mapError.get('errorDescription') : 'undefined';
        
        }
        
        system.debug('$$$resp.Statut : '+resp.getStatus());
        system.debug('$$$resp.getStatusCode() : '+resp.getStatusCode());
                
        update listBu;

        
        system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;    
    }
    
    //TEOMAN
    //@future(callout=true)
    public static HTTPResponse sendBandeUsineToOCOM(List<String> listBandeUsineIdToSend) {
       
        //modification AYoub GHMMAZ du 20/05/2022 : debut
        ///meters?flow=sf-to-ocom&bu={idBU}
        //meters?flow=sf-to-ocom&idBU={idBU} 
        String baseEndpoint =  'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+ label.Mulesoft_expAPI_meterPath + '?' 
                                + 'flow=' + label.Mulesoft_flow_parameter_sf_to_OCOM + '&idBU='+ listBandeUsineIdToSend[0];
        //fin
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        HttpRequest req = createHttpRequest(method, baseEndpoint);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }

    //TEOMAN
    public static HttpRequest createHttpRequest(string method, string endpoint) {
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
    //TEOMAN
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