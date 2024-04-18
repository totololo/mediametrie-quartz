/*
* @author: Ayoub GHAMMAZ
* @date: 23/02/2022
* @ Description: 
* @TestClass: AP01_LienMeter_test
* @Coverage: 100%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
  24/05/2022  Hatime Ait ishaq : modification de la EndPoint
* */
public class AP01_LienMeter {
    @InvocableMethod
	public static List<CalloutResponse> GetLienMeter(List<Id> IndivPanId) {// le flux envoie un seul 
        
       HTTPResponse resp = getContactFromSipanelFuture(IndivPanId);
        //LA
        system.debug('response' + resp);
        system.debug('response' + resp.getBody());

       //If the response contains an error, cast it into a map
        //LA mettre les variables mapResponse et mapError en string
        //Map<String, Object> mapResponse = new Map<String, Object>();
        //Map<String, Object> mapError = new Map<String, Object>();
        //String mapResponse;
		
        //LA TS
        Map<String, String> mapResponse = new Map<String, String>();
        String error;
        if(resp.getStatus() != 'OK' && resp.getStatus() != 'Created') {
            //LA
            /*mapResponse = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            mapError = (Map<String, Object>) mapResponse.get('error');*/      
            //LATS
            System.debug('response  '+resp);
            //mapResponse = (Map<String, String>) JSON.deserialize(resp.getBody(), Map<String, String>.class);
			//error = mapResponse.get('error');
            try {
                   mapResponse = (Map<String, String>) JSON.deserialize(resp.getBody(), Map<String, String>.class);
                } catch (Exception e) {
                    error = mapResponse.get('error');
                    System.debug(e.getMessage());
                }
                        
        }
        //Build the response that will be sent back to the flow
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        
        returnValue.responseStatusCode = resp.getStatusCode();
        
        //LATS
        returnValue.responseErrorReference = ( (resp.getStatus() != 'OK' && resp.getStatus() != 'Created') && (error?.indexOf('errorReference') == 1 )) ? 'errorReference' : 'undefined';
        returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK' && resp.getStatus() != 'Created') && (error?.indexOf('errorDescription') == 1 )) ? 'errorDescription' : 'undefined';

        //LA
        //returnValue.responseErrorReference = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorReference')) ) ? (String) mapError.get('errorReference') : 'undefined';
        //returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorDescription')) ) ? (String) mapError.get('errorDescription') : 'undefined';
        system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;
         
    }
     public static HTTPResponse getContactFromSipanelFuture(list<String> listContactExternalIds)
    {
      	List<Individu_Paneliste__c> ListIndPan = [SELECT Id, 
          Composition_du_foyer__c,Composition_du_foyer__r.CON_ExtId_SIPanel__c, 
                                                         Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                  FROM Individu_Paneliste__c
                                                  WHERE Id in : listContactExternalIds];
        
        String conId;                                         
        String conExtId;
        String foyerPanExtId;
        
        if(ListIndPan.size()>0) {
            conId = ListIndPan[0].Composition_du_foyer__c;
            conExtId = ListIndPan[0].Composition_du_foyer__r.CON_ExtId_SIPanel__c;
            foyerPanExtId = ListIndPan[0].Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
        }
            //24/05/2022  Hatime Ait ishaq : modification de la EndPoint
            // /meters?flow=google-to-sf&uuid&uid
        string endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google+'/v1/' + label.Mulesoft_expAPI_meterPath
                                    + '?flow=' + label.Mulesoft_flow_parameter_google_to_sf 
                                   //    + '&uuid=' + conExtId
                                   + '&uuid=' + conId
                                    + '&uid=' + foyerPanExtId;
       // HttpRequest req = creatHttpRequest(method, endpoint);
       
          string method = 'POST';
        HttpRequest req = creatHttpRequest(method, endpoint);
        
        system.debug('$$$ KHA ' + endpoint);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
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