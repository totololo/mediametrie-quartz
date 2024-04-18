/*
* @date: 24/03/2022
* @ Description : appeler API mulesoft pour envoi de la convention à l'insert et l'update 
* @ Condition : - individu fait partie de la compo foyer où il est membre
*               - le foyer panéliste auquel l'individu appartient et le référentiel panel du foyer pan est de type pame
*               - que la (dernière) convention est rattachée à la dernière version de référentiel convention 
                  et que celle ci est signé et actif
* @Auteur : Téoman Sertçelik
* @TestClass: AP01_Convention_Test
* @Coverage: 98 %
History
* <Date of modification> 		<Author> 			<Description of modification>
20/04/2022                      Téoman Sertçelik    Modified endpoint +
* 25/05/2022					Ayoub GHAMMAZ	Modification du endpoint
*/

public class AP01_Convention  {
   
    public static void sendConvention(List<Convention__c> listConvention , Map<Id,Convention__c> mapOldConvention){
    
        Set<String> setCnvIds = new Set<String>();
        Boolean isInsert = mapOldConvention == null;
        //List<String> listExtIdsUpdatedConventions = new List<String>();
        List<String> listIdsCreatedConventions = new List<String>();
        Convention__c newConv;
        //Convention__c oldConv;
        

        for(Convention__c cnv : listConvention) {
            setCnvIds.add(cnv.Id);
        }

        Map<Id, Convention__c> mapNewConvention = new Map<Id, Convention__c> 
        ([SELECT Id, CON_ExtId_Google__c, Individu_Paneliste__c, Individu_Paneliste__r.Composition_du_foyer__c, Individu_Paneliste__r.Composition_du_foyer__r.Type__c,
                 Foyer_paneliste__c, Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c,
                 Referentiel_convention__c, Referentiel_convention__r.Version__c, Referentiel_convention__r.Statut__c, Referentiel_convention__r.CreatedDate, Referentiel_convention__r.Name,
                 Composition_du_foyer__r.Type__c, Composition_du_foyer__c,
                 Date_de_signature_de_la_convention__c
          FROM Convention__c
          WHERE Id IN : setCnvIds]
        );

        Map<String, List<Referentiel_convention__c>> mapRefPanelIdToRefConvention = new Map<String, List<Referentiel_convention__c>>();

        List<Referentiel_convention__c> listReferentielConv = [SELECT Id, Statut__c, Version__c, Referentiel_Panel__c, CreatedDate,
                                                                    (SELECT Id, Date_de_signature_de_la_convention__c, Referentiel_convention__c
                                                                     FROM Conventions__r
                                                                     WHERE Id IN : mapNewConvention.keyset() )
                                                               FROM Referentiel_convention__c
                                                               WHERE Version__c != null 
                                                               AND Statut__c = 'Actif'
                                                               ORDER BY CreatedDate DESC
                                                               LIMIT 1];

        Set<String> setRefConvIds = new Set<String>();
        for(Referentiel_convention__c refCnv : listReferentielConv) {
            setRefConvIds.add(refCnv.Id);
            if(!mapRefPanelIdToRefConvention.containsKey(refCnv.Referentiel_Panel__c)) {
                mapRefPanelIdToRefConvention.put(refCnv.Referentiel_Panel__c, new List<Referentiel_convention__c>());

            }
            mapRefPanelIdToRefConvention.get(refCnv.Referentiel_Panel__c).add(refCnv);
        }
        
        for(Convention__c cnv : mapNewConvention.values()) {  
            if(isInsert) {
                newConv = mapNewConvention.get(cnv.Id);
                if(setRefConvIds.contains(newConv.Referentiel_convention__c)) {
                    if(newConv.Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c == Label.REF_PANEL_TypePan_PAME	&& newConv.Individu_Paneliste__r.Composition_du_foyer__r.Type__c == Label.CON_Type_MEMBRE &&  newConv.Date_de_signature_de_la_convention__c != null ){
                        listIdsCreatedConventions.add(cnv.Id);
                    } 
                }
                
            }
        }
        System.debug('***listIdsCreatedConventions: ' + listIdsCreatedConventions);
        if(listIdsCreatedConventions.size()>0  && listIdsCreatedConventions !=  null) {
            System.debug('***Envoi convention: ');
            sendConventionToGoogle(listIdsCreatedConventions);
            }   
    }

    @future(callout=true)
    public static void sendConventionToGoogle(List<String> listConventionToUpdate) {
        System.debug('$$$ AP01_Convention.sendConventionToGoogle ');
        String method = 'POST';
        String endpoint;
        Http http = new Http();

        List<Convention__c> listConventionToUpdateOrCreate = [SELECT Id, 
                                                                        Composition_du_foyer__c,
                                                                        Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c
                                                                 FROM Convention__c
                                                                 WHERE Id =: listConventionToUpdate ];
        
        for(Convention__c conv : listConventionToUpdateOrCreate) {      
            //modification AYoub GHMMAZ du 25/05/2022 : debut
            //modification EGZARA du 01/12/2022 
            //x-mm-sync-google-pfi/v1/agreements?flow=sf-to-google&agreementId
            endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Google+'/v1/'+ label.Mulesoft_expAPI_agreementsPath  
                        + '?flow=' + label.Mulesoft_flow_parameter_sf_to_google+'&uid='+conv.Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c + '&uuid=' + conv.Composition_du_foyer__c;
            // old   + '?flow=' + label.Mulesoft_flow_parameter_sf_to_google+'&'+conv.Id;
            HttpRequest req = createHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug('$$$ AP01_Convention.sendConventionToGoogle: endpoint:'+endpoint);
            System.debug('$$$ AP01_Convention.sendConventionToGoogle: response:'+res.getBody());
        }
       /*  try {
            update listConventionToUpdateOrCreate;
        } catch (Exception e) {
            System.debug('exception caught while updating the conventions : ' + e);
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