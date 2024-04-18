/*
* @author: Khaled Hammoudeh
* @date: 22/01/2021
* @ Description: cette classe met à jour le membre du foyer dans Si-Panel lorsque ce membre du foyer (unitaire) est mis à jour dans Salesforce
* @TestClass: AP01_MembreDuFoyer_Test
* @Coverage: 100%
* History
* <Date of modification>   <Author>    <Description of modification>
*  11.03.2021				  MZ		Modified getContactFromSipanelFuture and getContactFromSipanel to wait for the HTTP response
*										and return the error details to the flow
* Jerome HE 27/04/22 Envoi des individus vers SiPanel + envoie du contact et des individus panéliste si les foyer pan du contact sont AIP
* 20/05/2022			Ayoub GHAMMAZ	Modification du endpoint
* 15/12/2022			Marliatou DIALLO  Envoi des contacts pour MAJ des statuts dans SIPanel après chute 
*/
public class AP01_MembreDuFoyer {
    /*
* @author: Maribelle ZARAZIR
* @ Description: Méthode qui vérifie toutes les conditions avant d'envoyer les contacts vers SI Panel (dans les 2 cas : création et mise à jour)
*/
    // A décommenter lorsque la liason avec SIPanel sera ok
    public static void checkSendContactToSIPanel(List<Contact> listContact, Map<Id,Contact> mapOldContacts) {
        Set<String> setExtIds = new Set<String>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Contact.fieldSets.Champs_envoyes_vers_SIPanel.getFields();
        List<Id> compoFoyerId = new List<Id>();
        for(Contact compoFoyer: listContact) {
            compoFoyerId.add(compoFoyer.Id);
        }
            //Ajouter les champs de l'ensemble de champ
        List<Contact> listCompoFoyer = [SELECT Id, Name, LastName, FirstName, Lien_de_parente_stat__c, Lien_parente__c, Birthdate, Sexe__c, Email, MobilePhone, 
                                        Presence_permanente__c, Nombre_de_jour_de_presence_par_mois__c, Frequence_de_connexion_mobile__c, Date_de_suppression__c,
                                        Frequence_de_connexion_ordinateur__c, Frequence_de_connexion_tablette__c, Type__c, Activite_actuelle__c,
                                        Profession__c, Type_d_emploi__c, Classification__c, Autre_activite__c, Secteur_d_activite__c, Temps_plein__c,
                                        Nombre_d_heures_travaillees__c,CSP42__c,CSP4__c	, Nombre_de_salaries__c, Domaine_d_activite__c, Code_profession__c, Date_d_anonymisation__c,
                                        Age_de_fin_d_etude__c, Niveau_d_etude_en_cours__c, Dernier_diplome_obtenu__c, AccountId, A_anonymiser__c, RecordTypeId
                                        FROM Contact
                                        WHERE Id in : compoFoyerId];
        for(Contact compoFoyer : listCompoFoyer){
            for(Schema.FieldSetMember compoFoyerField : fields) {
                //Vérifier si l'un des champs à envoyer à Mulesoft a été mis à jour
                if(compoFoyer.get(compoFoyerField.getFieldPath()) != mapOldContacts.get(compoFoyer.Id).get(compoFoyerField.getFieldPath())) {
                    setExtIds.add(compoFoyer.Id); // to be modified accordingly
                }
            }
        }
        System.debug('***setExtIds: '  + setExtIds);
        if(setExtIds.size() > 0 && setExtIds!= null){
            sendUpdatedContactToSiPanel(setExtIds);
        }
    }
    
