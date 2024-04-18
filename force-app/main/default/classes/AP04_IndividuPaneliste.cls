/*
* @author: Claire VEHRLE
* @date: 22/03/2022
* @ Description 
* @TestClass: AP04_IndividuPaneliste_Test
* @Coverage: -- %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/ 
public class AP04_IndividuPaneliste {

    public static List<Individu_paneliste__c> empecherChuteCompositionFoyerMonopanel (List<Id> individuPanelisteIdChute) {
        
        List<Id> foyerIdList = new List<Id>();
        List<Account> foyerList = new List<Account>();
        Map<Individu_paneliste__c, Integer> monoOuMultipanelMap = new Map<Individu_paneliste__c, Integer>();
        List<Individu_Paneliste__c> individuPanelisteToCheckList = new List<Individu_Paneliste__c>();
        Id recordTypeIdFoyerPanelisteMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
                
        individuPanelisteToCheckList = [SELECT Id, Name, Composition_du_foyer__r.Contact_principal__c, Composition_du_foyer__r.AccountId, Foyer_paneliste__c
                                        FROM Individu_Paneliste__c WHERE Id IN :individuPanelisteIdChute];
        
        for (Individu_Paneliste__c indpan: individuPanelisteToCheckList) {
            if (indpan.Composition_du_foyer__r.Contact_principal__c) {
                foyerIdList.add(indpan.Composition_du_foyer__r.AccountId);
            }
        }
        foyerList = [SELECT Id, Name, 
                     (SELECT Id FROM Panelistes__r 
                      WHERE Statut_Foyer_paneliste__c != :Label.PAN_Statut_Panel_Chute_definitive 
                      AND Date_d_anonymisation__c = null 
                      AND RecordTypeId = :recordTypeIdFoyerPanelisteMediamatPame) 
                     FROM Account WHERE Id IN :foyerIdList];
        
        for (Account foyer: foyerList) {
            for (Foyer_Paneliste__c foyerPaneliste:foyer.Panelistes__r) {
                System.debug('$$$foyerPaneliste: ' + foyerPaneliste);
                for(Individu_paneliste__c indpan : individuPanelisteToCheckList) {
                    System.debug('$$$indpan: ' + indpan);
                    if(foyerPaneliste.Id == indpan.Foyer_paneliste__c) {
                        monoOuMultipanelMap.put(indpan, foyer.Panelistes__r.size());
                    }
                }
            }
        }
        
        List<Individu_Paneliste__c> individuPanelisteANePasChuter = new List<Individu_Paneliste__c>();
        for(Individu_Paneliste__c indPan:monoOuMultipanelMap.keySet()) {
            if(monoOuMultipanelMap.get(indPan) == 1) {
                indPan.Date_de_chute_de_l_individu__c = null;
                individuPanelisteANePasChuter.add(indPan);
            }
        }
        
        return individuPanelisteANePasChuter;
    }
}