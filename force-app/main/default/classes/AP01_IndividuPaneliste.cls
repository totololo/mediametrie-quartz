/*
* @author: Jérôme HE
* @date: 25/02/2022
* @ Description 
* @TestClass: AP01_IndividuPaneliste_Test
* @Coverage: 94 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 20/05/2022					Hatime AIT ISHAQ	Modification du endpoint
*/ 
public class AP01_IndividuPaneliste {

    
    @future (callout=true)
    // Imad comment Set instead of List
     public static void provisioningGoogleFlow(list<String> listIndPanToUpdate)
     //  public static void provisioningGoogleFlow(Set<Id> listIndPanToUpdate)

    {
        
        List<Individu_Paneliste__c> indPanList = [Select Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c, composition_du_foyer__c
                                                  from Individu_Paneliste__c where id in : listIndPanToUpdate AND Foyer_paneliste__r.Referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_PaME];
        system.debug('Imad Msg' + indPanList);
        for(Individu_paneliste__c indPan : indPanList){
            //modification Hatime AIT ISHAQ du 20/05/2022 : debut
            //members/{uuid}?flow=sf-to-google&uid
            
           String endPoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + indPan.composition_du_foyer__c +'?flow=' + label.Mulesoft_flow_parameter_sf_to_google
                + '&uid=' + indPan.Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            
          /*  String serviceName= 'x-mm-sync-google-prep';
              String endPoint = 'callout:Mulesoft_experience_API/'+'api/'+serviceName+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + indPan.composition_du_foyer__c +'?flow=' + label.Mulesoft_flow_parameter_sf_to_google
                + '&uid=' + indPan.Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            */
            string method = 'POST';
            //fin
            HttpRequest req = creatHttpRequest(method, endpoint);
            
            Http http = new Http();
            HTTPResponse resp = http.send(req);
            
            //If the response contains an error, cast it into a map
            Map<String, Object> mapResponse = new Map<String, Object>();
            Map<String, Object> mapError = new Map<String, Object>();
            system.debug('Imad Body msg: '+ resp.getBody());  
            system.debug('Imad Status Msg: '+ resp.getStatus()); 
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
            
        }             
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