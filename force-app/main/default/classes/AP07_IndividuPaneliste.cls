/*
* @date: 17/08/2022
* @ Description : appeler API mulesoft Ocom pour envoi du contact à l'update 
* @Auteur : Claire VEHRLE
* @TestClass: AP07_IndividuPaneliste_Test
* @Coverage: -- %
History
* <Date of modification> 		<Author> 	<Description of modification>
* 
*/public class AP07_IndividuPaneliste {
    
    public static void checkIndividuPaneliste(List<Individu_paneliste__c> indPAnList) {
        
        List<String> listIndPanIdsToBeUpdated = new List<String>();
        
        for(Individu_paneliste__c indiPan : indPAnList) {
            if(indiPan.Type_de_panel__c==label.RFP_TypePanel_PaME){
                listIndPanIdsToBeUpdated.add(indiPan.Id);
                
            }
        }
        if(listIndPanIdsToBeUpdated.size()>0 && !System.isBatch() && !System.isFuture()) {
            sendContactToGoogle(listIndPanIdsToBeUpdated);
        }
    }
    
    @future(callout=true)
    public static void sendContactToGoogle (List<String> listIndPanToSend) {
        
        List<Individu_paneliste__c> individuPanList = [SELECT Id, Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c,
                                                       Composition_du_foyer__c
                                                       FROM Individu_paneliste__c
                                                       WHERE Id IN : listIndPanToSend];
        
        String endpoint;
        String method = 'PUT';
        Http http = new Http();
        
        for(Individu_paneliste__c indPan : individuPanList) {
            endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + indPan.Composition_du_foyer__c + '?flow='
                + label.Mulesoft_flow_parameter_sf_to_OCOM + '&uid=' + indPan.Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            //fin
            HttpRequest req = createHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
    
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
}