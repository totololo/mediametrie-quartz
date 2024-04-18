/** 
* @author: Marleine Abi Khalil
* @date: 23/03/2022 
* @description: Appeler mulesoft API pour envoyer les individus panélistes d'un individu à la création de l'un de ses individus panélistes
* @Test: Class AP03_IndividuPaneliste_Test
* @Coverage : 96%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 04/04/2022                Téoman Sertçelik    Ajout de l'after insert  dans le cas ou le foyer est panélisete Mediamat et/ou PaME
* 21/04/2022                Téoman Sertçelik    Modification de l'endpoint + méthode future
* 20/05/2022				Ayoub GHAMMAZ		Modification du endpoint
*/

public class AP03_IndividuPaneliste {
    
    public static void indPanAEnvoyerAMulesoftInsert(List<Individu_Paneliste__c> listIndividuPaneliste){
        
        List<String> listIndividuPanIds = new List<String>();
        
        for(Individu_Paneliste__c indPan: listIndividuPaneliste) {
            listIndividuPanIds.add(indPan.Id);
        }
        
        if(listIndividuPanIds.size()>0 && !System.isBatch() && !System.isFuture()){
            envoyerAMulesoftInsert(listIndividuPanIds);
        }
    }
    
    public static void indPanAEnvoyerAMulesoftUpdate(List<Individu_Paneliste__c> listIndividuPaneliste, Map<Id,Individu_Paneliste__c> mapOldIndPan){
        
        Set<String> setExtIds = new Set<String>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Individu_Paneliste__c.fieldSets.Champs_envoyes_a_Mulesoft.getFields();
        List<Id> indPanId = new List<Id>();
        for(Individu_Paneliste__c indPan: listIndividuPaneliste) {
            indPanId.add(indPan.Id);
        }
        //Ajouter les champs de l'ensemble de champ
        List<Individu_Paneliste__c> listIndPan = [SELECT Id, Date_d_anonymisation__c, Composition_du_foyer__c, 	Date_d_entree_de_l_individu__c,
                                                  Date_de_chute_de_l_individu__c, Browser__c, TV__c, Routeur__c, Mobile__c, Lien_meter__c,
                                                  Signature_convention_individuelle_Meter__c, Type__c, Lettre__c, Date_du_dernier_appel__c,
                                                  Appel_OK_KO__c, Id_google__c
                                                  FROM Individu_Paneliste__c
                                                  WHERE Id in : indPanId];
        for(Individu_Paneliste__c indPan : listIndPan){
            for(Schema.FieldSetMember indPanField : fields) {
                //Vérifier si l'un des champs à envoyer à Mulesoft a été mis à jour
                System.debug('***indPan: ' + indPan);
                System.debug('***indPanField.getFieldPath(): ' + indPanField.getFieldPath());
                System.debug('***mapOldIndPan.get(indPan.Id).get(indPanField.getFieldPath()): ' + mapOldIndPan.get(indPan.Id).get(indPanField.getFieldPath()));
                if(indPan.get(indPanField.getFieldPath()) != mapOldIndPan.get(indPan.Id).get(indPanField.getFieldPath()) && indPan.Date_d_anonymisation__c ==null) {
                    System.debug('***indPanField: ' + indPan.get(indPanField.getFieldPath()));
                    setExtIds.add(indPan.Id); // to be modified accordingly
                }
            }
        }
        System.debug('***setExtIds: '  + setExtIds);
        if(setExtIds.size() > 0 && setExtIds!= null){
            	envoyerAMulesoftUpdate(setExtIds);

        }
    }
    
    //Téoman : modification endpoint + query
    @future (callout=true)
    public static void envoyerAMulesoftInsert(List<String> listIndividuIds){
        
        List<Individu_paneliste__c> listIndividuToUpdate = [SELECT Id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c,
                                                            Composition_du_foyer__c
                                                            FROM Individu_Paneliste__c
                                                            WHERE Id in : listIndividuIds];
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        for(Individu_paneliste__c ind : listIndividuToUpdate) {
            //modification AYoub GHMMAZ du 20/05/2022 : debut
            ///members/{uuid}?flow=sf-to-sipanel
            endpoint =  'callout:Mulesoft_experience_API/' +'api/'+ Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + ind.Composition_du_foyer__c
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel 
                + '&uid=' + ind.Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
            //fin
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
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
    
    @future (callout=true)
    public static void envoyerAMulesoftUpdate(Set<String> listIndividuIds){
        
        List<Individu_paneliste__c> listIndividuToUpdate = [SELECT Id, Composition_du_foyer__c
                                                            FROM Individu_Paneliste__c
                                                            WHERE Id in : listIndividuIds];
        String method = 'PUT';
        String endpoint;
        Http http = new Http();
        
        for(Individu_paneliste__c ind : listIndividuToUpdate) {
            endpoint =  'callout:Mulesoft_experience_API/' +'api/'+Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + ind.Composition_du_foyer__c
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel;
            //fin
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
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
    
        public static void envoyerAMulesoftUpdateBatch(Set<String> listIndividuIds){
        
        List<Individu_paneliste__c> listIndividuToUpdate = [SELECT Id, Composition_du_foyer__c
                                                            FROM Individu_Paneliste__c
                                                            WHERE Id in : listIndividuIds];
        
        
        for(Individu_paneliste__c ind : listIndividuToUpdate) {
            String endpoint =  'callout:Mulesoft_experience_API/' +'api/'+Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + ind.Composition_du_foyer__c
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel;
            //fin
            String method = 'PUT';
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
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
}