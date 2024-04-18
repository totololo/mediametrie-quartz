/*
* @date: 09/08/2023
* @ Description : Appel flux mulesoft. Création/Modification Statut Device 
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP01_Statut_Device_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP01_Statut_Device {
    
    public static void creationStatutDeviceNielsen(Set<Id> eqtFoyerIdList) {
        List<String> foyerPanelisteIdToSend = new List<String>();
        List<foyer_paneliste__c> foyerPanList = new List<Foyer_Paneliste__c>();
        List<Equipements_du_foyer__c> foyerList = new List<Equipements_du_foyer__c>();
        Set<Id> foyerIdSet = new Set<Id>();
        

        foyerList= [SELECT Id, foyer__c FROM Equipements_du_foyer__c WHERE id IN :eqtFoyerIdList];
        for(Equipements_du_foyer__c eqtFoyer:foyerList) {
            foyerIdSet.add(eqtFoyer.foyer__c);
        }
        
        foyerPanList= [SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c FROM Foyer_Paneliste__c WHERE referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_Mesure_Plateforme AND foyer__c IN :foyerIdSet];
        for(Foyer_Paneliste__c foyerPan:foyerPanList) {
            foyerPanelisteIdToSend.add(foyerPan.Foyer_Paneliste_ExtId_SIPanel__c);
        }
        callMulesoft(foyerPanelisteIdToSend);
    }
    
    public static void updateStatutDeviceNielsen(List<Statut_Device_Equipement_Mesure__c> StatutDeviceList, Map<Id,Statut_Device_Equipement_Mesure__c> mapOldStatutDeviceList) {
        Set<Id> eqtFoyerId = new Set<Id>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Statut_Device_Equipement_Mesure__c.fieldSets.Champ_envoyes_Nielsen.getFields();
        
        for(Statut_Device_Equipement_Mesure__c statutDevice : StatutDeviceList){
            for(Schema.FieldSetMember statutDeviceField : fields) {
                //Vérifier si l'un des champs à envoyer à Mulesoft a été mis à jour
                if(statutDevice.get(statutDeviceField.getFieldPath()) != mapOldStatutDeviceList.get(statutDevice.Id).get(statutDeviceField.getFieldPath())) {
                    eqtFoyerId.add(statutDevice.Equipement_du_foyer__c); // to be modified accordingly
                }
            }
        }
        
        if(eqtFoyerId.size() > 0 && eqtFoyerId!= null){
            creationStatutDeviceNielsen(eqtFoyerId);
        }
           
    }
    
    @future(callout=true)
    public static void callMulesoft(List<String> foyerPanelisteIdToSend) {
        
        
        for(String idValue :foyerPanelisteIdToSend){
            String endpoint = 'callout:Mulesoft_experience_API/' +'api/'+label.Mulesoft_Xapp_MM_Sync_Nielsen+'/v1/'+label.Mulesoft_expAPI_houseHolds + '/' + idValue; 
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
        }
    }

}