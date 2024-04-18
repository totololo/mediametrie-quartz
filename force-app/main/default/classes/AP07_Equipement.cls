/*
* @date: 04/08/2023
* @ Description : Lorsque le champ foyer panéliste d’un équipement de mesure Streaming Meter est rempli il faut affecté l'équipement de mesure à tous les enregistrements
					Device rattaché à l'équipement de mesure qui corresponde à des équipements du foyer du foyer du foyer panéliste 
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: AP07_Equipement_Test
* @Coverage: --%
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP07_Equipement {

    public static void associationAssetStatutDevice (List<Asset> assetList) {
        List<Statut_Device_Equipement_Mesure__c> statutDeviceARemplir = new List<Statut_Device_Equipement_Mesure__c>();
        List<Id> foyerIdList = new List<Id>();
        Map<Id, Id> assetIdFoyerIdMap = new Map<Id, Id>();
        for(Asset eqtMesure: assetList) {
            foyerIdList.add(eqtMesure.AccountId);
            assetIdFoyerIdMap.put(eqtMesure.AccountId, eqtMesure.Id);
        }
        statutDeviceARemplir = [SELECT Id, Equipement_du_foyer__r.foyer__c, Equipement_de_mesure__c FROM Statut_Device_Equipement_Mesure__c WHERE Equipement_du_foyer__r.foyer__c IN :foyerIdList];
        
        System.debug('$$$AP07 assetList: ' + assetList);
        System.debug('$$$AP07 assetIdFoyerIdMap: ' + assetIdFoyerIdMap);
        for(Statut_Device_Equipement_Mesure__c statutDevice: statutDeviceARemplir) {
            
            System.debug('$$$AP07 statutDevice.Equipement_du_foyer__r.foyer__c: ' + statutDevice.Equipement_du_foyer__r.foyer__c);
            System.debug('$$$AP07 assetIdFoyerIdMap.get(statutDevice.Equipement_du_foyer__r.foyer__c): ' + assetIdFoyerIdMap.get(statutDevice.Equipement_du_foyer__r.foyer__c));
            statutDevice.Equipement_de_mesure__c = assetIdFoyerIdMap.get(statutDevice.Equipement_du_foyer__r.foyer__c);
        }
        
        System.debug('$$$AP07 statutDeviceARemplir: ' + statutDeviceARemplir);
        if(statutDeviceARemplir.size()>0 && statutDeviceARemplir !=null){
            try{ 
                database.update(statutDeviceARemplir);
            }Catch(exception ex){
                system.debug('$$$Update Equipement de mesure Device rattaché à l\'équipement de mesure Exception Error:'+ex.getmessage());
            }
        }
    }
}