/*
* @author: Claire VEHRLE
* @date: 10/08/2022 
* @ Description: Classe appelé par le Trigger SuiviStockSAVAfterInsert
* @TestClass: AP01_StockProduit_Test
* @Coverage: --%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*
* */
public class AP02_StockProduit {

    public static void associeProduit(List<Stock_de_Produit__c> stockProduitList) {
        
        List<String> codeArticleList = new List<String>();
        List<Product2> productList = new List<Product2>();
        Map<String, Id> codeArticleProduitMap = new Map<String, Id>();
        for(Stock_de_Produit__c stockProduit:stockProduitList) {
            codeArticleList.add(stockProduit.Code_Article__c);
        }
        system.debug('***codeArticleList: ' +codeArticleList);
        
        productList = [SELECT Id, code_Article__c FROM Product2 WHERE code_Article__c IN :codeArticleList];
        
        system.debug('***productList: ' +productList);
        
        for (Product2 produit:productList) {
            codeArticleProduitMap.put(produit.code_article__c, produit.Id);
        }
        
        for(Stock_de_Produit__c stockProduit:stockProduitList) {
            stockProduit.Produit__c = codeArticleProduitMap.get(stockProduit.Code_Article__c);
        }
        
        try{ 
            database.update(stockProduitList);
        }Catch(exception ex){
            system.debug('Update Stock de produit Ajout du produit Exception Error:' + ex.getmessage());
        }
    }
}