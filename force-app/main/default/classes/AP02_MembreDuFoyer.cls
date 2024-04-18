/*
* @date: 01/04/2022
* @ Description : appeler API mulesoft Google pour envoi du contact à l'update 
* @ Condition : - suite changement du nom prénom
*               - suite changement de l'adresse mail
*               - suite changement de la date de naissance
*               - lorsque le champ Lettre__c de l'un des individu panéliste 
appartenant à la composition du foyer (contact) mis à jour est mis à jour

* @Auteur : Téoman Sertçelik
* @TestClass: AP02_MembreDuFoyer_Test
* @Coverage: 96 %
History
* <Date of modification> 		<Author> 	<Description of modification>
* 06/04/22                  Jerome HE        add sendContactToOCOM createIndPan  @Coverage : 81 %
* 21/04/2022                Téoman Sertçelik   modified endpoint in sendContactToUpdate
* 20/05/2022			Ayoub GHAMMAZ	Modification du endpoint
*/

public with sharing class AP02_MembreDuFoyer {
    
    //Teo
    public static void checkContact(List<Contact> listContact, Map<Id,Contact> mapOldContact) {
        
        List<String> listContIdsToBeUpdated = new List<String>();
        for(Contact ct : listContact) {
            //Téoman : réfléchir si nécessaire de vérifier que le contact à des child foyer panélistes 
            //pour appel endpoint
            if(ct.FirstName != mapOldContact.get(ct.Id).FirstName || ct.Email != mapOldContact.get(ct.Id).Email ){
                listContIdsToBeUpdated.add(ct.Id);
            }
        }
        if(listContIdsToBeUpdated.size()>0 && !System.isBatch() && !System.isFuture()) {
            sendContactToGoogle(listContIdsToBeUpdated);
        }
    }
    
    //JH
    @future(callout=true)
    public static void sendContactToGoogle (List<String> listContactToSend) {
        
        List<Individu_Paneliste__c> listIndPanToUpdate = [SELECT Id, composition_du_foyer__c, foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                           FROM Individu_Paneliste__c   
                                                           WHERE composition_du_foyer__c IN : listContactToSend 
                                                          AND foyer_paneliste__r.Referentiel_Panel__r.type_de_panel__c = :Label.RFP_TypePanel_PaME]; 
        
       
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        for(Individu_Paneliste__c indPan : listIndPanToUpdate) {
            endpoint = 'callout:Mulesoft_experience_API/'+'api/'+label.Mulesoft_Xapp_MM_Sync_Google+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + indPan.composition_du_foyer__c + '?flow='
                + label.Mulesoft_flow_parameter_sf_to_google + '&uid=' + indPan.Foyer_Paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            
            HttpRequest req = createHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
        }
    }
    
    //TEO 
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
    
    /************ */

    
    @InvocableMethod
    public static List<Individu_paneliste__c> createIndPan(List<Individu_paneliste__c> indPanList ){
        
        List<Individu_paneliste__c> existingIndPan = [Select id,Name,lettre__c 
                                                      from Individu_paneliste__c 
                                                      where Foyer_paneliste__c =: indPanList[0].Foyer_paneliste__c];
        system.debug('existingIndPan >>>' + existingIndPan);
        List<String> lettreList = new List<String>{'A','B','C','D','E','F','G','H'};
            
            for(Integer i = 0; i < existingIndPan.size(); i++){
                if(lettreList.contains(existingIndPan[i].Lettre__c)){
                    system.debug('existingIndPan element >>>' + existingIndPan[i]);
                    Integer index = lettreList.indexOf(existingIndPan[i].Lettre__c);
                    lettreList.remove(index);
                }
            }
        system.debug('lettre list >>>' + lettreList);
        
        indPanList[0].Lettre__c = lettreList[0];
        system.debug('indPanList[0] >>>' + indPanList[0]);
        
        system.debug('indPanList to return >>>' + indPanList);
        return indPanList;
    }
}