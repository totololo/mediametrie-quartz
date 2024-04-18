/** 
* @author: Claire VEHRLE
* @date: 09/08/2022 
* @description: Dissocier les ancieinnes cartes SIM des équipements de mesure qui ont maintenant une nouvelle carte SIM associé à eux
* @Test: Class AP01_SuiviStockSAV_Test
*/
trigger SuiviStockSAVBeforeInsert on Suivi_Stock_SAV__c (Before insert) {

    if(PAD.canTrigger('AP01_SuiviStockSAV')){
        AP01_SuiviStockSAV.associeEquipementMesureSuviStockSAVNumeroDeSerie(Trigger.New);
    }
}