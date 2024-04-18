/*
* @Auteur : Bastien Pinard
* @date: 30/08/2022
* @ Description :
* @TestClass: AP03_EquipementDuFoyer_Test
* @Coverage: 100%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/

public with sharing class AP03_EquipementDuFoyer {
    public static void DeleteEquipements(List<Equipements_du_foyer__c> listEquipementFoyer){
        System.debug('bastien listEquipementFoyer : '+listEquipementFoyer);
        Id peripheriqueRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Périphériques').getRecordTypeId();
        Id devRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Poste TV').getRecordTypeId();
        Set<Id> equipementsId = new Set<Id>();
        for(Equipements_du_foyer__c eq : listEquipementFoyer){
            if(eq.RecordTypeId==devRecordTypeId){
                equipementsId.add(eq.Id);
            }
        }

        if(equipementsId.size()>0){
            List<Equipements_du_foyer__c> listPeripheriquesToDelete = [
                SELECT Id
                FROM Equipements_du_foyer__c
                WHERE Poste_TV__c IN :equipementsId
                AND RecordTypeId =:peripheriqueRecordTypeId
            ];

            if(listPeripheriquesToDelete.size()>0){
                delete listPeripheriquesToDelete;
            }
        }
    }
}