/*
* @date: 10/08/2021
* @ Description : Appeler mulesoft API pour envoyer les foyers panélistes d'un compte à la modification de l'un de ses foyers panélistes
* @version 1.00   
* @Auteur Claire VEHRLE EIT
* @TestClass: AP05_Foyer_Test
* @Coverage: --%
 History
* <Date of modification>   	     <Author>    		  <Description of modification>
*/
public class AP05_Foyer {

        public static void envoyerFoyerMulesoft(List<Account> listFoyer, Map<Id,Account> mapOldFoyer) {
        Set<String> setExtIds = new Set<String>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Account.fieldSets.Champs_envoyes_vers_sipanel.getFields();
        List<Id> foyerId = new List<Id>();
        for(Account foyer: listFoyer) {
            foyerId.add(foyer.Id);
        }
            //Ajouter les champs de l'ensemble de champ
        List<Account> ListIndPan = [SELECT Id, ACC_ExtId_SIPanel__c, TECH_CongePrincipal__c, Name, Complement_d_adresse__c, ShippingCity, 
                                    ShippingCountry, ShippingPostalCode, ShippingStreet, ShippingState, Date_d_anonymisation__c,
                                    Adresse_e_mail_principale__c, Personne_de_reference__c, Type_d_habitation__c, Jardin__c, Statut_d_occupation__c,
                                    Abonnement_canal_motive_par_le_cinema__c, Abonnement_canal_motive_par_le_sport__c, Numero_de_telephone_fixe__c,
                                    Abonnement_canal_motive_par_les_series__c, TECHi_is_WorkOrder_Changed__c,Date_de_visite_de_courtoisie__c,
                                    Nombre_TV__c, Nombre_tv_total__c, Nombre_pc__c, Nombre_smartphone__c, Nombre_tablette__c, Numero_de_portable__c,
                                    Fournisseur_acces_internet__c, Type_acces_internet__c, Equipe_barre_de_son__c, Equipe_enceintes_TV__c, 
                                    Equipe_home_cinema__c, Equipe_internet__c, Equipe_ordinateur__c, Equipe_tablette__c, Equipe_smartphone__c, Equipe_filaire__c
                                    FROM Account
                                    WHERE Id in : foyerId];
        for(Account foyer : ListIndPan){
            for(Schema.FieldSetMember foyerField : fields) {
                //Vérifier si l'un des champs à envoyer à Mulesoft a été mis à jour
                if(foyer.get(foyerField.getFieldPath()) != mapOldFoyer.get(foyer.Id).get(foyerField.getFieldPath()) && foyer.Date_d_anonymisation__c ==null) {
                    setExtIds.add(foyer.Id); // to be modified accordingly
                }
            }
        }
        System.debug('***setExtIds: '  + setExtIds);
        if(setExtIds.size() > 0 && setExtIds!= null){
            envoyerAMulesoft(setExtIds);
        }
    }
    
        @future (callout=true)
    public static void envoyerAMulesoft(Set<String> setExtIds){
        
        List<Account> ListIndPan = [SELECT Id, (SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c FROM Panelistes__r)
                                               FROM Account
                                               WHERE Id in : setExtIds];
        for(Account foyer :ListIndPan ){
            for(Foyer_Paneliste__c foyerPan:foyer.Panelistes__r) {
                String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_houseHolds + '/'+ foyer.Id
                    + '?flow='+label.Mulesoft_flow_parameter_sf_to_sipanel+'&uid='+foyerPan.Foyer_Paneliste_ExtId_SIPanel__c;
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
                
                req.setEndpoint(endpoint);
                req.setMethod(method);
                
                HTTPResponse res = http.send(req);
                System.debug('***Http response: ' + res.getBody());
            }
            
        }
    }
    
        /*public static void envoyerAMulesoftBatch(Set<String> setExtIds){
        
        List<Account> ListIndPan = [SELECT Id, (SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c FROM Panelistes__r)
                                               FROM Account
                                               WHERE Id in : setExtIds];
        for(Account foyer :ListIndPan ){
            for(Foyer_Paneliste__c foyerPan:foyer.Panelistes__r) {
                String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Sipanel+'/v1/'+ label.Mulesoft_expAPI_houseHolds + '/'+ foyer.Id
                    + '?flow='+label.Mulesoft_flow_parameter_sf_to_sipanel+'&uid='+foyerPan.Foyer_Paneliste_ExtId_SIPanel__c;
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
                
                req.setEndpoint(endpoint);
                req.setMethod(method);
                
                HTTPResponse res = http.send(req);
                System.debug('***Http response: ' + res.getBody());
            }
            
        }
    }*/
}