/*
* @date: 19/10/2021
* @ Description : cette classe est invoque par les triggers equipementAfterUpdate afin d'envoyer des 
informations a ocom via un flux mulesoft
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: 
* @Coverage: 97%
History
* <Date of modification> 		<Author> 	<Description of modification>
*      27/01/2022  				Jérôme			Send asset to ocom
* 24/05/2022					Ayoub GHAMMAZ	Modification du endpoint
*/
public class AP02_Equipement {
   
    public static void DissocierEquipementOcom (Map<String,String> assetFoyerPanelisteMap) {
        
        Map<String, String> foyerPanelisteExtId = new Map<String, String>();
        List<String> assetIdToSend = new List<String>();
        List<String> foyerPanelisteExtIdToSend = new List<String>();
        List<Foyer_Paneliste__c> foyerPanelisteList = [SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c FROM Foyer_Paneliste__c 
                                                      WHERE Id IN :assetFoyerPanelisteMap.values()];
        System.debug('foyerPanelisteListt' + foyerPanelisteList);  //
        
        for(foyer_Paneliste__c foyerPan:foyerPanelisteList) {
            System.debug('foyerPanelisteList' + foyerPanelisteList);  //
            foyerPanelisteExtId.put(foyerPan.Id, foyerPan.Foyer_Paneliste_ExtId_SIPanel__c);
        }

        for(String AssetId:assetFoyerPanelisteMap.keySet()) {
            if(assetFoyerPanelisteMap.get(AssetId) != null) {
                assetIdToSend.add(AssetId);
                foyerPanelisteExtIdToSend.add(foyerPanelisteExtId.get(assetFoyerPanelisteMap.get(AssetId)));
            }
        }
        DissocierEquipementOcomAppelMulesoft(assetIdToSend, foyerPanelisteExtIdToSend);
    }
    
    @future(callout=true)
    public static void DissocierEquipementOcomAppelMulesoft(List<String> assetListToSend,List<String> foyerPanelisteExtIdToSend){
        //modification AYoub GHMMAZ du 20/05/2022 : debut
        Map<Id, Asset> assetIdMap = new Map<Id, Asset>();
        List<Asset> listAssToUpdate = [SELECT Id, accountId
                                       FROM asset
                                       WHERE Id IN :assetListToSend];
        
        for(Asset eqt: listAssToUpdate) {
            assetIdMap.put(eqt.Id, eqt);
        }
        System.debug('$$$DissocierEquipementOcomAppelMulesoft assetListToSend : ' + assetListToSend);
        
        String endpoint;
        String method = 'PUT';
        Integer i = 0;
        for(String thisAsset : assetListToSend) {
            //households/{gid}/meters/{meterId}?flow=sf-to-ocom&uid
            endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/' + label.Mulesoft_expAPI_houseHolds
                +'/'+ assetIdMap.get(thisAsset).accountId +'/'+label.Mulesoft_expAPI_meterPath+'/'+ thisAsset+ '?flow=' + label.Mulesoft_flow_parameter_sf_to_OCOM
                + '&uid=' + foyerPanelisteExtIdToSend[i] ;
            //fin
            System.debug('$$$DissocierEquipementOcomAppelMulesoft endpoint : ' + endpoint);
            /*
            Http http = new Http();
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            */
            //updated by Elyes on 30/11/2022
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
            req.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
            req.setEndpoint(endpoint);
            req.setMethod(method);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            System.debug('$$$DissocierEquipementOcomAppelMulesoft reponse : ' + res.getStatus());
            i ++;
        }
    }
    
