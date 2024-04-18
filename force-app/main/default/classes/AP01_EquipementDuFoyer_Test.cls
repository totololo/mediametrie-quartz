/*
* @Auteur : Téoman Sertçelik
* @date: 28/04/2022
* @ Description : test class de la fonctionnalité : -lors de l'ajout d'un équipement à un foyer : 
- on ajoute le nombre de poste tv du foyer + 1 au champ Numero_de_poste__c de l'équipement du foyer
- on incrémente de 1 le nom de l'équipement en fonction 
des équipements déjà présent sur le foyer

-lors de la suppression d'un équipement et si celui-ci fait partie d'un foyer :
- on soustrait le nombre de poste tv du foyer - 1 au champ Numero_de_poste__c de l'équipement du foyer
- on décremente de 1 le nom des équipements (supérieur 
à l'équipement supprimé) en fonction
de l'équipement supprimés

* @Class: AP01_EquipementDuFoyer
* @Coverage: 100%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/
@isTest
public with sharing class AP01_EquipementDuFoyer_Test {

  @isTest
    public static void insertAccIncrementName(){
        Id devRecordTypeId = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(label.EQPF_RecordType_PosteTV).getRecordTypeId();

        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;

        Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.Name = 'azer';
        eq1.RecordTypeId = devRecordTypeId;
        insert eq1;

        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name = 'Poste 0'];
        System.assertEquals(1, testEquipementFoyer.size()); 
    }

        @isTest
    public static void deleteAccIncrementName(){
        Id devRecordTypeId =  Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(label.EQPF_RecordType_PosteTV).getRecordTypeId();
        
        List<Equipements_du_foyer__c> listToDelete = new List<Equipements_du_foyer__c>();

        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Account acc2 = new Account();
        acc2.Name = 'toto2';
        insert acc2;

       Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.RecordTypeId = devRecordTypeId;
        eq1.Name = 'azer';
        insert eq1;
        
        
        
        Equipements_du_foyer__c eq2 = new Equipements_du_foyer__c();
        eq2.Foyer__c = acc.Id;
        eq2.RecordTypeId = devRecordTypeId;
        eq2.Name = 'tyui';
        insert eq2;

       Equipements_du_foyer__c eq3 = new Equipements_du_foyer__c();
        eq3.Foyer__c = acc2.Id;
        eq3.RecordTypeId = devRecordTypeId;
        eq3.Name = 'opqs';
        insert eq3;
        
        Equipements_du_foyer__c eq4 = new Equipements_du_foyer__c();
        eq4.Foyer__c = acc2.Id;
        eq4.RecordTypeId = devRecordTypeId;
        eq4.Name = 'dfgh';
        insert eq4;        
        
        listToDelete.add(eq1);

        delete listToDelete;

        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name Like '%Poste%'];
        System.assertEquals(testEquipementFoyer.size(), 3); 
        /*System.assertNotEquals(true, testEquipementFoyer.isEmpty());
        System.assertEquals(eq2.Id, testEquipementFoyer[0].Id); 
        System.assertEquals(eq4.Id, testEquipementFoyer[1].Id); */      
    }
}