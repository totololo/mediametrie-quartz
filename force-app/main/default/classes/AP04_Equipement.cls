/** 
* @author: Marleine Abi Khalil
* @date: 28/03/2022 
* @description: Appeler mulesoft API pour envoyer l'equipement de mesure à OCOM si statut passe à 'Supprimé'
* @Test: Class AP04_Equipement_Test
** History
* <Date of modification>   <Author>    <Description of modification>		
*  20/04/2022              Téoman Sertçelik    changed endpoint
* 20/05/2022					Hatime AIT ISHAQ	Modification du endpoint
* @Coverage : 100%
*/
public class AP04_Equipement {
    public static void checkIfSupprime(List<Asset> listAsset, Map<Id, Asset> mapOldAsset){
        Map<String, String> mapAssetIdToSend = new Map<String, String>();
                     System.debug('$$$AP04_Equipement checkIfSupprime');
        for(Asset equip : listAsset){
            System.debug('###Audimetre__c' + equip.Audimetre__c);
            System.debug('$$$AP04_Equipement equip.Status : ' + equip.Status);
            System.debug('$$$AP04_Equipement mapOldAsset.get(equip.id).Status : ' + mapOldAsset.get(equip.id).Status);
            
            if(equip.Status != mapOldAsset.get(equip.id).Status && equip.Status == Label.Asset_Status_Supprime){
            System.debug('$$$AP04_Equipement mapOldAsset.get(equip.id).Status : ' + mapOldAsset.get(equip.id).Status);
                mapAssetIdToSend.put(equip.Audimetre__c, equip.Bande_Usine__c);
            }
        }
            System.debug('$$$AP04_Equipement mapAssetIdToSend : ' + mapAssetIdToSend);
        if(mapAssetIdToSend.size()>0){
            sendToOcom(mapAssetIdToSend); //to be modified accordingly
        }
    }
    
    @future (callout=true)
    public static void sendToOcom(Map<String, String> mapAssetIdToSend){
                     System.debug('$$$AP04_Equipement sendToOcom');
        //TS
        //modification Hatime AIT ISHAQ du 20/05/2022 : debut
        //meters?flow=sf-to-ocom&bu={}&meterIds=[]
        for(String meterId: mapAssetIdToSend.keySet()) {
            System.debug('###meterId: ' + meterId);
            String endpoint = 'callout:Mulesoft_experience_API/'+'api/'+ Label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+ label.Mulesoft_expAPI_meterPath + '?' 
                + 'flow=' + label.Mulesoft_flow_parameter_sf_to_OCOM + '&bu=' + mapAssetIdToSend.get(meterId) + '&' + label.Mulesoft_expAPI_metersIds+ meterId;
            //fin
            String method = 'DELETE';
            Http http = new Http();
            System.debug('$$$AP04_Equipement endpoint : ' + endpoint);
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