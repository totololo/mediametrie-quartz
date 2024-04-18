/** 
* @author: Marleine Abi Khalil
* @date: 21/03/2022 
* @description: Appeler mulesoft API pour envoyer les foyers panélistes d'un compte à la modification de l'un de ses foyers panélistes
* @Test: Class AP07_FoyerPaneliste_Test
* <Date of modification>   		<Author>   		 <Description of modification>
* 25/05/2022				   Ayoub GHAMMAZ		modification du endpoint
*/
public class AP07_FoyerPaneliste {
    public static void envoyerFoyerPanDuCompte(Set<String> listFoyerPaneliste) {
        
        envoyerAMulesoft(listFoyerPaneliste);        
    }
    
     
    @future (callout=true)
    public static void envoyerAMulesoft(Set<String> setExtIds){
        // change endpoint accordingly (create new labels and add the values)
        // modification AYoub GHMMAZ du 19/05/2022 : debut
        // x-mm-sync-sipanel/v1/households/{gid}?flow=sf-to-sipanel&uid
        List<Foyer_paneliste__c> ListIndPan = [SELECT Id,Foyer_Paneliste_ExtId_SIPanel__c , foyer__c
                                               FROM Foyer_paneliste__c
                                               WHERE Id in : setExtIds];
        for(Foyer_paneliste__c fp :ListIndPan ){
            System.debug('*** External Id: ' + fp.foyer__c);
            String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_houseHolds + '/'+ fp.foyer__c
                + '?flow='+label.Mulesoft_flow_parameter_sf_to_sipanel+'&uid='+fp.Foyer_Paneliste_ExtId_SIPanel__c;
            String method = 'PUT';
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
            req.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setMethod(method);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('description', 'test');
            gen.writeEndObject();
            req.setBody(gen.getAsString());
            
            req.setEndpoint(endpoint);
            req.setMethod(method);
            
            HTTPResponse res = http.send(req);
            System.debug('***Http response: ' + res.getBody());
        }
    }
    @InvocableMethod
    public static void updateFoyerPanelisteAMulesoft(List<String> idsList) {
        Set<String> idsSet = new Set<String>(idsList);
        envoyerAMulesoft(idsSet);
    }
    
    
    /*public static void envoyerAMulesoftBatch(Set<String> setExtIds){
        // change endpoint accordingly (create new labels and add the values)
        // modification Bastien PINARD du 22/09/2022 : debut
        // x-mm-sync-sipanel/v1/households/{gid}?flow=sf-to-sipanel&uid
        List<Foyer_paneliste__c> ListIndPan = [SELECT Id,Foyer_Paneliste_ExtId_SIPanel__c , foyer__c
                                               FROM Foyer_paneliste__c
                                               WHERE foyer__r.ACC_ExtId_SIPanel__c in : setExtIds];
        for(Foyer_paneliste__c fp :ListIndPan ){
            System.debug('*** External Id: ' + fp.foyer__c);
            String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_houseHolds + '/'+ fp.foyer__c
                + '?flow='+label.Mulesoft_flow_parameter_sf_to_sipanel+'&uid='+fp.Foyer_Paneliste_ExtId_SIPanel__c;
            String method = 'PUT';
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
            req.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setMethod(method);
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('description', 'test');
            gen.writeEndObject();
            req.setBody(gen.getAsString());
            
            req.setEndpoint(endpoint);
            req.setMethod(method);
            
            HTTPResponse res = http.send(req);
            System.debug('***Http response: ' + res.getBody());
        }
    }*/
}