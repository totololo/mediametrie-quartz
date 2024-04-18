/*
* @author: Claire VEHRLE
* @date: 09/08/2022
* @ Description Class that test AP01_SuiviStockSAV . Associated Trigger : StockDeProduitAfterInsert
* History
* <Date of modification>	   <Author> 	   <Description of modification>
<Description of modification>
*/
@isTest
public class AP01_SuiviStockSAV_Test {

    @isTest
    static void associeEquipementMesureSuviStockSAVNumeroDeSerieTest() {
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer = new Account();
        foyer.name = 'foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyerToInsert.add(foyer);
        
        insert foyerToInsert;
        
        Product2 produit = new Product2();
        produit.name = 'Produit Test';
        insert produit;
        
        List<Asset> equipementToInsert = new List<Asset>();
        Asset equipement1 = new Asset();
        equipement1.name = 'equipement1';
        equipement1.AccountId = foyer.Id;
        equipement1.SerialNumber = '1A2B3C';
        equipement1.Audimetre__c='kijbjbh';
        equipement1.product2Id = produit.Id;
        equipementToInsert.add(equipement1);
        
        Asset equipement2 = new Asset();
        equipement2.name = 'equipement2';
        equipement2.AccountId = foyer.Id;
        equipement2.Audimetre__c='ljk';
        equipement2.SerialNumber = '4D5E6F';
        equipement2.product2Id = produit.Id;
        equipementToInsert.add(equipement2);
        
        insert equipementToInsert;
        
        List<Suivi_Stock_SAV__c> suiviStockSAVToInsert = new List<Suivi_Stock_SAV__c>();
        Suivi_Stock_SAV__c suiviStockSAV1 = new Suivi_Stock_SAV__c();
        suiviStockSAV1.Numero_de_serie__c = '1A2B3C';
        suiviStockSAVToInsert.add(suiviStockSAV1);
        
        Suivi_Stock_SAV__c suiviStockSAV2 = new Suivi_Stock_SAV__c();
        suiviStockSAV2.Numero_de_serie__c = '4D5E6F';
        suiviStockSAVToInsert.add(suiviStockSAV2);
        
        insert suiviStockSAVToInsert;        
        
        List<Suivi_Stock_SAV__c> suiviStockSAVToCheck = new List<Suivi_Stock_SAV__c>();
        suiviStockSAVToCheck = [SELECT Id FROM Suivi_Stock_SAV__c ];         
       
        System.assertEquals(2, suiviStockSAVToCheck.size());
    }
    
        @isTest
    static void associeEquipementMesureSuviStockSAVAudimetreTest() {
        
        List<Account> foyerToInsert = new List<Account>();
        Account foyer = new Account();
        foyer.name = 'foyer';
        foyer.Numero_de_portable__c = '0123456789';
        foyerToInsert.add(foyer);
        
        insert foyerToInsert;
        
        Product2 produit = new Product2();
        produit.name = 'Produit Test';
        insert produit;
        
        List<Asset> equipementToInsert = new List<Asset>();
        Asset equipement1 = new Asset();
        equipement1.name = 'equipement1';
        equipement1.AccountId = foyer.Id;
        equipement1.Audimetre__c = '213EA';
        equipement1.product2Id = produit.Id;
        equipementToInsert.add(equipement1);
        
        Asset equipement2 = new Asset();
        equipement2.name = 'equipement2';
        equipement2.AccountId = foyer.Id;
        equipement2.Audimetre__c = '215AZ';
        equipement2.product2Id = produit.Id;
        equipementToInsert.add(equipement2);
        
        insert equipementToInsert;
        
        List<Suivi_Stock_SAV__c> suiviStockSAVToInsert = new List<Suivi_Stock_SAV__c>();
        Suivi_Stock_SAV__c suiviStockSAV1 = new Suivi_Stock_SAV__c();
        suiviStockSAV1.Meter_Id__c = '213EA';
        suiviStockSAVToInsert.add(suiviStockSAV1);
        
        Suivi_Stock_SAV__c suiviStockSAV2 = new Suivi_Stock_SAV__c();
        suiviStockSAV2.Meter_Id__c = '215AZ';
        suiviStockSAVToInsert.add(suiviStockSAV2);
        
        insert suiviStockSAVToInsert;
        
        List<Suivi_Stock_SAV__c> suiviStockSAVToCheck = new List<Suivi_Stock_SAV__c>();
        suiviStockSAVToCheck = [SELECT Id FROM Suivi_Stock_SAV__c WHERE equipement_de_mesure__c != null];
        
        System.assertEquals(2, suiviStockSAVToCheck.size());
    }
}