    public static void contactAIPToInsert(List<Contact> compoFoyerPanelAIPList) {
        List<String> foyerPanelisteUId = new List<String>();
        List<String> compoFoyerId = new List<String>();
        List<String> compoFoyerAccountId = new List<String>();
        List<Foyer_paneliste__c> foyerPanelisteAIP = new List<Foyer_paneliste__c>();
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        for(Contact compoFoyer: compoFoyerPanelAIPList) {
            compoFoyerAccountId.add(compoFoyer.AccountId);
        }
        
        foyerPanelisteAIP = [SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c, Foyer__c FROM Foyer_paneliste__c 
                             WHERE Foyer__c IN :compoFoyerAccountId
                             AND recordTypeId  = :recordTypeIdFoyerPanelisteAIP];
        for(Foyer_Paneliste__c foyerPan: foyerPanelisteAIP) {
            for (Contact compoFoyer:compoFoyerPanelAIPList) {
                if(foyerPan.Foyer__c == compoFoyer.AccountId) {
                    foyerPanelisteUId.add(foyerPan.Foyer_Paneliste_ExtId_SIPanel__c);
                    compoFoyerId.add(compoFoyer.Id);
                }
            }
        }
        
        sendContactAIPToInsertToSiPanel(foyerPanelisteUId, compoFoyerId);
    }
    
    //Method used to send contact information to SIPanel when a contact is updated
    @future (callout=true)
    public static void sendUpdatedContactToSiPanel(Set<string> listContactIds) {
        //String baseEndpoint = 'callout:Mulesoft_experience_API/' + label.Mulesoft_expAPI_contactPath + '/' 
        //   + label.Mulesoft_expAPI_putContact + '/';
        String method = 'PUT';
        String endpoint;
        Http http = new Http();
        
        List<Contact> listContactsToUpdate = [SELECT Id
                                              FROM Contact
                                              WHERE Id IN :listContactIds];
        
        for(Contact thisContact : listContactsToUpdate) {
            endpoint =  'callout:Mulesoft_experience_API/' +'api/'+ Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + thisContact.Id
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel;
            
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            
            //Added by MZ for showing the errors on the record - 16/03/2021 - Start
            /*thisContact.Date_du_dernier_appel__c = System.now();
            
            if(res.getStatus() == 'OK') {
                //No errors returned from the system
                thisContact.Appel_OK_KO__c = 'OK';
                thisContact.Message_en_cas_d_erreur__c = '';
                //if date de chute is no longer empty >> continue with the needed flows
                if(thisContact.Date_de_chute_individu__c != null && !thisContact.TECH_IndividuChute__c) {
                    thisContact.TECH_IndividuChute__c = True; //check this field in order to launch the flows related to "Chute d'un individu"
                    
                    system.debug('MZ :: Debug in MBF ap01');
                    system.debug('MZ :: Debug >> thisContact.TECH_IndividuChute__c ' + thisContact.TECH_IndividuChute__c);
                }
            } else {
                //Store the error returned on the record
                if(res.getBody() != null && res.getBody() != '') {
                    Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Map<String, Object> mapError = (Map<String, Object>) mapResponse.get('error');
                    thisContact.Appel_OK_KO__c = 'KO';
                    thisContact.Message_en_cas_d_erreur__c = 'ERROR CODE : ' + res.getStatusCode();
                    thisContact.Message_en_cas_d_erreur__c += '\nERROR REFERENCE : '
                        + (mapError.containsKey('errorReference')? (String) mapError.get('errorReference') : 'undefined');
                    thisContact.Message_en_cas_d_erreur__c += '\nERROR DESCRIPTION : '
                        + (mapError.containsKey('errorDescription')? (String) mapError.get('errorDescription') : 'undefined');
                }
                
                //if date de chute is no not empty and the tech field is not checked => there was an error synchronizing the change with SI Panel
                //and date de chute should be emptied
                if(thisContact.Date_de_chute_individu__c != null && !thisContact.TECH_IndividuChute__c) {
                    thisContact.Date_de_chute_individu__c = null;
                }
            }*/
        }
        
        /*try {
            update listContactsToUpdate;
        } catch (Exception e) {
            System.debug('exception caught while updating the contacts : ' + e);
        }*/
        //Added by MZ - 16/03/2021 - End
    }
    
