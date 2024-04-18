/*
* @date: 17/08/2022
* @ Description : appeler API mulesoft Ocom pour envoi du contact à l'update 
* @Auteur : Claire VEHRLE
* @TestClass: AP03_MembreDuFoyer_Test
* @Coverage: -- %
History
* <Date of modification> 		<Author> 	<Description of modification>
* 
*/
public class AP03_MembreDuFoyer {

    public static void checkContact(List<Contact> listContact) {
        
        List<String> listContIdsToBeUpdated = new List<String>();
        
        for(Contact ct : listContact) {
            listContIdsToBeUpdated.add(ct.Id);
        }
        if(listContIdsToBeUpdated.size()>0 && !System.isBatch() && !System.isFuture()) {
            sendContactToGoogle(listContIdsToBeUpdated);
        }
    }
    
    @future(callout=true)
    public static void sendContactToGoogle (List<String> listContactToSend) {
                
        List<Individu_paneliste__c> individuPanList = [SELECT Id, Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c,
                                                       Composition_du_foyer__c
                                                       FROM Individu_paneliste__c
                                                       WHERE Composition_du_foyer__c IN : listContactToSend];
        
        String endpoint;
        String method = 'PUT';
        Http http = new Http();
        
        for(Individu_paneliste__c indPan : individuPanList) {
            //modification AYoub GHMMAZ du 20/05/2022 : debut
            // members/{uuid}?flow=sf-to-google&uid
            endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + indPan.Composition_du_foyer__c + '?flow='
                + label.Mulesoft_flow_parameter_sf_to_OCOM + '&uid=' + indPan.Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            //fin
            HttpRequest req = createHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
        /*try {
        	update listFoyerPan;
        } catch (Exception e) {
        	System.debug('exception caught while updating the contacts : ' + e);
        } */
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