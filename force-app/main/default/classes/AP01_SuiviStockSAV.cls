/*
* @author: Claire VEHRLE
* @date: 09/08/2022 
* @ Description: Classe appelé par le Trigger SuiviStockSAVfterInsert
* @TestClass: AP01_SuiviStockSAV_Test
* @Coverage: --%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*
*
* */
public class AP01_SuiviStockSAV {

    public static void associeEquipementMesureSuviStockSAVNumeroDeSerie (List<Suivi_Stock_SAV__c> SuivsiStockSAVList) {
        
        List<String> numeroDeSerieList = new List<String>();
        List<String> meterIdList = new List<String>();
        List<Asset> equipementDeMesureId = new List<Asset>();
        Map<String, Id> numeroDeSerieAssetId = new Map<String, Id>();
        Map<String, Id> audimetreAssetId = new Map<String, Id>();
        for(Suivi_Stock_SAV__c suiviStockSAV:SuivsiStockSAVList) {
            if(suiviStockSAV.Meter_Id__c!=null){
            	meterIdList.add(suiviStockSAV.Meter_Id__c);
            } else if (suiviStockSAV.Numero_de_serie__c!=null){
            	numeroDeSerieList.add(suiviStockSAV.Numero_de_serie__c);
            }
        }
        equipementDeMesureId = [SELECT Id, SerialNumber, Audimetre__c FROM Asset WHERE SerialNumber IN :numeroDeSerieList OR Audimetre__c IN :meterIdList];

        for (Asset equipementDeMesure:equipementDeMesureId) {
            if(equipementDeMesure.Audimetre__c !=null){
            	audimetreAssetId.put(equipementDeMesure.Audimetre__c, equipementDeMesure.Id);
            }else if (equipementDeMesure.SerialNumber!=null){
            	numeroDeSerieAssetId.put(equipementDeMesure.SerialNumber, equipementDeMesure.Id);
            }
        }
        
        for(Suivi_Stock_SAV__c suiviStockSAV:SuivsiStockSAVList) {
            if(audimetreAssetId.get(suiviStockSAV.Meter_Id__c) !=null){
            	suiviStockSAV.equipement_de_mesure__c = audimetreAssetId.get(suiviStockSAV.Meter_Id__c);
            } else if (numeroDeSerieAssetId.get(suiviStockSAV.Numero_de_serie__c) != null){
            	suiviStockSAV.equipement_de_mesure__c = numeroDeSerieAssetId.get(suiviStockSAV.Numero_de_serie__c);
            }
        }

        if(SuivsiStockSAVList.size() > 0 && SuivsiStockSAVList != null){
            try{ 
                Database.update(SuivsiStockSAVList);
            }Catch(exception ex){
                system.debug('Update Suivi Stock SAV Exception Error:' + ex.getmessage());
            }
        } 
        
    }
}