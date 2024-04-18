/*
* @date: 23/09/2021
* @ Description : Ce trigger verifie/ modifie :
				- Vérifier qu'aucun produit du même type est actif
* @version 1.00   
* @Auteur Claire VEHRLE EIT
* @TestClass: AP05_Produit_Test
History
* <Date of modification> <Author> 	<Description of modification>
*/
trigger ProduitBeforeUpdade on Product2 (before update) {
/*
    if (PAD.canTrigger('AP05_Produit')) {
        System.debug('update');
        AP05_Produit.checkProductActiveAndTypeWithExistingProduct(Trigger.new);
        
    }
*/    
}