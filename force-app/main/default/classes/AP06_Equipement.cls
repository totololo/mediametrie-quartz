/*
* @author: Jerome HE
* @date: 03/01/2022
* @ Description: Classe qui met à jour l'équipement de mesure dans Google sur association et dissociation
* @TestClass: 
* @Coverage: 98%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 20/05/2022					Hatime AIT ISHAQ	Modification du endpoint
*/
public class AP06_Equipement {
    
    
    public static void checkSendToMulesoft(Map<Id, Boolean> listFoyerPanelisteMap){
        
        System.debug('AP06_Equipement Classe');
        List<Foyer_Paneliste__c> foyerPanelisteList = [Select id, foyer__r.foyer_stock__c, Identifiant_foyer_pame__c
                                                       FROM Foyer_paneliste__c 
                                                       where id in : listFoyerPanelisteMap.keySet()];
        
        List<String> assetProvisionningGoogleIds = new List<string>();
        List<String> assetDeprovisionningGoogleIds = new List<string>();
        
        for(Foyer_Paneliste__c foyerPaneliste: foyerPanelisteList) {
            if(listFoyerPanelisteMap.get(foyerPaneliste.Id) && foyerPaneliste.Identifiant_foyer_pame__c != null){
                
                assetProvisionningGoogleIds.add(foyerPaneliste.Id);                
            }
            else if(!listFoyerPanelisteMap.get(foyerPaneliste.Id)){
                
                assetDeprovisionningGoogleIds.add(foyerPaneliste.Id);
            }
        }
        System.debug('AP06_Equipement assetProvisionningGoogleIds: ' + assetProvisionningGoogleIds);
        System.debug('AP06_Equipement assetDeprovisionningGoogleIds: ' + assetDeprovisionningGoogleIds);
 
        if(assetProvisionningGoogleIds.size() > 0 && assetProvisionningGoogleIds != null){
            sendAssetToMulesoft(assetProvisionningGoogleIds,'POST');
        }        
        if(assetDeprovisionningGoogleIds.size() > 0 && assetDeprovisionningGoogleIds != null){
            sendAssetToMulesoft(assetDeprovisionningGoogleIds,'DELETE');
        }
    }
    
    @future(callout=true)
    public static void sendAssetToMulesoft(List<String> listFoyerPanelisteId, String method)
    {
        
        List<Foyer_Paneliste__c> foyerPanelisteList = [Select id, Foyer_Paneliste_ExtId_SIPanel__c, foyer__c
                                                       FROM Foyer_paneliste__c 
                                                       where id in : listFoyerPanelisteId];

        String endpoint;
        
        
        for (Foyer_Paneliste__c foyerPaneliste:foyerPanelisteList) {
            System.debug('AP06_E foyerPaneliste: ' + foyerPaneliste);
            System.debug('AP06_E method: ' + method);
            if (method == 'POST') {
                System.debug('AP06_E POST');
                endPoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google	+'/v1/'+ label.Mulesoft_expAPI_houseHolds
                + '/' + foyerPaneliste.Foyer__c
				+ '?flow=' + label.Mulesoft_flow_parameter_sf_to_google + '&uid='
                + foyerPaneliste.Foyer_Paneliste_ExtId_SIPanel__c;
                System.debug('AP06_E endPoint POST : ' + endPoint);
                
            }
            else if (method == 'DELETE') {
                System.debug('AP06_E DELETE');
                endPoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google	+'/v1/'+ label.Mulesoft_expAPI_houseHolds
                + '/' + foyerPaneliste.Foyer__c
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_google + '&uid='
                + foyerPaneliste.Foyer_Paneliste_ExtId_SIPanel__c;
                System.debug('AP06_E endPoint DELETE: ' + endPoint);
            }
            
            System.debug('AP06_E endPoint: ' + endPoint);
            Http http = new Http();
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());            
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
        if(method=='DELETE' || method=='POST'){
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