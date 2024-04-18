/*
* @date: 10/08/2023
* @ Description : Appel flux mulesoft. Modification/Suppression Equipement du foyer
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP05_EquipementDuFoyer_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP05_EquipementDuFoyer {

    public static void creationEqtFoyerSuFoyerPanMesurePlateForme(Map<Id, List<Equipements_du_foyer__c>> foyerEqtFoyerMap) {
        List<foyer_paneliste__c> foyerPanList = new List<Foyer_Paneliste__c>();
        List<Equipements_du_foyer__c> foyerList = new List<Equipements_du_foyer__c>();
        List<Asset> eqtMesureList = new List<asset>();
        Map<Id, Id> foyerIdEqtMesureIdMap = new Map<Id,Id>();
        List<Statut_Device_Equipement_Mesure__c> statutDeviceToInsert = new List<Statut_Device_Equipement_Mesure__c>();
        
        eqtMesureList = [SELECT Id, AccountId FROM Asset WHERE Type_de_materiel__c = :Label.ASS_TypeMateriel_Streaming_Meter AND AccountId IN :foyerEqtFoyerMap.keySet()];
        for(Asset eqtMesure:eqtMesureList) {
            foyerIdEqtMesureIdMap.put(eqtMesure.AccountId, eqtMesure.Id);
        }
        
        foyerPanList= [SELECT Id, foyer__c FROM Foyer_Paneliste__c 
                       WHERE referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_Mesure_Plateforme 
                       AND (Statut_Foyer_paneliste__c != null
                           OR Statut_Foyer_paneliste__c = :Label.PAN_Statut_Panel_Chute_definitive)
                       AND foyer__c IN :foyerEqtFoyerMap.keySet()];
        for(Foyer_Paneliste__c foyerPan:foyerPanList) {
            foyerList.addAll(foyerEqtFoyerMap.get(foyerPan.foyer__c));
        }
        
        for (Equipements_du_foyer__c eqtFoyer: foyerList) {
            Statut_Device_Equipement_Mesure__c newStatutDevice = new Statut_Device_Equipement_Mesure__c();
            newStatutDevice.Equipement_du_foyer__c = eqtFoyer.Id;
            newStatutDevice.Equipement_de_mesure__c = foyerIdEqtMesureIdMap.get(eqtFoyer.foyer__c);
            statutDeviceToInsert.add(newStatutDevice);
        }
        
        
        if(statutDeviceToInsert.size()>0 && statutDeviceToInsert !=null){
            try{ 
                database.insert(statutDeviceToInsert);
            }Catch(exception ex){
                system.debug('$$$Insert Equipement de mesure Device rattaché à l\'équipement du foyer Exception Error:'+ex.getmessage());
            }
        }
    }
}