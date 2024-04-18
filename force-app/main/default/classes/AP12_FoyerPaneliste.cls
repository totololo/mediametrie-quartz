/*
* @date: 11/08/2023
* @ Description : Envoie foyer Panéliste Nielsen
* @Auteur Claire VEHRLE
* @TestClass: AP12_FoyerPaneliste_Test
* @Coverage: --%
History
* <Date of modification> 		<Author> 	<Description of modification>
*
*/
public class AP12_FoyerPaneliste {
    
    @InvocableMethod
    public static void creationFoyerPaneliste(List<String> foyerPanelisteIdList) {
            callMulesoft(foyerPanelisteIdList);
    }
    
    @future(callout=true)
    public static void callMulesoft(List<String> foyerPanelisteIdToSend) {
        
        
        for(String idValue :foyerPanelisteIdToSend){
            String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Nielsen+'/v1/'+label.Mulesoft_expAPI_houseHolds + '/' + idValue; 
            String method = 'POST';
            
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

}