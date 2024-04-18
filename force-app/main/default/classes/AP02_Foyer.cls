/*
* @author: Khaled Hammoudeh
* @date: 22/01/2021
* @ Description: cette classe met à jour le foyer dans Si-Panel lorsqu'un foyer (unitaire) est mis à jour dans Salesforce
* @TestClass: AP02_Foyer_Test
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*  11.03.2021				  MZ		Modified getAccountFromSipanelFuture and getAccountFromSipanel to wait for the HTTP response
*										and return the error details to the flow
*  06.04.2022	Téoman Sertçelik		Modified ACC EXT ID to id salesforce passed to the mulesoft flow
* 20/05/2022	Ayoub GHAMMAZ			Modification du endpoint
*/

global class AP02_Foyer {
    /*
    * @author: Maribelle ZARAZIR
    * @ Description: Méthode qui vérifie toutes les conditions avant d'envoyer les contacts vers SI Panel (dans les 2 cas : création et mise à jour)
    */
    /*public static void checkSendAccountToSIPanel(List<Account> listNewAccounts, Map<Id,Account> mapOldAccounts) {
        Boolean isIntegration = UserInfo.getUserName() == Label.Mulesoft_integrationUser_username;
        Boolean isMessageErreurVide;
        
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Account.fieldSets.Champs_envoyes_vers_sipanel.getFields();
        
        List<String> listExtIdsUpdatedAccounts = new List<String>();
        
        system.debug('checking  if acc should be sent');
        
        if(!isIntegration && !system.isBatch()) { //Ne pas lancer l'appel vers SI Panel si l'Individu a été récupéré de SI Panel
            for(Account thisAccount : listNewAccounts) {
                //Verifications à faire quand un Individu est mis à jour
                isMessageErreurVide = (thisAccount.Message_en_cas_d_erreur__c == null) && (thisAccount.Appel_OK_KO__c == 'KO') 
                    && (thisAccount.Message_en_cas_d_erreur__c != mapOldAccounts.get(thisAccount.Id).Message_en_cas_d_erreur__c);
                
                for(Schema.FieldSetMember accountField : fields) {
                    //Vérifier si l'un des champs à envoyer vers SI Panel a été mis à jour
                    if(thisAccount.get(accountField.getFieldPath()) != mapOldAccounts.get(thisAccount.Id).get(accountField.getFieldPath())) {
                        listExtIdsUpdatedAccounts.add(thisAccount.Id);//modified Téoman 
                    }
                }
                if(isMessageErreurVide) {
                    listExtIdsUpdatedAccounts.add(thisAccount.Id);//modified Téoman 
                }
            }
            
            if(listExtIdsUpdatedAccounts.size() > 0) {
                system.debug('calling sendAccountToSiPanel');
                sendAccountToSiPanel(listExtIdsUpdatedAccounts);
            }
        }
    }*/
    
    @future (callout=true)
    public static void sendAccountToSiPanel(list<string> listAccountIds) {
        //List<Schema.FieldSetMember> fields = Schema.SObjectType.Account.fieldSets.Champs_envoyes_vers_sipanel.getFields();
        /* String baseEndpoint = 'callout:Mulesoft_experience_API/' + label.Mulesoft_expAPI_accountPath + '/' 
                        + label.Mulesoft_expAPI_postAccount + '/'; // + listAccountIds[0]; */

        string baseEndpoint = 'callout:Mulesoft_experience_API/' + label.Mulesoft_expAPI_houseHolds + '/' + listAccountIds[0]
        + '?' + 'flow=' +  label.Mulesoft_flow_parameter_sf_to_sip ;
        String method = 'PUT';
        Http http = new Http();
        String endpoint;
        
        List<Account> listAccountsToUpdate = [SELECT Id, ACC_ExtId_SIPanel__c
                                              FROM Account
                                              WHERE Id = :listAccountIds]; //modified Téoman 
        
        
        
        //Added by MZ for showing the errors on the record - 16/03/2021 - Start
        for(Account thisAccount : listAccountsToUpdate) {
           // endpoint = baseEndpoint + thisAccount.Id; //modified Téoman 
            HttpRequest req = creatHttpRequest(method, baseEndpoint);
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());
            
            thisAccount.Date_du_dernier_appel__c = System.now();
            
            if(res.getStatus() == 'OK') {
                //No errors returned from the system
                thisAccount.Appel_OK_KO__c = 'OK';
                thisAccount.Message_en_cas_d_erreur__c = '';
            } else {
                //Store the error return on the record
                system.debug('body >> ' + res.getBody());
                if(res.getBody() != null && res.getBody() != '') {
                    Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    Map<String, Object> mapError = (Map<String, Object>) mapResponse.get('error');
                    thisAccount.Appel_OK_KO__c = 'KO';
                    thisAccount.Message_en_cas_d_erreur__c = 'ERROR CODE : ' + res.getStatusCode();
                    thisAccount.Message_en_cas_d_erreur__c += '\nERROR REFERENCE : '
                        + (mapError.containsKey('errorReference')? (String) mapError.get('errorReference') : 'undefined');
                    thisAccount.Message_en_cas_d_erreur__c += '\nERROR DESCRIPTION : '
                        + (mapError.containsKey('errorDescription')? (String) mapError.get('errorDescription') : 'undefined');
                }
            }
        }
                
        try {
            update listAccountsToUpdate;
        } catch (Exception e) {
            System.debug('exception caught while updating the accounts : ' + e);
        }
        //Added by MZ - 16/03/2021 - End
    }
    
    @InvocableMethod
    public static List<CalloutResponse> getAccountFromSipanel(list<String> listAccountExternalIds) {
       
        string messageToDisplay = '';
        system.debug('$$$ KHA' + listAccountExternalIds);
        HTTPResponse resp = getAccountFromSipanelFuture(listAccountExternalIds);
        
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
        returnValue.responseErrorDescription = ( (resp.getStatus() != 'OK') && (mapError.containsKey('errorDescription')) ) ? (String) mapError.get('errorDescription') : 'undefined';
        system.debug(returnValue);
        listReturnValue.add(returnValue);
        
        return listReturnValue;    
    }
    
    //@future (callout=true)
    public static HTTPResponse getAccountFromSipanelFuture (list<String> listAccountExternalIds) {
        // modification AYoub GHMMAZ du 20/05/2022 : debut
        // /households/{gid}?flow=sipanel-to-sf
        string endpoint = 'callout:Mulesoft_experience_API/' +'api/'+Label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_houseHolds + '/' + listAccountExternalIds[0]
                        + '?' + 'flow=' +  label.Mulesoft_flow_parameter_sipanel_to_sf ;
        //fin
        
        //string endpoint = 'https://live-prep-pub-mulesoft.mediametrie.com/' + label.Mulesoft_expAPI_accountPath + '/' 
                       // + label.Mulesoft_expAPI_getAccount + '/' + listAccountExternalIds[0];
        string method = 'PUT';
        HttpRequest req = creatHttpRequest(method, endpoint);
        
        system.debug('$$$ KHA ' + endpoint);
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
        return res;
    }
    
    public static HttpRequest creatHttpRequest(string method, string endpoint) {
        HttpRequest reqToReturn = new HttpRequest();
        reqToReturn.setHeader('client_id', label.Mulesoft_expAPI_clientId);
        reqToReturn.setHeader('client_secret', label.Mulesoft_expAPI_clientSecret);
        reqToReturn.setEndpoint(endpoint);
        reqToReturn.setMethod(method);
        
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