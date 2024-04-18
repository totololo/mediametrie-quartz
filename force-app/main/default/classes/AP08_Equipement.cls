/*
* @date: 09/08/2023
* @ Description : Appel flux mulesoft. Stremaing meter passé au statut désinstallé 
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP08_Equipement_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP08_Equipement {

    public static void desintallationStreamingMeter(List<Asset> assetList) {
        List<String> assetIdToSend = new List<String>();
        for(Asset eqtMesure:assetList) {
            assetIdToSend.add(eqtMesure.Id);
        }
        callMulesoft(assetIdToSend);
    }
    
    @future(callout=true)
    public static void callMulesoft(List<String> assetIdList) {
        List<Asset> assetToUpdate = new List<Asset>();
        List<Id> eqtMesureId = new List<Id>();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceList = new List<Statut_Device_Equipement_Mesure__c>();
        List<asset> assetList = [SELECT Id,Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c, serialNumber, status, Foyer_paneliste__c, AccountId
                                               FROM Asset
                                               WHERE Id in : assetIdList];
        Account getStation = [SELECT Id FROM Account WHERE name = :Label.ACC_CompteStock_Station];
        
        for(Asset eqtMesure :assetList ){
            String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Nielsen+'/v1/'+label.Mulesoft_expAPI_houseHolds + '/'
                + eqtMesure.Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c + '/streaming-meters/' + eqtMesure.SerialNumber + '/uninstall'; 
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
            JSONParser parser = JSON.createParser(res.getBody());
            
            
            while (parser.nextToken() != null) {
                System.debug('***parser.getCurrentToken(): ' + parser.getCurrentToken());
                System.debug('***parser.getText(): ' + parser.getText());
                if(parser.getText() == 'result') {
                    parser.nextToken();
                    // Changer OK par la bonne valeur
                    if(parser.getText() == 'success') {
                        eqtMesure.Status = Label.ASS_Statut_Valide;
                        eqtMesure.AccountId = getStation.Id;
                        eqtMesure.Foyer_paneliste__c = null;
                        eqtMesureId.add(eqtMesure.Id);
                        assetToUpdate.add(eqtMesure);
                        System.debug('***error ');
                    }
                    else {
                        System.debug('***ERROR ELSE');
                    }
                }
            }
        }
        
        statutDeviceList = [SELECT Id, equipement_de_mesure__c FROM Statut_Device_Equipement_Mesure__c WHERE equipement_de_mesure__c IN :eqtMesureId];
        for(Statut_Device_Equipement_Mesure__c statutDevice:statutDeviceList) {
            statutDevice.equipement_de_mesure__c = null;
        }
        
        if(assetToUpdate != null && assetToUpdate.size()>0) {
            try { 
                update assetToUpdate;
            } Catch(exception ex){
                system.debug('Echec Update retour nilsen:'+ex.getmessage());
            }  
        }
        if(statutDeviceList != null && statutDeviceList.size()>0) {
            try { 
                update statutDeviceList;
            } Catch(exception ex){
                system.debug('Echec Update retour nilsen:'+ex.getmessage());
            }  
        }
        
    }
}