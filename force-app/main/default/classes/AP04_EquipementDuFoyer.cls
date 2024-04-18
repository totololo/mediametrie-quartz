/*
* @date: 10/08/2023
* @ Description : Appel flux mulesoft. Modification/Suppression Equipement du foyer
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP04_EquipementDuFoyer_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP04_EquipementDuFoyer {
    
    public static void updateEquipementFoyer(List<Equipements_du_foyer__c> eqtFoyerList, Map<Id,Equipements_du_foyer__c> mapOldeqtFoyerList) {
        Set<Id> foyerIdList = new Set<Id>();
        List<String> foyerPanelisteIdToSend = new List<String>();
        List<foyer_paneliste__c> foyerPanList = new List<Foyer_Paneliste__c>();
        List<Schema.FieldSetMember> fields = Schema.SObjectType.Equipements_du_foyer__c.fieldSets.Champs_envoyes_Nielsen.getFields();
        
        for(Equipements_du_foyer__c eqtFoyer : eqtFoyerList){
            for(Schema.FieldSetMember eqtFoyerField : fields) {
                //Vérifier si l'un des champs à envoyer à Mulesoft a été mis à jour
                if(eqtFoyer.get(eqtFoyerField.getFieldPath()) != mapOldeqtFoyerList.get(eqtFoyer.Id).get(eqtFoyerField.getFieldPath())) {
                    foyerIdList.add(eqtFoyer.Id); // to be modified accordingly
                }
            }
        }
        
        foyerPanList= [SELECT Id, Foyer_Paneliste_ExtId_SIPanel__c FROM Foyer_Paneliste__c WHERE referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_Mesure_Plateforme AND foyer__c IN :foyerIdList];
        for(Foyer_Paneliste__c foyerPan:foyerPanList) {
            foyerPanelisteIdToSend.add(foyerPan.Foyer_Paneliste_ExtId_SIPanel__c);
        }
        
        if(foyerIdList.size() > 0 && foyerIdList!= null){
            callMulesoft(foyerPanelisteIdToSend);
        }
           
    }
    
    public static void suppressionEqtFoyer(Set<Id> foyerIdList) {
        List<foyer_paneliste__c> foyerPanList = new List<Foyer_Paneliste__c>();
        List<String> foyerPanelisteIdToSend = new List<String>();
        
        foyerPanList= [SELECT Id FROM Foyer_Paneliste__c WHERE referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_Mesure_Plateforme AND foyer__c IN :foyerIdList];
        for(Foyer_Paneliste__c foyerPan:foyerPanList) {
            foyerPanelisteIdToSend.add(foyerPan.Id);
        }
        
        if(foyerIdList.size() > 0 && foyerIdList!= null){
            callMulesoft(foyerPanelisteIdToSend);
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