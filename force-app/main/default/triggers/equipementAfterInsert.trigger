/** 
* @author: Marleine Abi Khalil
* @date: 29/03/2022 
* @description: Dissocier les ancieinnes cartes SIM des équipements de mesure qui ont maintenant une nouvelle carte SIM associé à eux
* @Test: Class AP05_Equipement_Test
*/
trigger equipementAfterInsert on Asset (after insert) {
	// MAK - Dissocier les anciennes cartes SIM des équipements de mesure qui ont maintenant une nouvelle carte SIM associé à eux
	 if(PAD.canTrigger('AP05_Equipement') && !Userinfo.getUserId().Contains(Label.UserIntegration_Id)){
         AP05_Equipement.dissociateAsset(Trigger.new, null);
     }
    
    if(PAD.canTrigger('AP09_Equipement')){
        List<Asset> eqtMesureList = new List<Asset>();
        for(Asset eqtMesure: Trigger.New) {
            if(eqtMesure.Type_de_materiel__c != Label.ASS_TypeMateriel_Streaming_Meter && eqtMesure.Type_de_materiel__c != Label.Ass_TypeMateriel_RouteurGoogle) {
                eqtMesureList.add(eqtMesure);
            }
        }
        
        Map<String, List<Asset>> eqtParMeterIdMap = AP09_Equipement.meterIdUnique(eqtMesureList);
        String erreur;
        Boolean isThereErreur = false;
        erreur = 'Les meterId suivant correpondent à des équipements de mesure déjà présent dans Salesforce: ';
        for (String meterId:eqtParMeterIdMap.keySet()) {
            System.debug('$$$eqtParMeterIdMap.get(meterId).size: ' + eqtParMeterIdMap.get(meterId).size());
            if(eqtParMeterIdMap.get(meterId).size() > 1) {
                erreur = erreur + '{'+ meterId + '} ';
                isThereErreur = true;
            }
        }
        if(isThereErreur) {
            eqtMesureList[0].addError(erreur);
        }        
        
        
     }
}