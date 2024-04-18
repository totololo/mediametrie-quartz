/*
* @author: Claire VEHRLE
* @date: 10/07/2023
* @ Description Class that test AP03_StockProduit . Associated Trigger : StockDeProduitBeforeInsert
* History
* <Date of modification>	   <Author> 	   <Description of modification>
* 
*/
@isTest
public class AP03_StockProduit_Test {

    public static testMethod void completionStockStockProduit(){
        List<Stock__c> stockList = new List<Stock__c>();
        Stock__c generalIMS = new Stock__c();
        GeneralIMS.name = Label.STK_Nom_GeneralIMS;
        stockList.add(generalIMS);
        
        Stock__c generalCordon = new Stock__c();
        generalCordon.name = Label.STK_Nom_GeneralCordon;
        stockList.add(generalCordon);
        
        Stock__c generalOMWAVE = new Stock__c();
        generalOMWAVE.name = Label.STK_Nom_GeneralOMWAVE;
        stockList.add(generalOMWAVE);
        
        //MD
        Stock__c generalTAMET = new Stock__c();
        generalTAMET.name = Label.STK_Nom_GeneralTAMET;
        stockList.add(generalTAMET);
        
        Stock__c SAVIMS = new Stock__c();
        SAVIMS.name = Label.STK_Nom_SAVIMS;
        stockList.add(SAVIMS);
        
        Stock__c SAVCordon = new Stock__c();
        SAVCordon.name = Label.STK_Nom_SAVCordon;
        stockList.add(SAVCordon);
        
        Stock__c SAVOMWAVE = new Stock__c();
        SAVOMWAVE.name = Label.STK_Nom_SAVOMWAVE;
        stockList.add(SAVOMWAVE);
        
        //MD
        Stock__c SAVTAMET = new Stock__c();
        SAVOMWAVE.name = Label.STK_Nom_SAVTAMET;
        stockList.add(SAVTAMET);
        
        Stock__c rebutIMS = new Stock__c();
        rebutIMS.name = Label.STK_Nom_RebutIMS;
        stockList.add(rebutIMS);
        
        Stock__c rebutCordon = new Stock__c();
        rebutCordon.name = Label.STK_Nom_RebutCordon;
        stockList.add(rebutCordon);
        
        Stock__c rebutOMWAVE = new Stock__c();
        rebutOMWAVE.name = Label.STK_Nom_RebutOMWAVE;
        stockList.add(rebutOMWAVE);
        
        Stock__c rebutTAMET = new Stock__c();
        rebutTAMET.name = Label.STK_Nom_RebutTAMET;
        stockList.add(rebutTAMET);
        
        insert stockList;
        
        Product2 produit = new Product2();
        produit.name = 'Produit Test';
        insert produit;
        
        List<Stock_de_produit__c> stockProduitList = new List<Stock_de_produit__c>();
        Stock_de_produit__c stockProduit1 = new Stock_de_produit__c();
        stockProduit1.Etat__c = Label.STKP_Etat_General;
        stockProduit1.Prestataire__c = Label.STKP_Prestataire_IMS;
        stockProduit1.Quantite__c = 123;
        stockProduit1.Valeur_du_stock__c = 1230;
        stockProduit1.Produit__c = produit.Id;
        stockProduitList.add(stockProduit1);
        Stock_de_produit__c stockProduit2 = new Stock_de_produit__c();
        stockProduit2.Etat__c = Label.STKP_Etat_General;
        stockProduit2.Prestataire__c = Label.STKP_Prestataire_Cordon;
        stockProduit2.Quantite__c = 223;
        stockProduit2.Valeur_du_stock__c = 2230;
        stockProduit2.Produit__c = produit.Id;
        stockProduitList.add(stockProduit2);
        Stock_de_produit__c stockProduit3 = new Stock_de_produit__c();
        stockProduit3.Etat__c = Label.STKP_Etat_General;
        stockProduit3.Prestataire__c = Label.STKP_Prestataire_OMWAVE;
        stockProduit3.Quantite__c = 323;
        stockProduit3.Valeur_du_stock__c = 3230;
        stockProduit3.Produit__c = produit.Id;
        stockProduitList.add(stockProduit3);        
        
        Stock_de_produit__c stockProduit31 = new Stock_de_produit__c();   //MD
        stockProduit31.Etat__c = Label.STKP_Etat_General;
        stockProduit31.Prestataire__c = Label.STKP_Prestataire_TAMET;
        stockProduit31.Quantite__c = 3231;
        stockProduit31.Valeur_du_stock__c = 32301;
        stockProduit31.Produit__c = produit.Id;
        stockProduitList.add(stockProduit31);
        
        Stock_de_produit__c stockProduit4 = new Stock_de_produit__c();
        stockProduit4.Etat__c = Label.STKP_Etat_SAV;
        stockProduit4.Prestataire__c = Label.STKP_Prestataire_IMS;
        stockProduit4.Quantite__c = 423;
        stockProduit4.Valeur_du_stock__c = 4230;
        stockProduit4.Produit__c = produit.Id;
        stockProduitList.add(stockProduit4);
        Stock_de_produit__c stockProduit5 = new Stock_de_produit__c();
        stockProduit5.Etat__c = Label.STKP_Etat_SAV;
        stockProduit5.Prestataire__c = Label.STKP_Prestataire_Cordon;
        stockProduit5.Quantite__c = 523;
        stockProduit5.Valeur_du_stock__c = 5230;
        stockProduit5.Produit__c = produit.Id;
        stockProduitList.add(stockProduit5);
        Stock_de_produit__c stockProduit6 = new Stock_de_produit__c();
        stockProduit6.Etat__c = Label.STKP_Etat_SAV;
        stockProduit6.Prestataire__c = Label.STKP_Prestataire_OMWAVE;
        stockProduit6.Quantite__c = 623;
        stockProduit6.Valeur_du_stock__c = 6230;
        stockProduit6.Produit__c = produit.Id;
        stockProduitList.add(stockProduit6);        
        
        Stock_de_produit__c stockProduit7 = new Stock_de_produit__c();  
        stockProduit7.Etat__c = Label.STKP_Etat_SAV;
        stockProduit7.Prestataire__c = Label.STKP_Prestataire_TAMET;
        stockProduit7.Quantite__c = 723;
        stockProduit7.Valeur_du_stock__c = 7230;
        stockProduit7.Produit__c = produit.Id;
        stockProduitList.add(stockProduit7);
        
        //MD
        Stock_de_produit__c stockProduit1R = new Stock_de_produit__c();  
        stockProduit1R.Etat__c = Label.STKP_Etat_Rebut;
        stockProduit1R.Prestataire__c = Label.STKP_Prestataire_IMS;
        stockProduit1R.Quantite__c = 12341;
        stockProduit1R.Valeur_du_stock__c = 12341;
        stockProduit1R.Produit__c = produit.Id;
        stockProduitList.add(stockProduit1R);
        
        Stock_de_produit__c stockProduit2R = new Stock_de_produit__c();
        stockProduit2R.Etat__c = Label.STKP_Etat_Rebut;
        stockProduit2R.Prestataire__c = Label.STKP_Prestataire_Cordon;
        stockProduit2R.Quantite__c = 12342;
        stockProduit2R.Valeur_du_stock__c = 12342;
        stockProduit2R.Produit__c = produit.Id;
        stockProduitList.add(stockProduit2R);
        
        Stock_de_produit__c stockProduit3R = new Stock_de_produit__c();
        stockProduit3R.Etat__c = Label.STKP_Etat_Rebut;
        stockProduit3R.Prestataire__c = Label.STKP_Prestataire_OMWAVE;
        stockProduit3R.Quantite__c = 12345;
        stockProduit3R.Valeur_du_stock__c = 12345;
        stockProduit3R.Produit__c = produit.Id;
        stockProduitList.add(stockProduit3R);
        
        Stock_de_produit__c stockProduit4R = new Stock_de_produit__c();
        stockProduit4R.Etat__c = Label.STKP_Etat_Rebut;
        stockProduit4R.Prestataire__c = Label.STKP_Prestataire_TAMET;
        stockProduit4R.Quantite__c = 12346;
        stockProduit4R.Valeur_du_stock__c = 12346;
        stockProduit4R.Produit__c = produit.Id;
        stockProduitList.add(stockProduit4R);
        
        insert stockProduitList;
        
        Stock_de_produit__c stockProduit5R = new Stock_de_produit__c();
        stockProduit5R.Etat__c = Label.STKP_Etat_Rebut;
        stockProduit5R.Prestataire__c = Label.STKP_Prestataire_TAMET;
        stockProduit5R.Quantite__c = 12333;
        stockProduit5R.Valeur_du_stock__c = 123333;
        stockProduit5R.Produit__c = produit.Id;
        
        database.insert(stockProduit5R, false); 
        
    }
    
}