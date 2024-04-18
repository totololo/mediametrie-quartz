/*
* @author: Khaled Hammoudeh
* @date: 25/09/2020
* @ Description trigger that launches after the assets/Equipements are updated
* @TestClass: AP01_Equipement_Test
* @Coverage: 100 %
* History
* Date of modification:
* <Date of modification>	   <Author> 	   <Description of modification>
* 		06/09/2021   		Ayoub GHAMMAZ  		  Description of modification: send all assets with 'installe' status to AP01_FoyerPaneliste
*		12/01/2022			Ayoub GHAMMAZ		ajout d'une nouvelle fonctionnalité : Dissocier l'équipement de mesure dans OCOM dans le cas d'une panne, chute, désinstallation. Appel a la methode "DissocierEquipementOcom" de la classe "AP02_Equipement" 
*		12/01/2022			Téoman Sertçelik 	ajout d'une nouvelle fonctionnalité : mis à jour de l'asset dans Google quand celui-ci est associé au foyer panéliste ou son statut updated
*		27/01/2022 			jerome 				ajout asset to send to ocom => appele AP02_equipement
*		07/03/2022 			Ayoub GHAMMAZ 		ajout de la classe Xpour invoquer le fluc google quand le equipement de mesure est associé ou dissocié à un foyer
*		04/08/2023			Claire VEHRLE		TMASF-413 Remplissage équipement mesure sur l'objet Statut_Device_Equipement_Mesure__c
*		09/08/2023			Claire VEHRLE		TMASF-411 Appel Mulesoft Désisntallation Streaming
*/
trigger equipementAfterUpdate on Asset (after update) {
    
    if(PAD.canTrigger('AP01_Equipement')) {
        list<asset> listEquipements = new list<asset>();
        List<Id> listIdEquipements = new List<Id>(); //257
        List<Id> listIdRelatedFoyers = new List<Id>(); //257
        
        for(asset equipement : trigger.new)
        {
            if(equipement.Statut_de_connexion__c != Label.ASS_StatutDeConnexion_Disconnected && equipement.Statut_de_connexion__c != null &&
             (trigger.oldMap.get(equipement.Id).Statut_de_connexion__c == Label.ASS_StatutDeConnexion_Disconnected || trigger.oldMap.get(equipement.Id).Statut_de_connexion__c == null))
            {
                listEquipements.add(equipement);
                listIdEquipements.add(equipement.Id); 
                listIdRelatedFoyers.add(equipement.Foyer_paneliste__c); 
            }
        }
        
        if(listEquipements.size() > 0)
        {
            AP01_Equipement.updateEtiquettesControlesRequetes(listEquipements, listIdEquipements, listIdRelatedFoyers); //257
            //AP01_Equipement.updateEtiquettesStatus(listEquipements);
        }
        /*
        for(asset equipement : trigger.new) {
            if(equipement.Statut_de_connexion__c != Label.ASS_StatutDeConnexion_Disconnected && 
               trigger.oldMap.get(equipement.Id).Statut_de_connexion__c == Label.ASS_StatutDeConnexion_Disconnected)
            {
                listEquipements.add(equipement);
            }
            if(listEquipements.size() > 0) {
                AP01_Equipement.updateEtiquettesStatus(listEquipements);
		}*/
    }
    
    if(PAD.canTrigger('AP03_FoyerPaneliste')){
        List<Id> listToUpdate = new List<Id>();
        for(asset equipement : trigger.new) {
            if(equipement.Status==Label.ASS_Statut_Installe && equipement.Status!=Trigger.oldMap.get(equipement.id).status ) {
                listToUpdate.add(equipement.Foyer_paneliste__c);// modifier si il n'etait pas installe avant 
                system.debug('qq '+equipement.Foyer_paneliste__c);
                //Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
            }
            
        }
        if(listToUpdate.size() > 0) {
                
                AP03_FoyerPaneliste.MajStatutInstalle(listToUpdate);
            }
    }
    
    if(PAD.canTrigger('AP01_Requete')){
    Boolean equipementCollecteAudience = false;
        for(asset equipement : trigger.new) {
                if (equipement.Date_de_premiere_collecte_d_audience__c != null &&
                    Trigger.oldMap.get(equipement.Id).Date_de_premiere_collecte_d_audience__c != equipement.Date_de_premiere_collecte_d_audience__c) {
                        equipementCollecteAudience = true;
                    }
            }
            if(equipementCollecteAudience) {
                AP01_Requete.clotureRequete();
            }
    }
     
    if(PAD.canTrigger('AP02_Equipement')){
        System.debug('$$$AP02_Equipement');
        
        List<String> associotionMeterToSend = new List<String>();
        Map<String, String> dissociotionMeterToSendMap = new Map<String, String>();
        for(Asset equi :Trigger.new){
            System.debug('$$$equipementAfterUpdate AP02_Equipement Asset : ' + equi);
            System.debug('$$$equipementAfterUpdate AP02_Equipement equi.Account.foyer_stock__c : ' + equi.AccountId);
            System.debug('$$$equipementAfterUpdate Trigger.oldMap.get(equi.id).Account.foyer_stock__c) : ' + Trigger.oldMap.get(equi.id).AccountId);
            if (equi.AccountId != Trigger.oldMap.get(equi.id).AccountId) {
                if(equi.foyer_paneliste__c != null) {
                    associotionMeterToSend.add(equi.Id);
                }
                else {
                    System.debug('$$$equipementAfterUpdate AP02_Equipement else');
                    if (!(equi.Account.foyer_stock__c && Trigger.oldMap.get(equi.id).Account.foyer_stock__c)) {
                        System.debug('$$$equipementAfterUpdate AP02_Equipement equi.Account.foyer_stock__c : ' + equi.Account.foyer_stock__c);
                        System.debug('$$$equipementAfterUpdate Trigger.oldMap.get(equi.id).Account.foyer_stock__c) : ' + Trigger.oldMap.get(equi.id).Account.foyer_stock__c);
                        dissociotionMeterToSendMap.put(Trigger.oldMap.get(equi.id).Id, Trigger.oldMap.get(equi.id).foyer_paneliste__c);
                    }
                    
                }
            }
        }
        
        if(dissociotionMeterToSendMap!=null){
                    System.debug('$$$equipementAfterUpdate dissociotionMeterToSendMap : ' + dissociotionMeterToSendMap);
            AP02_Equipement.DissocierEquipementOcom(dissociotionMeterToSendMap);
        }
        
        if(associotionMeterToSend!=null && associotionMeterToSend.size()>0){
            AP02_Equipement.PutMeterConfMetier(associotionMeterToSend);
        }
        
    }
    
    if(PAD.canTrigger('AP04_Equipement')){
        System.debug('AP04_Equipement Trigger');
        AP04_Equipement.checkIfSupprime(Trigger.new, Trigger.oldMap);
    }
    
    if(PAD.canTrigger('AP05_Equipement')){
        AP05_Equipement.dissociateAsset(Trigger.new, Trigger.oldMap);
    }    
    
    if(PAD.canTrigger('AP06_Equipement')){
        System.debug('AP06_Equipement Trigger');
        Map<Id, Boolean> foyerPanelisteMap = new Map<Id, Boolean>();
        for(Asset equipement: Trigger.New) {
            if (equipement.type_de_Materiel__c == Label.Ass_TypeMateriel_RouteurGoogle && equipement.Accountid != Trigger.oldMap.get(equipement.Id).Accountid) {
                if(equipement.Foyer_paneliste__c != null) {
                    foyerPanelisteMap.put(equipement.Foyer_paneliste__c, true);
                }
                else {
                    foyerPanelisteMap.put(Trigger.oldMap.get(equipement.Id).Foyer_paneliste__c, false);
                }
            }
        }
        
        AP06_Equipement.checkSendToMulesoft(foyerPanelisteMap);
    }
    
    if(PAD.canTrigger('AP07_Equipement')) {
        List<Asset> assetPourRemplir = new List<Asset>();
        for(Asset eqt: Trigger.new) {
            if(eqt.foyer_paneliste__c != null && Trigger.oldMap.get(eqt.Id).foyer_paneliste__c == null && eqt.Type_de_materiel__c == Label.ASS_TypeMateriel_Streaming_Meter) {
                assetPourRemplir.add(eqt);
            }
        }
        
        if(assetPourRemplir.size()>0 && assetPourRemplir !=null){
            AP07_Equipement.associationAssetStatutDevice(assetPourRemplir);
        }
    }
    
    if(PAD.canTrigger('AP08_Equipement')) {
        List<Asset> assetPourRemplir = new List<Asset>();
        for(Asset eqt: Trigger.new) {
            if(eqt.Status == Label.ASS_Statut_Desinstalle && Trigger.oldMap.get(eqt.Id).Status != Label.ASS_Statut_Desinstalle && eqt.Type_de_materiel__c == Label.ASS_TypeMateriel_Streaming_Meter) {
                assetPourRemplir.add(eqt);
            }
        }
        
        if(assetPourRemplir.size()>0 && assetPourRemplir !=null){
            AP08_Equipement.desintallationStreamingMeter(assetPourRemplir);
        }
    }
}