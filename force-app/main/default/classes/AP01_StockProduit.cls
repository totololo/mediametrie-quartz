/*
* @author: Claire VEHRLE
* @date: 17/06/2022
* @ Description Class that updates the status of Étiquettes when the connection status on the equipments (Assets) is changed
* @TestClass: AP01_StockProduit_Test
* @Coverage: 98 %
* History
* <Date of modification>	   <Author> 	   <Description of modification>
* 31/03/2023                    Marliat.D      Ajout TAMET 
*/
public class AP01_StockProduit {

    public static void associationStock(List<Stock_de_Produit__c> stockProduitList) {
        
        List<Stock__c> listStockPrestataire = [SELECT Id, name FROM Stock__c ];
        String IMSStockGeneral;
        String IMSStockSAV;
        String IMSStockRebut;
        String cordonStockGeneral;
        String cordonStockSAV;
        String cordonStockRebut;
        String OMWAVEStockGeneral;
        String OMWAVEStockSAV;
        String OMWAVEStockRebut;
        String TAMETStockGeneral;   
        String TAMETStockRebut;    
        String TAMETStockSAV;	  
        
        for(Stock__c stock:listStockPrestataire) {
            if(stock.name == Label.STK_Nom_GeneralIMS) {
                IMSStockGeneral = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_SAVIMS) {
                IMSStockSAV = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_RebutIMS) {
                IMSStockRebut = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_GeneralCordon) {
                cordonStockGeneral = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_SAVCordon) {
                cordonStockSAV = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_RebutCordon) {
                cordonStockRebut = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_GeneralOMWAVE) {
                OMWAVEStockGeneral = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_SAVOMWAVE) {
                OMWAVEStockSAV = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_RebutOMWAVE) {
                OMWAVEStockRebut = stock.Id;
            }
             else if(stock.name == Label.STK_Nom_GeneralTAMET) {
                TAMETStockGeneral = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_SAVTAMET) {
               TAMETStockSAV = stock.Id;
            }
            else if(stock.name == Label.STK_Nom_RebutTAMET) {
               TAMETStockRebut = stock.Id;
            }
        }
        
        for(Stock_de_Produit__c stockProduit:stockProduitList) {
            if(stockProduit.Etat__c == Label.STKP_Etat_General && stockProduit.Prestataire__c == Label.STKP_Prestataire_IMS) {
                stockProduit.Stock__c = IMSStockGeneral;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_General && stockProduit.Prestataire__c == Label.STKP_Prestataire_Cordon) {
                stockProduit.Stock__c = cordonStockGeneral;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_General && stockProduit.Prestataire__c == Label.STKP_Prestataire_OMWAVE) {
                stockProduit.Stock__c = OMWAVEStockGeneral;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_General && stockProduit.Prestataire__c == Label.STKP_Prestataire_TAMET) {    //MD
                stockProduit.Stock__c = TAMETStockGeneral;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_SAV && stockProduit.Prestataire__c == Label.STKP_Prestataire_IMS) {
                stockProduit.Stock__c = IMSStockSAV;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_SAV && stockProduit.Prestataire__c == Label.STKP_Prestataire_Cordon) {
                stockProduit.Stock__c = cordonStockSAV;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_SAV && stockProduit.Prestataire__c == Label.STKP_Prestataire_TAMET) {    //MD
                stockProduit.Stock__c = TAMETStockSAV;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_SAV && stockProduit.Prestataire__c == Label.STKP_Prestataire_OMWAVE) {
                stockProduit.Stock__c = OMWAVEStockRebut;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_Rebut && stockProduit.Prestataire__c == Label.STKP_Prestataire_IMS) {
                stockProduit.Stock__c = IMSStockRebut;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_Rebut && stockProduit.Prestataire__c == Label.STKP_Prestataire_Cordon) {
                stockProduit.Stock__c = cordonStockRebut;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_Rebut && stockProduit.Prestataire__c == Label.STKP_Prestataire_OMWAVE) {
                stockProduit.Stock__c = OMWAVEStockRebut;
            }
            else if(stockProduit.Etat__c == Label.STKP_Etat_Rebut && stockProduit.Prestataire__c == Label.STKP_Prestataire_TAMET) {    //MD
                stockProduit.Stock__c = TAMETStockRebut;
            }
        }
        
        try{ 
            database.update(stockProduitList);
        }Catch(exception ex){
            system.debug('Update Stock de produit Exception Error:' + ex.getmessage());
        }
    }
}