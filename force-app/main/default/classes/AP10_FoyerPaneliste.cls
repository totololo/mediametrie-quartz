/*
* @author: Bastien Pinard
* @date: 
* @ Description 
* @TestClass: 
* @Coverage: 
* History
* Date of modification :
* <Date of modification>   <Author>    <Description of modification>
*/
public class AP10_FoyerPaneliste {
    public static void newIdIndividuPaneliste(List<Foyer_paneliste__c> ListUpdatedPaneliste){
        Set<Id> IdFoyerPan = new Set<Id>();
        List<Individu_Paneliste__c> IndiPanToUpdate = new List<Individu_Paneliste__c>();
        List<String> indPanSendToGoogle = new List<String>();
        
        Id recordTypeIdFoyerPanPaME =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        for(Foyer_paneliste__c foyerPan : ListUpdatedPaneliste){
            if(foyerPan.RecordTypeId == recordTypeIdFoyerPanPaME){
                IdFoyerPan.add(foyerPan.Id);
            }            
        }
        
        List<Individu_Paneliste__c> listIndPan = [
            SELECT Id, Foyer_paneliste__c, Foyer_paneliste__r.Identifiant_foyer_pame__c
            FROM Individu_Paneliste__c
            WHERE Foyer_paneliste__c 
            IN :IdFoyerPan 
            ORDER BY Foyer_paneliste__c, CreatedDate
        ];
        
        String prevFoyerPan = '';
                    Integer IndiPanCounter = 1;

        for(Individu_Paneliste__c i : listIndPan){
            String currentFoyerPan = i.Foyer_paneliste__c;
            system.debug('$$$AP10_FoyerPaneliste i : ' + i);

            if (currentFoyerPan != prevFoyerPan && prevFoyerPan != ''){
                IndiPanCounter = 1;
                i.ID_Google__c =   String.valueOf(i.Foyer_paneliste__r.Identifiant_foyer_pame__c)+10+IndiPanCounter;
                prevFoyerPan = i.Foyer_paneliste__c;
                IndiPanCounter = IndiPanCounter + 1;
            } else if (currentFoyerPan == prevFoyerPan){
                i.ID_Google__c = String.valueOf(i.Foyer_paneliste__r.Identifiant_foyer_pame__c)+10+IndiPanCounter;
                prevFoyerPan = i.Foyer_paneliste__c;
                IndiPanCounter = IndiPanCounter + 1;
            }
            
            if(prevFoyerPan == ''){
                i.ID_Google__c = String.valueOf(i.Foyer_paneliste__r.Identifiant_foyer_pame__c)+10+IndiPanCounter;
                prevFoyerPan = i.Foyer_paneliste__c;
                IndiPanCounter = IndiPanCounter + 1;
            }
            IndiPanToUpdate.add(i);
            indPanSendToGoogle.add(i.Id);
        }
        
        update IndiPanToUpdate;
        if(indPanSendToGoogle != null && indPanSendToGoogle.size() >0) {
            AP01_IndividuPaneliste.provisioningGoogleFlow(indPanSendToGoogle);
        }
        
    }
}