    //Method used to send contact information to SIPanel when a contact AIP is insert
    @future (callout=true)
    public static void sendContactAIPToInsertToSiPanel(List<String> foyerPanelisteUId, List<String> compoFoyerId) {
        String method = 'POST';
        String endpoint;
        Http http = new Http();
        
        for(Integer i = 0; i < compoFoyerId.size(); i++) {
            endpoint =  'callout:Mulesoft_experience_API/' +'api/'+ Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
                + compoFoyerId[i]
                + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel 
                + '&uid=' + foyerPanelisteUId[i];
            
            HttpRequest req = creatHttpRequest(method, endpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
        }
    }
    
       
    /*@InvocableMethod
    public static List<CalloutResponse> getContactFromSipanel(list<String> listContactExternalIds) {
        
        HTTPResponse resp = getContactFromSipanelFuture(listContactExternalIds);
        
        //If the response contains an error, cast it into a map
        Map<String, Object> mapResponse = new Map<String, Object>();
        Map<String, Object> mapError = new Map<String, Object>();
        if(resp.getStatus() != 'OK') {
            mapResponse = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            mapError = (Map<String, Object>) mapResponse.get('error');
        }
        
        //Build the response that will be sent back to the flow
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        returnValue.responseStatusCode = resp.getStatusCode();
        returnValue.responseErrorReference = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorReference')) ) ? (String) mapError.get('errorReference') : 'undefined';
        //returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorDescription')) ) ? (String) mapError.get('errorDescription') : 'undefined';
        //system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;
    }*/
    
    /*public static HTTPResponse getContactFromSipanelFuture(list<String> listContactExternalIds)
    {
        string endpoint = 'callout:Mulesoft_experience_API/' + label.Mulesoft_expAPI_contactPath + '/' 
            + label.Mulesoft_expAPI_getContact + '/' + listContactExternalIds[0];
        string method = 'GET';
        HttpRequest req = creatHttpRequest(method, endpoint);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }*/
    

    // Added by Marliatou DIALLO - 15/12/2022
    // Start
    @InvocableMethod
    public static List<CalloutResponse> updateContactToSipanel(list<String> listContactIds) {
        String method;
        HTTPResponse resp = sendContactToSipanel(listContactIds);
        
        List<CalloutResponse> listReturnValue = new List<CalloutResponse>();
        CalloutResponse returnValue = new CalloutResponse();
        returnValue.responseStatus = resp.getStatus();
        returnValue.responseStatusCode = resp.getStatusCode();
        system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;
    }  
    
    
    public static HTTPResponse sendContactToSipanel(list<String> listContactIdsToSIP) {
        String method;
        String endpoint;
        List<Contact> listContactsToUpdate = new List<Contact>();
        List<Individu_Paneliste__c> listIndPan = new List<Individu_Paneliste__c>();
        List<Foyer_paneliste__c> listfoyerPaneliste = new List <Foyer_paneliste__c>();
        
       
        listContactsToUpdate = [SELECT Id, Name, AccountId, RecordTypeId
                                              FROM Contact
                                              WHERE Id IN :listContactIdsToSIP]; 
              
       listIndPan = [SELECT Id, Name, Foyer_Paneliste__c 
                         					    FROM Individu_Paneliste__c 
                                                WHERE Composition_du_foyer__c =:listContactsToUpdate[0].Id];
       
      
      if(!listIndPan.isEmpty())
        {
  	  		listfoyerPaneliste = [SELECT Id, Name, Foyer_Paneliste_ExtId_SIPanel__c, Foyer__c 
                           FROM Foyer_paneliste__c 
                           WHERE Id =: ListIndPan[0].Foyer_Paneliste__c  
                           AND Foyer__c =: listContactsToUpdate[0].AccountId LIMIT 1];
        }
        else{
            listfoyerPaneliste = [SELECT Id, Name, Foyer_Paneliste_ExtId_SIPanel__c, Foyer__c 
                                    FROM Foyer_paneliste__c 
                                    WHERE Foyer__c =: listContactsToUpdate[0].AccountId LIMIT 1];

        }
             
        If(listfoyerPaneliste.size() > 0){
                     method ='PUT';
                	 endpoint =  'callout:Mulesoft_experience_API/' +'api/'+ Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_indivduPanPath + '/' 
               		 +  listContactsToUpdate[0].Id
               		 + '?flow=' + label.Mulesoft_flow_parameter_sf_to_sipanel 
                	 + '&uid=' + listfoyerPaneliste[0].Foyer_Paneliste_ExtId_SIPanel__c;                                     
        }
        
        Http http = new Http();
        HttpRequest req = creatHttpRequest(method, endpoint);
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());   
                        
        return res;    
      
    }
  // End  
 
    
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