/*
* @author: Téoman Sertçelik
* @date: 30/03/2022
* @ Description: Classe qui évoque le flux mulesoft pour récupérer l'activité audimétrique de l'ind pan de Google
* @TestClass: AP05_IndividuPaneliste_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 20/04/2022                   Téoman Sertçelik     Ajouté ids au endpoint         
* 19/05/2022				   Ayoub GHAMMAZ		modification du endpoint
* 13/12/2022				   Marliatou Diallo	    Modification paramètre uuid du flux mule
@Coverage: 89%
* */

public with sharing class AP05_IndividuPaneliste {
    
    @InvocableMethod(label='Récupérer activité audimétrique' description='Récupérer activité audimétrique ind pan' category='Callout')
    public static List<CalloutResponse> getIndPanActivityAudiFromGoogle (List<String> listIndPanIds) {
        
        string messageToDisplay = '';
        HttpResponse resp =  getIndPanActivityAudi(listIndPanIds);
        
        //If the response contains an error, cast it into a map
        Map<String, Object> mapResponse = new Map<String, Object>();  
        Map<String, Object> mapError = new Map<String, Object>();
      /*  if(resp.getStatus() != 'OK') {
            mapResponse = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            mapError = (Map<String, Object>) mapResponse.get('error');
        }*/
        
        //Build the response that will be sent back to the flow
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        returnValue.responseStatusCode = resp.getStatusCode();
       /* returnValue.responseErrorReference = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorReference')) ) ? (String) mapError.get('errorReference') : 'undefined';
        returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorDescription')) ) ? (String) mapError.get('errorDescription') : 'undefined';*/
        listReturnValue.add(returnValue);
        
        return listReturnValue;    
    }
    
    //@future(callout=true)
    public static HTTPResponse getIndPanActivityAudi(List<String> listIndPanToGetIds) {
        
        List<Individu_Paneliste__c> ListIndPan = [SELECT Id, Composition_du_foyer__c, 
                                                  Composition_du_foyer__r.CON_ExtId_SIPanel__c, 
                                                  Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                  FROM Individu_Paneliste__c
                                                  WHERE Id in : listIndPanToGetIds];
        String compFoyer;
        String foyerPanExtId;
        
        if(ListIndPan.size()>0) {
            //Modification Marliatou Diallo 13/12/2022
            compFoyer = ListIndPan[0].Composition_du_foyer__c; // Ticket PNL-3515 
            foyerPanExtId = ListIndPan[0].Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
        }
        // modification AYoub GHMMAZ du 19/05/2022 : debut
        String baseEndpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google+'/v1/' + label.Mulesoft_expAPI_audienceActivitiesPath
            + '?flow=' + label.Mulesoft_flow_parameter_google_to_sf 
            + '&uuid=' + compFoyer
            + '&uid=' + foyerPanExtId ;
        //Fin
        String method = 'POST';
        Http http = new Http();
        HttpRequest req = createHttpRequest(method, baseEndpoint);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }
    
    public static HttpRequest createHttpRequest(string method, string endpoint) {
        HttpRequest reqToReturn = new HttpRequest();
        reqToReturn.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
        reqToReturn.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
        reqToReturn.setHeader('Accept', 'application/json');
        reqToReturn.setHeader('Content-Type', 'application/json');
        reqToReturn.setEndpoint(endpoint);
        reqToReturn.setMethod(method);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('description', 'test');
        gen.writeEndObject();
        reqToReturn.setBody(gen.getAsString());
        
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