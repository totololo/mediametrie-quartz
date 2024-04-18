/*
* @date: 19/10/2021
* @ Description : cette classe appel le flux de commande cordon quand l'utilisateur clique sur le button  "Envoyer à Cordon"
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: 
* @Coverage: 97%
History
* <Date of modification> <Author> 	<Description of modification>
26/04/2022          Téoman Sertçelik    Classe appelé par le lightning flow 
pour envoyer la commande via le bouton 'Envoyer à Cordon'
et provisionner Cordon et retourne la response
* 20/05/2022			Ayoub GHAMMAZ	Modification du endpoint
*/
public class AP02_Commande {
    
    //TEOMAN
    @InvocableMethod(label='Create an Order' description='Create Order using record Id' category='Callout')
    public static List<Boolean> getOrder (List<String> listOrderIds) {
        
        System.debug('$$$listOrderIds: '+ listOrderIds);
        string messageToDisplay = '';
        Boolean fluxAppelle = false;
        List<Boolean> fluxAppelleList = new List<Boolean>();
        fluxAppelle = sendOrder(listOrderIds[0]);
        //If the response contains an error, cast it into a map
        
        
        if(fluxAppelle) {
            fluxAppelleList.add(fluxAppelle);
        }
        return fluxAppelleList;
    }
    
    public static void sendOrderTrigger(List<Order> listOrder) {
        if(listOrder.size()>0 && listOrder != null){
            for(Order o : listOrder){
                sendOrdertoAPITrigger(o.Id);
            }
        }
    }
 
    
    //TEOMAN
    //@future(callout=true)
    public static Boolean sendOrder(String listOrderIdsToSend) {
        //modification AYoub GHMMAZ du 20/05/2022 : debut
        // orders/{orderId}?flow=sf-to-cordon
        
        String baseEndpoint =  'callout:Mulesoft_experience_API/'+'api/'+Label.Mulesoft_Xapp_MM_Sync_Cordon +'/v1/'+ label.Mulesoft_expAPI_orderPath
            + '/' + listOrderIdsToSend
            + '?flow=' + label.Mulesoft_flow_parameter_sf_to_cordon;
        //fin
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        HttpRequest req = createHttpRequest(method, baseEndpoint);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        return true;
    }
    
    @future(callout=true)
    public static void sendOrdertoAPITrigger(String listOrderIdsToSend) {
        //modification AYoub GHMMAZ du 20/05/2022 : debut
        // orders/{orderId}?flow=sf-to-cordon
        
        String baseEndpoint =  'callout:Mulesoft_experience_API/'+'api/'+Label.Mulesoft_Xapp_MM_Sync_Cordon +'/v1/'+ label.Mulesoft_expAPI_orderPath
            + '/' + listOrderIdsToSend
            + '?flow=' + label.Mulesoft_flow_parameter_sf_to_cordon;
        //fin
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        HttpRequest req = createHttpRequest(method, baseEndpoint);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        
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
 
    //FPan
     public static void sendOrderChuteFPanAfterUpdate(List<foyer_Paneliste__c> listFoyerPan) {
      Set<Id> setFPanId = new Set<Id>();
        for(foyer_Paneliste__c fpan : listFoyerPan){
            setFPanId.add(fpan.Id);
        }
        
        List<Order> listOrder = [
            SELECT Id
            FROM Order
            WHERE Foyer_paneliste__c IN :setFPanId
            AND Type = :label.Ord_Type_PackChute
			//AND Status = :label.ORD_Statut_Emise
        ];
       
      System.debug('$$$ In AP02_Commande sendOrderChuteFPanAfterUpdate '  + listOrder);
         
        if(listOrder.size()>0 && listOrder != null){
            for(Order o : listOrder){
                sendOrdertoAPITrigger(o.Id);
            }
        }
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