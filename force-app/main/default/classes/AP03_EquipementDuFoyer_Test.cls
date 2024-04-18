/*
* @Auteur : Bastien PINARD
* @date: 30/08/2022
* @ Description : 

* @Class: AP03_EquipementDuFoyer
* @Coverage: 100%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/
@isTest
public with sharing class AP03_EquipementDuFoyer_Test {
    @isTest
    public static void deletePeripherique(){
        Id devPeriRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Périphériques').getRecordTypeId();
        Id devPosteTVRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Poste TV').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.Name = 'azer';
        eq1.RecordTypeId = devPosteTVRecordTypeId;
        insert eq1;
        
        Equipements_du_foyer__c eq2 = new Equipements_du_foyer__c();
        eq2.Foyer__c = acc.Id;
        eq2.Name = 'azer';
        eq2.Type__c='5';
        eq2.Poste_TV__c=eq1.Id;
        eq2.RecordTypeId = devPeriRecordTypeId;
        eq2.Modele_de_console_de_jeux__c='28';
        insert eq2;
        
        delete eq1;
        
        
        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name = 'Console Poste 0 SONY - PLAYSTATION 3'];
        System.assertEquals(0, testEquipementFoyer.size()); 
    }
}