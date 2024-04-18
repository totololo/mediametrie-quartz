/*
* @Auteur : Bastien Pinard
* @date: 22/08/2022
* @ Description : -lors de l'ajout d'un équipement à un foyer : 
- on ajoute le nombre de poste tv du foyer + 1 au champ Numero_de_poste__c de l'équipement du foyer
- on incrémente de 1 le nom de l'équipement en fonction 
des équipements déjà présent sur le foyer

-lors de la suppression d'un équipement et si celui-ci fait partie d'un foyer :
- on soustrait le nombre de poste tv du foyer - 1 au champ Numero_de_poste__c de l'équipement du foyer
- on décremente de 1 le nom des équipements (supérieur 
à l'équipement supprimé) en fonction
de l'équipement supprimé

* @TestClass: AP01_EquipementDuFoyer_Test
* @Coverage: 100%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/

public with sharing class AP01_EquipementDuFoyer {
    
    public static void evaluateEquipementPosition(List<Equipements_du_foyer__c> listEquipementFoyer){
        Id devRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Set<Id> setFoyerIds = new Set<Id>();
        
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            if(eq.RecordTypeId == devRecordTypeId){
                setFoyerIds.add(eq.Foyer__c);
            }
        }
        
        Map<Id, AggregateResult> mapFoyer = new Map<Id, AggregateResult>
            ([SELECT Foyer__c  Id, COUNT(Id) countFoyer
              FROM Equipements_du_foyer__c
              WHERE Foyer__c IN : setFoyerIds 
              AND RecordTypeId=: devRecordTypeId
              AND Name LIKE 'Poste %'
              GROUP BY Foyer__c]);
        
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            if(eq.RecordTypeId == devRecordTypeId){                
                Integer currentFoyerCount = mapFoyer.isEmpty() ? 0 : (Integer) mapFoyer.get(eq.Foyer__c).get('countFoyer');
                
                eq.Numero_de_poste__c = currentFoyerCount;
                eq.Name = 'Poste' + ' '+ eq.Numero_de_poste__c;
            }
        }
    }
    
    public static void evaluateEquipementPositionDelete(Map<Id,Equipements_du_foyer__c> mapOldEquipementFoyer){
        Id devRecordTypeId =  Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(label.EQPF_RecordType_PosteTV).getRecordTypeId();
        Equipements_du_foyer__c oldEquipement = new Equipements_du_foyer__c();
        List<Equipements_du_foyer__c> listEquipementToUpdateDecrement = new List<Equipements_du_foyer__c>();
        Set<Id> listFoyerIds = new Set<Id>();
        Set<Id> listDeleteEquipementIds = new Set<Id>();
        Database.DMLOptions dml = new Database.DMLOptions(); 
		dml.DuplicateRuleHeader.allowSave = true;
        
        for(Equipements_du_foyer__c eq : mapOldEquipementFoyer.values()){
            if(eq.RecordTypeId == devRecordTypeId){
                listFoyerIds.add(eq.Foyer__c);
                listDeleteEquipementIds.add(eq.Id);
            }
        }
        
        List<Equipements_du_foyer__c> listEquipementFoyerOfOldAccount=  [SELECT Id, Foyer__c, Name
                                                                         FROM Equipements_du_foyer__c
                                                                         WHERE Foyer__c IN : listFoyerIds
                                                                         AND Id NOT IN : listDeleteEquipementIds
                                                                         AND RecordTypeId=: devRecordTypeId
                                                                         //AND Name LIKE 'POSTE %'
                                                                         ORDER BY CreatedDate 
                                                                        ];
        
        for(Id fo : listFoyerIds){
            Integer CountName = 0;
            for (Equipements_du_foyer__c eq : listEquipementFoyerOfOldAccount) {
                if(eq.Foyer__c == fo){
                    //if(eq.Name.startsWith('POSTE ')){
                        eq.Name = 'Poste ' + CountName;
                        eq.Numero_de_poste__c = CountName;
                        CountName += 1;
                        listEquipementToUpdateDecrement.add(eq);
                    //}
                }
            }
        }
        
        if(listEquipementToUpdateDecrement.size()>0 ){
            //update listEquipementToUpdateDecrement;
            Database.update(listEquipementToUpdateDecrement, dml);
            
        }
    }
}