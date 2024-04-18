/*
* @author: Claire VEHRLE
* @date: 10/08/2022
* @ Description Class that test AP01_SuiviStockSAV . Associated Trigger : StockDeProduitAfterInsert
* History
* <Date of modification>	   <Author> 	   <Description of modification>
* <Description of modification>
*/
@isTest
public class AP02_StockProduit_Test {

    @isTest
    static void Test() {
        
        List<Product2> productToInsert = new List<Product2>();
        Product2 produit1 = new Product2();
        produit1.name = 'Produit Test';
        produit1.Code_article__c = '1A2B3C';
        productToInsert.add(produit1);
        
        Product2 produit2 = new Product2();
        produit2.name = 'Produit Test';
        produit2.Code_article__c = '4D5E6F';
        productToInsert.add(produit2);
        
        Product2 produit3 = new Product2();
        produit3.name = 'Produit Test';
        produit3.Code_article__c = '7G8H9I';
        productToInsert.add(produit3);
        
        insert productToInsert;
        
        List<Stock_de_produit__c> stockProduitList = new List<Stock_de_produit__c>();
        Stock_de_produit__c stockProduit1 = new Stock_de_produit__c();
        stockProduit1.Quantite__c = 123;
        stockProduit1.Valeur_du_stock__c = 1230;
        stockProduit1.Code_article__c = '1A2B3C';
        stockProduitList.add(stockProduit1);
        Stock_de_produit__c stockProduit2 = new Stock_de_produit__c();
        stockProduit2.Quantite__c = 223;
        stockProduit2.Valeur_du_stock__c = 2230;
        stockProduit2.Code_article__c = '4D5E6F';
        stockProduitList.add(stockProduit2);
        Stock_de_produit__c stockProduit3 = new Stock_de_produit__c();
        stockProduit3.Quantite__c = 323;
        stockProduit3.Valeur_du_stock__c = 3230;
        stockProduit3.Code_article__c = '7G8H9I';
        stockProduitList.add(stockProduit3);
        
        insert stockProduitList;
        
        List<Stock_de_produit__c> stockProduitToCheck = new List<Stock_de_produit__c>();
        stockProduitToCheck = [SELECT Id FROM Stock_de_produit__c WHERE Produit__c != null];
        
        System.assertEquals(3, stockProduitToCheck.size());
    }
}