/*
* @date: 17/06/2022
* Déclencheur à l'insertion "after"
* Description : -Association des valeur de stocks
* @version 1.00   
* @Auteur Claire VEHRLE
* <Date of modification>   			<Author>   		 <Description of modification>
*		26/04/2022				Claire VEHRLE			Ajout/Suppression des valeurs du champ Types de panel sur Foyer
*/
trigger StockDeProduitBeforeInsert on Stock_de_produit__c (Before insert) {
    
    if(PAD.canTrigger('AP01_StockProduit')) {
        AP01_StockProduit.associationStock(Trigger.new);
    }
    if(PAD.canTrigger('AP02_StockProduit')) {
        AP02_StockProduit.associeProduit(Trigger.new);
    }
    if(PAD.canTrigger('AP03_StockProduit')) {
        Map<Stock_de_Produit__c, Id> StockProduitId = AP03_StockProduit.insertOrUpdate(Trigger.new);
        
        for(Stock_de_Produit__c error:StockProduitId.keySet()) {
            error.addError(StockProduitId.get(error));
        }
    }

}