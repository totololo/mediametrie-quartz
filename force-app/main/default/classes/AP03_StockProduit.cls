/*
* @author: Claire VEHRLE
* @date: 06/07/2023 
* @ Description: Classe appelé par le Trigger SuiviStockSAVAfterInsert
* @TestClass: AP03_StockProduit_Test
* @Coverage: --%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*
* */
public class AP03_StockProduit {

    public static Map<Stock_de_Produit__c, Id> insertOrUpdate(List<Stock_de_Produit__c> stockProduitList) {
        List<Stock_de_Produit__c> enregistrementExistant = new List<Stock_de_Produit__c>();
        List<Stock_de_Produit__c> stockDeProduitToUpdate = new List<Stock_de_Produit__c>();
        Map<Stock_de_Produit__c, Id> StockProduitId = new Map<Stock_de_Produit__c, Id>();
        
        enregistrementExistant = [SELECT Id, name, Produit__c, Stock__c, Quantite__c, Valeur_du_stock__c  FROM Stock_de_Produit__c];
        
        for(Stock_de_Produit__c stprdt:stockProduitList) {
            for(Stock_de_Produit__c stprdtExistant:enregistrementExistant) {
                if((stprdt.Produit__c == stprdtExistant.Produit__c) && (stprdt.Stock__c == stprdtExistant.Stock__c)) {
                    stprdtExistant.Quantite__c = stprdt.Quantite__c;
                    stprdtExistant.Valeur_du_stock__c = stprdt.Valeur_du_stock__c;
                    stockDeProduitToUpdate.add(stprdtExistant);
                    StockProduitId.put(stprdt, stprdtExistant.Id);
                }
            }
        }
        
        return StockProduitId;
    }
}