    @future (callout=true)
    public static void PutMeterConfMetier(List<String> listAssetToUpdate){
        
        String method = 'PUT';
        Http http = new Http();
        String endpoint;
        //modification AYoub GHMMAZ du 20/05/2022 : debut
        List<Asset> listAssToUpdate = [SELECT Id, Audimetre__c, foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c, account.Id
                                       FROM asset
                                       WHERE Id = :listAssetToUpdate];
        
        
        for(asset thisAsset : listAssToUpdate) {
            //households/{gid}/meters/{meterId}?flow=sf-to-ocom&uid
            endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/' + label.Mulesoft_expAPI_houseHolds
                +'/'+thisAsset.account.Id+'/'+label.Mulesoft_expAPI_meterPath+'/'+thisAsset.id+ '?flow=' + label.Mulesoft_flow_parameter_sf_to_OCOM
                + '&uid=' + thisAsset.foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c ;
            //fin
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            thisAsset.Date_du_dernier_appel__c = System.now();
            
            /*if(res.getStatus() == 'OK') {
                //No errors returned from the system
                thisAsset.Appel_OK_KO__c = 'OK';
                thisAsset.Message_en_cas_d_erreur__c = '';
            } else {
                //Store the error return on the record
                system.debug('body >> ' + res.getBody());
                if(res.getBody() != null && res.getBody() != '') {
                    Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Map<String, Object> mapError = (Map<String, Object>) mapResponse.get('error');
                    thisAsset.Appel_OK_KO__c = 'KO';
                    thisAsset.Message_en_cas_d_erreur__c = 'ERROR CODE : ' + res.getStatusCode();
                    thisAsset.Message_en_cas_d_erreur__c += '\nERROR REFERENCE : '
                        + (mapError.containsKey('errorReference')? (String) mapError.get('errorReference') : 'undefined');
                    thisAsset.Message_en_cas_d_erreur__c += '\nERROR DESCRIPTION : '
                        + (mapError.containsKey('errorDescription')? (String) mapError.get('errorDescription') : 'undefined');
                }
            }*/
        }
        /*try {
            update listAssToUpdate;
        } catch (Exception e) {
            System.debug('exception caught while updating the orders : ' + e);
        }*/
        
    }
    
    /*public static void checkSendAssetToOcom(List<Asset> AssetList){
        Boolean isIntegration = UserInfo.getUserName() == Label.Mulesoft_integrationUser_username;
        list<String> assetToSend = new List<String>();
        
        if(!isIntegration){
            for(Asset ass : AssetList){
                assetToSend.add(String.valueOf(ass.Audimetre__c));
            }
        }
        
        PutMeterToOcom(assetToSend);
    }
    
    @future (callout=true)
    public static void PutMeterToOcom(List<String> assetToSend){
        string method ='PUT';
        HTTP http = new HTTP();
        string endPoint;
        
        List<Asset> listAssetToUpdate = [SELECT Id, Audimetre__c ,foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
                                         FROM Asset
                                         WHERE Audimetre__c = :assetToSend];
        
        for(Asset asset : listAssetToUpdate){
            //meters?flow=sf-to-ocom&uid
            endPoint ='callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+label.Mulesoft_expAPI_meterPath+'?flow='+label.Mulesoft_flow_parameter_sf_to_OCOM+'&'+
                asset.foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c; 
            // fin
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            if(res.getStatus() == 'OK') {
                //No errors returned from the system
                asset.Appel_OK_KO__c = 'OK';
                asset.Message_en_cas_d_erreur__c = '';
            } else {
                if(res.getBody() != null && res.getBody() != '') {
                    Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Map<String, Object> mapError = (Map<String, Object>) mapResponse.get('error');
                    asset.Appel_OK_KO__c = 'KO';
                    asset.Message_en_cas_d_erreur__c = 'ERROR CODE : ' + res.getStatusCode();
                    asset.Message_en_cas_d_erreur__c += '\nERROR REFERENCE : '
                        + (mapError.containsKey('errorReference')? (String) mapError.get('errorReference') : 'undefined');
                    asset.Message_en_cas_d_erreur__c += '\nERROR DESCRIPTION : '
                        + (mapError.containsKey('errorDescription')? (String) mapError.get('errorDescription') : 'undefined');
                }
            }
        }
        
        
        try {
            update listAssetToUpdate;
        } catch (Exception e) {
            System.debug('exception caught while updating the assets : ' + e);
        }
        }
        
    }*/
    
    
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
}