/*
* @date: 21/07/2021
* @ Description : creer des commandes reliee a des requetes
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: AP01_Commande_Test
* @Coverage: 95%
History
* <Date of modification>   		<Author>    		<Description of modification>
* 		05/01/2022   			Claire VEHRLE  		Ajout des produit commandé aux commande de pack initial
* 		16/03/2023   			Bastien Pinard      Condition cordon cou PNL-4511
*		09/05/2023				Marliat.D			MAJ Règle de calcul chargeurs & usb
*/
public class AP01_Commande {
    public static void creerCommandePackInitial(List<Case> listCase) {
        List<Order> ListCommandeToInsert = new List<Order>();
        Map<String, List<PricebookEntry>> mapProducts = new Map<String, List<PricebookEntry>>();
        System.debug('$$$AP01_Commande listCase : ' + listCase);
        
        
        List<PricebookEntry> products = [SELECT id, Product2.Name, UnitPrice, Product2.Family, Product2.Type_de_produit__c, Product2.Pack_Initial_Pager__c
                                         FROM pricebookentry WHERE  IsActive=true AND Product2.Pack_Initial_Pager__c = TRUE];
        
        mapProducts.put('Pager', products);
        
        List<PricebookEntry> productsSetMeter = [SELECT id, Product2.Name, UnitPrice, Product2.Family, Product2.Type_de_produit__c, Product2.Pack_initial_pager_et_setmeter__c
                                                 FROM pricebookentry WHERE  IsActive=true AND Product2.Pack_initial_pager_et_setmeter__c = TRUE];
        
        mapProducts.put('Setmeter', productsSetMeter);
        
        List<PricebookEntry> productsROAv3 = [SELECT id, Product2.Name, UnitPrice, Product2.Family, Product2.Type_de_produit__c, Product2.Pack_Initial_Pager_ROAv3__c
                                              FROM pricebookentry WHERE  IsActive=true AND Product2.Pack_Initial_Pager_ROAv3__c = TRUE];
        
        mapProducts.put('ROAv3', productsROAv3);
        
        List<PricebookEntry> productsROAv3Setmeter = [SELECT id, Product2.Name, UnitPrice, Product2.Family, Product2.Type_de_produit__c, Product2.Pack_Initial_Pager_ROAv3_Setmeter__c
                                                      FROM pricebookentry WHERE  IsActive=true AND Product2.Pack_Initial_Pager_ROAv3_Setmeter__c = TRUE];
        
        mapProducts.put('ROAv3Setmeter', productsROAv3Setmeter);
        
        
        for(Case cs : listCase){
            Order commandeToInsert = new Order();
            commandeToInsert.AccountId = cs.AccountId;
            commandeToInsert.Foyer_paneliste__c = cs.Foyer_paneliste__c;
            commandeToInsert.Status =Label.Ord_Status_VersionPreliminaire;
            commandeToInsert.EffectiveDate = date.today();
            commandeToInsert.Requete__c = cs.Id;
            commandeToInsert.Pricebook2Id=Label.Catalogue_de_prix_standard;
            if(cs.Sous_type__c == Label.CAS_Sous_type_PackInitial) {
                commandeToInsert.Type = Label.Ord_Type_PackInitialPager;
            }
            else if (cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_SetMeter) {
                commandeToInsert.Type = Label.Ord_Type_PackInitialPagerSetmeter;
            }
            else if (cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_ROAv3_Setmeter) {
                commandeToInsert.Type = Label.ORD_Type_PackInitial_ROAv3_Setmeter;
            }
            else if (cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_ROAv3) {
                commandeToInsert.Type = Label.ORD_Type_PackInitial_ROAv3;
            }
            ListCommandeToInsert.add(commandeToInsert);
        }
        
        System.debug('$$$AP01_Commande ListCommandeToInsert : ' + ListCommandeToInsert);
        if(ListCommandeToInsert.size()>0 && ListCommandeToInsert !=null){
            try{ 
                database.insert(ListCommandeToInsert);
            }Catch(exception ex){
                system.debug('Insert commande Exception Error:'+ex.getmessage());
            }
        }
        
        // ajouter les equipements a recuperer
        List<OrderItem> produitsCommandes = new List<OrderItem>();
        List<order> orderList = [
            SELECT  id, type, Foyer_paneliste__r.Nombre_de_set_meters__c , Foyer_paneliste__r.Nombre_de_beacons__c,
            Foyer_paneliste__r.Nombre_de_pagers__c
            FROM order WHERE id IN :ListCommandeToInsert
        ];
        
        for(Order ordr :orderList){// nb foyer paneliste = nb commande
            List<PricebookEntry> productsListToUse = new List<PricebookEntry>();
            
            if(ordr.Type == Label.Ord_Type_PackInitialPager) {
                System.debug('***Pager');
                productsListToUse = mapProducts.get('Pager');
            }
            else if (ordr.Type == Label.Ord_Type_PackInitialPagerSetmeter) {
                System.debug('***Setmeter');
                productsListToUse = mapProducts.get('Setmeter');
            }
            else if (ordr.Type == Label.ORD_Type_PackInitial_ROAv3_Setmeter) {
                System.debug('***ROAv3Setmeter');
                productsListToUse = mapProducts.get('ROAv3Setmeter');
            }
            else if (ordr.Type == Label.ORD_Type_PackInitial_ROAv3) {
                System.debug('***ROAv3');
                productsListToUse = mapProducts.get('ROAv3');
            }
            
            for(PricebookEntry pbe :productsListToUse ){
                System.debug('***pbe.Product2.Name: ' + pbe.Product2.Name);
                OrderItem orderItem = new OrderItem();
                orderItem.OrderId = ordr.id;
                orderItem.Product2Id = pbe.id;
                orderItem.UnitPrice = pbe.UnitPrice;
                if(ordr.Foyer_paneliste__r.Nombre_de_beacons__c >0 && pbe.Product2.Type_de_produit__c==Label.Pro_type_Beacon) { 
                    orderItem.Quantity = ordr.Foyer_paneliste__r.Nombre_de_beacons__c;
                    System.debug('***MD In OrderItem beacon ' + orderItem);
                    produitsCommandes.add(OrderItem);
                }
                else if (ordr.Foyer_paneliste__r.Nombre_de_set_meters__c > 0 && pbe.Product2.Type_de_produit__c == Label.Pro_type_SetMeter) {
                    orderItem.Quantity = ordr.Foyer_paneliste__r.Nombre_de_set_meters__c;
                    System.debug('**MD In OrderItem setMeter ' + orderItem);
                    produitsCommandes.add(OrderItem);
                }               
                
                else if((pbe.Product2.name.contains('hargeur') || pbe.Product2.name.contains('usb'))) {
                    if((ordr.Foyer_paneliste__r.Nombre_de_set_meters__c > 0)
                       && ((ordr.Type == Label.ORD_Type_PackInitial_ROAv3) ||(ordr.Type == Label.ORD_Type_PackInitial_ROAv3_Setmeter))) {
                           orderItem.Quantity = ordr.Foyer_paneliste__r.Nombre_de_set_meters__c; 
                           System.debug('**MD In OrderItem Chargeur ou USB setMeter & Pager > 0' + orderItem);
                           produitsCommandes.add(OrderItem);
                       }
                    else if ((ordr.Type == Label.Ord_Type_PackInitialPager) ||(ordr.Type == Label.Ord_Type_PackInitialPagerSetmeter)) {
                        orderItem.Quantity = ordr.Foyer_paneliste__r.Nombre_de_set_meters__c + 1;
                        System.debug('***MD In OrderItem Chargeur ou USB Initial Pager ' + orderItem);
                        produitsCommandes.add(OrderItem);
                    }
                }
                else {
                    System.debug('***Else');
                    orderItem.Quantity = 1;
                    produitsCommandes.add(OrderItem);
                    System.debug('***MD In OrderItem ELSE FINAL ' + orderItem);
                }
                
                System.debug('***OrderItem: ' + OrderItem);
                
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
    
    
    public static void creerCommandeChuteFoyerPan(List<foyer_Paneliste__c> listFoyerPaneliste) {
        List<Order> ListCommandeToInsert = new List<Order>();
        List<Order> ListCommandeToUpdate = new List<Order>();
        List<Id> FoyerPanelisteID= new List<Id>();
        List<foyer_Paneliste__c> listFoyerPanReq = new List<foyer_Paneliste__c>();
        Set<Id> setIdFoyerPan = new Set<Id>();
        List<Case> caseFPanList = new List<Case>();
        Map<Id, List<Case>> mapIdFoyerPanToListCase = new Map<Id, List<Case>>();
        Map<Id, Id> mapIdFPanCaseId = new Map<Id, Id>();
        Case caselastCreated = new Case(); 
        
        List<PricebookEntry> products=[SELECT id, UnitPrice FROM pricebookentry WHERE IsActive=true AND Product2.Chute__c = TRUE];
        
        
        If(listFoyerPaneliste.size()>0) {
            For(foyer_Paneliste__c fp : listFoyerPaneliste){
                setIdFoyerPan.add(fp.Id);
            }
        }
        
        If(listFoyerPaneliste.size()>0){  
            listFoyerPanReq = [SELECT Id, Name, Foyer__c, referentiel_panel__c,
                               (select Id, status, type, CreatedDate from Requetes__r order by CreatedDate desc Limit 1)
                               FROM foyer_paneliste__c 
                               WHERE Id IN :setIdFoyerPan 
                               AND referentiel_panel__r.type_de_panel__c =:Label.RFP_TypePanel_AIP];
        }  
        
        If(listFoyerPanReq.size()>0){
            For(foyer_Paneliste__c fp : listFoyerPanReq){
                for(Case req : fp.Requetes__r){
                    caselastCreated = req;
                }
                if(!mapIdFPanCaseId.containsKey(fp.Id) && caselastCreated != null){       
                    mapIdFPanCaseId.put(fp.Id,caselastCreated.Id);
                }
                caselastCreated = null;
            }
        }         
        For(foyer_Paneliste__c fp : listFoyerPanReq){
            Order commandeToInsert = new Order();
            commandeToInsert.AccountId = fp.Foyer__c;
            commandeToInsert.Foyer_paneliste__c = fp.Id; 
            commandeToInsert.Status = Label.Ord_Status_VersionPreliminaire; 
            commandeToInsert.Type = Label.Ord_Type_PackChute;
            commandeToInsert.EffectiveDate = date.today();
            commandeToInsert.Requete__c =  mapIdFPanCaseId.get(fp.Id);
            commandeToInsert.Pricebook2Id=Label.Catalogue_de_prix_standard;
            FoyerPanelisteID.add(fp.Id);
            ListCommandeToInsert.add(commandeToInsert);            
        }
        
        if(ListCommandeToInsert.size()>0 && ListCommandeToInsert !=null){
            System.debug('ListCommandeToInsert : ' + ListCommandeToInsert);
            try{ 
                database.insert(ListCommandeToInsert);
            }Catch(exception ex){
                system.debug('Insert commande Exception Error:'+ex.getmessage());
            }            
        }
        
        // ajouter les equipements a recuperer
        List<OrderItem> produitsCommandes = new List<OrderItem>();
        List<order> orderList = [SELECT id, Foyer_paneliste__r.id ,requete__c, Type
                                 FROM order WHERE id IN :ListCommandeToInsert];
        List<Foyer_paneliste__c> foyerpAsset= [select id , (select id , requete__c,status from equipements__r) from Foyer_paneliste__c where id in :FoyerPanelisteID];
        List<Asset> equToUpdate = new List<Asset>();
        for(Order ordr :orderList){// nb foyer paneliste = nb commande
            if(ordr.Type == Label.Ord_Type_PackChute ){// si commande de chute
                for(PricebookEntry pbe:products ){                    
                    OrderItem orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = 1, UnitPrice = pbe.UnitPrice);
                    produitsCommandes.add(orderItem);
                    for(Foyer_paneliste__c fop: foyerpAsset){
                        if(fop.id == ordr.Foyer_paneliste__c){
                            for(Asset equ :  fop.equipements__r){
                                equ.Requete__c=ordr.requete__c;
                                equ.status = Label.ASS_Statut_Desaffecte;
                                equ.Date_de_desaffectation__c=System.today();
                                if(!equToUpdate.contains(equ)){
                                    equToUpdate.add(equ);
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        if(produitsCommandes!=null && produitsCommandes.size()>0){
            try{ 
                database.insert(produitsCommandes);
            }Catch(exception ex){
                system.debug('Insert commande Chute Exception Error:'+ex.getmessage());
            }
        }
        system.debug('$$$KA ' + equToUpdate);
        if(equToUpdate!=null && equToUpdate.size()>0){
            try{ 
                database.update(equToUpdate);
            }Catch(exception ex){
                system.debug('Update equipements  Exception Error:'+ex.getmessage());
            }
        }
        
        //MD     
        
        
    }
    
    
    public static void creerCommandeRenvoieBeacon(List<Case> listCase) {
        List<Order> ListCommandeToInsert = new List<Order>();
        Pricebook2 stdPriceBook    = [select id, name from Pricebook2 where isStandard = true limit 1];
        List<Id> FoyerPanelisteID= new List<Id>();
        List<PricebookEntry> products = [SELECT id, UnitPrice , name , Product2.Type_de_produit__c FROM pricebookentry WHERE IsActive=true AND Product2.Renvoi_Beacon__c = TRUE];
        for(Case cs : listCase){
            Order commandeToInsert = new Order();
            commandeToInsert.AccountId = cs.AccountId;
            commandeToInsert.Foyer_paneliste__c = cs.Foyer_paneliste__c;
            commandeToInsert.Status =Label.Ord_Status_VersionPreliminaire;
            commandeToInsert.Type = Label.Ord_TypeCommande_RenvoiBeacon;
            commandeToInsert.EffectiveDate = date.today();
            commandeToInsert.Requete__c = cs.Id;
            commandeToInsert.Pricebook2Id=stdPriceBook.id;
            FoyerPanelisteID.add(cs.Foyer_paneliste__c);
            ListCommandeToInsert.add(commandeToInsert);
        }
        if(ListCommandeToInsert.size()>0 && ListCommandeToInsert !=null){
            try{ 
                database.insert(ListCommandeToInsert);
            }Catch(exception ex){
                system.debug('Insert commande Exception Error:'+ex.getmessage());
            }
        }
        // ajouter les equipements a recuperer
        List<OrderItem> produitsCommandes = new List<OrderItem>();
        List<order> orderList = [SELECT id, Foyer_paneliste__r.id, Foyer_paneliste__r.Nombre_de_beacons__c FROM order WHERE id IN :ListCommandeToInsert];
        for(Order ordr :orderList){// nb foyer paneliste = nb commande
            for(PricebookEntry pbe : products ){
                if(ordr.Foyer_paneliste__r.Nombre_de_beacons__c != null && ordr.Foyer_paneliste__r.Nombre_de_beacons__c != 0 && pbe.Product2.Type_de_produit__c == Label.Pro_type_Beacon){// ajout de beacon si le foyer paneliste a plus que 0 
                    OrderItem orderItem = new OrderItem(OrderId = ordr.id, Product2Id = pbe.id, Quantity = ordr.Foyer_paneliste__r.Nombre_de_beacons__c ,UnitPrice = pbe.UnitPrice);
                    produitsCommandes.add(orderItem);
                }
            }
        }
        
        if(produitsCommandes!=null && produitsCommandes.size()>0){
            try{ 
                database.insert(produitsCommandes);
            }Catch(exception ex){
                system.debug('Insert commande Renvoie Beacon Exception Error:'+ex.getmessage());
            }
        }
    }
    
    
    
}