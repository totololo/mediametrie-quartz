/** 
* @author: Marleine Abi Khalil
* @date: 16/03/2022 
* @description: Appeler mulesoft API pour le deprovisionning google suite a la chute du foyer paneliste
* @Test: Class AP02_IndividuPaneliste_Test
* History
* <Date of modification>   		<Author>   		 <Description of modification>
20/04/2022                   Téoman Sertçelik     Ajouté ids au endpoint // modifié methode future
24/05/2022  Hatime Ait ishaq : modification de la EndPoint


*/
public class AP02_IndividuPaneliste {
    public static void deprovisionningGoogle(List<Individu_Paneliste__c> listIndividuPaneliste, Map<Id, Individu_Paneliste__c> mapOldIndividuPaneliste){
        List<String> listID_IPforDeproviosining = new List<String>();
        
        for(Individu_Paneliste__c indPan : listIndividuPaneliste){
            if(indPan.Date_de_chute_de_l_individu__c != mapOldIndividuPaneliste.get(indPan.Id).Date_de_chute_de_l_individu__c 
               && indPan.Date_de_chute_de_l_individu__c != null){
                   listID_IPforDeproviosining.add(indPan.Id); 
               }
        }
        //TS : added isfuture isbatch 
        if(listID_IPforDeproviosining.size()>0 && !System.isBatch() && !System.isFuture()){
            AP02_IndividuPaneliste.sendForDeprovisionningGoogle(listID_IPforDeproviosining);
        }
    }
    
    @future (callout=true)
    public static void sendForDeprovisionningGoogle(List<String> listID_IPforDeproviosining){ 
        
        List<Individu_Paneliste__c> listIndividuPan = [SELECT Id, Individu_Paneliste_ExtId_SIPanel_c__c,
                                                       Composition_du_foyer__c,foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                       FROM Individu_Paneliste__c
                                                       WHERE Id IN : listID_IPforDeproviosining];
        
        String method = 'DELETE';
        String endpoint;
        Http http = new Http();
        
        //TS
        for(Individu_Paneliste__c indPan : listIndividuPan) {
            //24/05/2022  Hatime Ait ishaq : modification de la EndPoint
            //x-mm-sync-google	/members/{uuid}?flow=sf-to-google&uid
            endpoint = 'callout:Mulesoft_experience_API/' + 'api/' +label.Mulesoft_Xapp_MM_Sync_Google+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath 
                + '/' + indPan.Composition_du_foyer__c
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_google
                + '&uid=' + indPan.foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c ; 
            //fin modification 24/05/2022
            
            HttpRequest req = new HttpRequest();
            req.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
            req.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
            req.setEndpoint(endpoint);
            req.setMethod(method);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
}