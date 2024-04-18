/** 
* @author: Marleine Abi Khalil
* @date: 29/03/2022 
* @description: Dissocier les ancieinnes cartes SIM des équipements de mesure qui ont maintenant une nouvelle carte SIM associé à eux
* @Test: Class AP05_Equipement_Test
*/
public class AP05_Equipement {
    public static void dissociateAsset(List<Asset> listNewAsset, Map<Id, Asset> mapOldAsset){
        
        Set<Id> setEquipIds = new Set<Id>();
        Set<Id> setCarteSimIds = new Set<Id>();
        Id recrdCarteSim = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(Label.ASS_RT_CarteSIM).getRecordTypeId();
        System.debug('$$$AP05_Equipement dissociateAsset listNewAsset size : '+listNewAsset.size());
        for(Asset equip : listNewAsset){
            System.debug('$$$AP05_Equipement dissociateAsset equip : '+equip);
            if(mapOldAsset != null){ // if after update
                if(mapOldAsset.get(equip.id).ParentId != equip.ParentId 
                   && equip.ParentId != null && equip.recordTypeId == recrdCarteSim){
                       setEquipIds.add(equip.ParentId);
                       setCarteSimIds.add(equip.Id);
                   }
            } 
            else if(equip.ParentId != null && equip.recordTypeId == recrdCarteSim){ // if after insert
                setEquipIds.add(equip.ParentId);
                setCarteSimIds.add(equip.Id);
            }
            
            
        }
        
        if(setEquipIds.size()>0){
            System.debug('$$$AP05_Equipement dissociateAsset setEquipIds.size() : '+setEquipIds.size());
            List<Asset> listCarteSimToUpdate = new List<Asset>();
            // Récupérer toutes les anciennes SIM cartes des Equipements
            List<Asset> listAsset = [SELECT Id, 
                                     (SELECT Id, ParentId FROM ChildAssets WHERE Id NOT IN :setCarteSimIds) 
                                     FROM Asset WHERE Id IN :setEquipIds];
            
            for(Asset equipmt : listAsset){
                if(equipmt.ChildAssets.size()>0){
                    for(Asset carteSim : equipmt.ChildAssets){
                        //dissocier les anciennes SIM cartes
                        carteSim.ParentId = null;
                        listCarteSimToUpdate.add(carteSim);
                    }
                }
            }
            System.debug('$$$AP05_Equipement dissociateAsset listCarteSimToUpdate.size() : '+listCarteSimToUpdate.size());
            if(listCarteSimToUpdate.size()>0){
                update listCarteSimToUpdate;
            }
        }  
    }
    
}