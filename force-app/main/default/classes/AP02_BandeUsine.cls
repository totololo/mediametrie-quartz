/*
* @author: Claire VEHRLE
* @date: 18/01/2023
* @ Description: Classe appelé par le lightning flow pour envoyer la bande usine et deprovisionner OCOM et retourne la response
* @TestClass: AP02_BandeUsine_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 
* */
public with sharing class AP02_BandeUsine {

    public static void deprovisionningBandeUsine (List<String> BUIdList){
        
        List<Asset> assetToUpdate = new List<Asset>();
        assetToUpdate = [SELECT Id, Status FROM Asset WHERE Bande_Usine__c IN :BUIdList];
        
        for (Asset eqt: assetToUpdate) {
            eqt.Status = Label.ASS_Statut_En_cours_de_supression_OCOM;
        }
        
        Update assetToUpdate;
        
        sendToOcom(BUIdList);
    }
    
    @future(callout=true)
    public static void sendToOcom(List<String> BUIdList){

        
        HTTPResponse resp;
        for(String buId: BUIdList) {
            System.debug('###buId: ' + buId);
            String endpoint = 'callout:Mulesoft_experience_API/'+'api/'+ Label.Mulesoft_Xapp_x_MM_Sync_Ocom+'/v1/'+ label.Mulesoft_expAPI_meterPath + '?' 
                + 'flow=' + label.Mulesoft_flow_parameter_sf_to_OCOM + '&idBU=' + buId;
            
            System.debug('###endpoint: ' + endpoint);
            String method = 'DELETE';
            Http http = new Http();
            
            HttpRequest req = new HttpRequest();
            req.setHeader('x-client-id', label.Mulesoft_expAPI_clientId);
            req.setHeader('x-client-secret', label.Mulesoft_expAPI_clientSecret);
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endpoint);
            req.setMethod(method);
            resp = http.send(req);
            System.debug(resp.getBody());
        }
        
        System.debug('$$$resp.getStatusCode(): ' + resp.getStatusCode());
        if(resp.getStatusCode() != 200 ){
            List<Bande_Usine__c> BUToUpdate = [SELECT id, Statut_de_l_import__c FROM BAnde_Usine__c WHERE Id IN :BUIdList];
            if(BUToUpdate[0].Statut_de_l_import__c != Label.BandeUsine_statut_Rejete){
                BUToUpdate[0].Statut_de_l_import__c = Label.BandeUsine_statut_Partiellement_Rejetee;
            }
            update BUToUpdate;
        }
        
        
    }
    
    public static void bandeUsineNonProvisionnee(List<Id> BUIdList) {
        List<Asset> assetToUpdate = new List<Asset>();
        assetToUpdate = [SELECT Id, Status FROM Asset WHERE Bande_Usine__c IN :BUIdList];
        
        for (Asset eqt: assetToUpdate) {
            eqt.Status = Label.ASS_Statut_Supprime;
        }
        
        Update assetToUpdate;
    }


    public static void bandeUsineProvisionning(List<Id> BUIdList) {
        List<Asset> assetToUpdate = new List<Asset>();
        assetToUpdate = [SELECT Id, Status FROM Asset WHERE Bande_Usine__c IN :BUIdList];
        
        for (Asset eqt: assetToUpdate) {
            eqt.Status = label.ASS_Statut_Valide;
        }
        
        Update assetToUpdate;
    }
}