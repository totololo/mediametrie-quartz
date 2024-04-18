/*
* @author: Claire 
* @date: 20/12/2022
* @ Description : Unicité du MeterId (Audimetre__c) pour les équipements
* @TestClass: AP09_equipement_Test
* @Coverage: --%

* History
* <Date of modification>   <Author>    <Description of modification>
*/

public class AP09_Equipement {

    public static Map<String, List<Asset>> meterIdUnique (List<Asset> EquipementList) {
        Boolean unique = false;
        List<String> meterIdList = new List<String>();
        List<Asset> eqtToCompare = new List<Asset>();
        Map<String, List<Asset>> eqtParMeterIdMap = new Map<String, List<Asset>>();
        
        for(Asset eqt: EquipementList) {
            meterIdList.add(eqt.Audimetre__c);
        }
        eqtToCompare = [SELECT Id, Audimetre__c FROM Asset 
                        WHERE Audimetre__c IN :meterIdList
                       AND Status != :Label.ASS_Statut_En_cours_de_supression_OCOM
                       AND Status != :Label.ASS_Statut_Supprime
                       AND Type_de_materiel__c != :Label.ASS_TypeMateriel_Streaming_Meter
                       AND Type_de_materiel__c != :Label.Ass_TypeMateriel_RouteurGoogle];
        for(Asset eqt:eqtToCompare) {
            if(eqtParMeterIdMap.get(eqt.Audimetre__c) != null) {
                eqtParMeterIdMap.get(eqt.Audimetre__c).add(eqt);
            }
            else {
                eqtParMeterIdMap.put((eqt.Audimetre__c), new List<Asset>{eqt});
            }
        }
        
        return eqtParMeterIdMap;
    }
}