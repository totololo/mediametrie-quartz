/*
* @date: 24/03/2023
* @ Description : Crée les produits commandés pour une commande créée
* @version 1.00   
* @Auteur Bastien Pinard
* @TestClass: 
* @Coverage: 
History
* <Date of modification> <Author> 	<Description of modification>
*/
public class AP01_ProduitCommande {
    @InvocableMethod
    public static void creerCommandePackRemplacementMateriel(List<String> listOrder) {
        
        List<PricebookEntry> products = [SELECT id, Product2Id,Product2.Name, UnitPrice, Product2.Family, Product2.Type_de_produit__c
                                         FROM pricebookentry WHERE  IsActive=true AND Product2.Remplacement_materiel__c = TRUE];
        Set<Id> SetCommandeToInsert = new Set<Id>();

        for(String o : listOrder){
            SetCommandeToInsert.add(o);
        }
        
        List<OrderItem> produitsCommandes = new List<OrderItem>();
        List<order> orderList = [
            SELECT  id, Foyer_paneliste__r.id, Foyer_paneliste__r.Nombre_de_set_meters__c , Foyer_paneliste__r.Nombre_de_beacons__c, Foyer_paneliste__r.Referentiel_Panel__r.Name,
            Foyer_paneliste__r.Nombre_de_pagers__c, Type
            FROM order WHERE id IN :SetCommandeToInsert
            AND Type = :Label.Ord_Type_PackRemplacementMateriel
        ];
        
        //if a retirer pour le dev sur les autres packs
        if(orderList!=null && orderList.size()>0){
            for(Order ordr : orderList){
                for(PricebookEntry pbe :products ){
                    if (ordr.Foyer_paneliste__r.Referentiel_Panel__r.Name == pbe.Product2.Family) {
                        OrderItem orderItem = new OrderItem();
                        if(ordr.Foyer_paneliste__r.Nombre_de_beacons__c !=null && ordr.Foyer_paneliste__r.Nombre_de_beacons__c !=0 && pbe.Product2.Type_de_produit__c==Label.Pro_type_Beacon) {
                            orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = ordr.Foyer_paneliste__r.Nombre_de_beacons__c , UnitPrice = pbe.UnitPrice);
                        }
                        else if (ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != null && ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != 0 &&
                                 pbe.Product2.Type_de_produit__c == Label.Pro_type_SetMeter) {
                                     orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = ordr.Foyer_paneliste__r.Nombre_de_set_meters__c , UnitPrice = pbe.UnitPrice);     
                                 }
                        else if(ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != null && ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != 0 &&
                                pbe.Product2.name.contains('hargeur') || pbe.Product2.name.contains('USB')) {
                                    orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = ordr.Foyer_paneliste__r.Nombre_de_set_meters__c + 1 , UnitPrice = pbe.UnitPrice);
                                }
                        else if(
                            pbe.Product2.name=='cordon cou' && 
                            (
                                (ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != null && 
                                 ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != 0) ||
                                (ordr.Foyer_paneliste__r.Nombre_de_pagers__c != null && 
                                 ordr.Foyer_paneliste__r.Nombre_de_pagers__c != 0)
                            )
                        ){
                            Decimal nbrCordon = 0;
                            if(ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != null && ordr.Foyer_paneliste__r.Nombre_de_set_meters__c != 0){
                                nbrCordon += ordr.Foyer_paneliste__r.Nombre_de_set_meters__c;
                            }
                            
                            if(ordr.Foyer_paneliste__r.Nombre_de_pagers__c != null && ordr.Foyer_paneliste__r.Nombre_de_pagers__c != 0){
                                nbrCordon += ordr.Foyer_paneliste__r.Nombre_de_pagers__c;
                            }
                            orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = nbrCordon, UnitPrice = pbe.UnitPrice);
                        }
                        else {
                            System.debug('$$$Else');
                            orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = 1 , UnitPrice = pbe.UnitPrice);
                        }
                        
                        System.debug('$$$OrderItem: ' + OrderItem);
                        produitsCommandes.add(OrderItem);
                    }
                }            
            }
        }
        
        system.debug('$$$produitsCommandes ' + produitsCommandes);
        if(produitsCommandes!=null && produitsCommandes.size()>0){
            try{ 
                database.insert(produitsCommandes);
            }Catch(exception ex){
                system.debug('Insert commande Pack Initial Exception Error:'+ex.getmessage());
            }
        }
    }
}