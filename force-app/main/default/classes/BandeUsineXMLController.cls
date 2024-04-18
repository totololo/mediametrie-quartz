/*
* @author: Ayoub GHAMMAZ
* @date: 10/03/2022
* @ Description Insertion des fichier de la Bande Usine
* @TestClass: 
* @Coverage: 90 %
* History
* <Date of modification>   			<Author>   		 <Description of modification>
*		16/03/2022				Claire VEHRLE			Continuation de la classe
*/
public with sharing class BandeUsineXMLController {
    
    
    @InvocableMethod(label='Get Bande Usine Id' description='Get Bande Usine Id' category='Bande_Usine__c')
    public static void recuperationBandeUsine(List<Id> bandeUsineId) {
        
        Bande_Usine__c bandeUsine = new Bande_Usine__c();
        bandeUsine = [SELECT Id, Name, Referentiel_panel__r.type_de_panel__c, Localisation__c, Type_de_materiel__c, Duree_de_la_garantie__c, Date_de_fin_de_validite_de_la_garantie__c, Date_declaration_OCOM__c  FROM Bande_Usine__c WHERE Id = :bandeUsineId[0] LIMIT 1];
        
        ContentVersion contentVersion = new ContentVersion();
        contentVersion = [SELECT Id, VersionData, Title, FileType, FileExtension FROM ContentVersion WHERE FirstPublishLocationId = :bandeUsineId[0] LIMIT 1];
        System.debug('$$$$$ bastien BU bandeUsine : ' + bandeUsine );
        System.debug('$$$$$ bastien BU contentVersion : ' + contentVersion);
        
        importXmlFile(bandeUsine, contentVersion);
    }
    
    public static void importXmlFile(Bande_Usine__c bandeUsine, ContentVersion contentVersion){
        
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureMMaTPaME = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_PaMe).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureCarteSIM = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_CarteSIM).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureStreamingMeter = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_Streaming_Meter).getRecordTypeId();
        
        List<Product2> produitList = [SELECT Id, ProductCode FROM Product2 WHERE ProductCode != null];
        Map<String, Id> produitIdreferenceProduitMap = new Map<String, Id>();
        
        for(Product2 produit:produitList) {
            produitIdreferenceProduitMap.put(produit.ProductCode, produit.Id);
        } 
        
        //Mikael TMASF-564
        //chargement des valeurs de la picklist de Asset.Localisation__c
        List<Schema.PicklistEntry> locValues = Asset.Localisation__c.getDescribe().getPicklistValues();
        Map<String,String> AssLocLabelToApiMap = new Map<String,String>();
        For(Schema.PicklistEntry sp : locValues){
            //Map to hold Picklist Label as Key and Picklist API as Value
            AssLocLabelToApiMap.put( sp.getLabel(),sp.getValue());
        }
        //
        //
        
        bandeUsine.Name = contentVersion.Title;
        //bandeUsine.Date_declaration_OCOM__c=date.today();
        bandeUsine.Date_de_l_import__c = date.today();
        bandeUsine.Date_de_Validation_Refus__c = bandeUsine.Date_de_l_import__c;
        
        // si pame mediamate => ims / si aip => cordon
        Account IMS = [SELECT id , Name FROM account WHERE Name = 'IMS'];
        Account cordon = [SELECT id , Name FROM account WHERE Name = 'Cordon'];
        
        // get inserted file
        Blob XmlFileBody = contentVersion.VersionData;// convert to blob
        List<Asset> equipementDeMesureToInsert = new List<Asset>();
        List<Asset> carteSimToInsert = new List<Asset>();
        Map<String, Asset> equipementDeMesureCarteSimMap = new Map<String, Asset>();
        
        DOM.Document doc = new DOM.Document();        
        String XmlAsString = XmlFileBody.toString();// convert blob to string 
        doc.load(XmlAsString);
        DOM.XmlNode rootNode=doc.getRootElement();
        
        System.debug('$$$bandeUsine: ' + bandeUsine);
        
        for (Dom.XMLNode child: rootNode.getChildElements()) {
            System.debug('child name'+child.getName());
            Asset equipementDeMesure = new Asset();
            if(bandeUsine.Referentiel_panel__r.type_de_panel__c == Label.RFP_TypePanel_AIP) {
                equipementDeMesure.AccountId = cordon.id;
                equipementDeMesure.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
            }
            else if (bandeUsine.Referentiel_panel__r.type_de_panel__c == Label.RFP_TypePanel_Pame || bandeUsine.Referentiel_panel__r.type_de_panel__c == Label.RFP_TypePanel_MMAT){
                         equipementDeMesure.AccountId = IMS.id;
                         equipementDeMesure.RecordTypeId = recordTypeIdEquipementDeMesureMMaTPaME;
                     }
            else if (bandeUsine.Referentiel_panel__r.type_de_panel__c == Label.RFP_TypePanel_Mesure_Plateforme){
                equipementDeMesure.AccountId = IMS.id;
                equipementDeMesure.RecordTypeId = recordTypeIdEquipementDeMesureStreamingMeter;
            }
            
            equipementDeMesure.Name ='Nom temporaire';
            equipementDeMesure.Bande_Usine__c = bandeUsine.id;
            
            /////Mikael TMASF-564
            equipementDeMesure.Localisation__c = AssLocLabelToApiMap.get(bandeUsine.Localisation__c);
            ///
        
            equipementDeMesure.Type_de_materiel__c = bandeUsine.Type_de_materiel__c;

            System.debug('equipementDeMesure.Type_de_materiel__c');
            System.debug(equipementDeMesure.Type_de_materiel__c);
            /////Mikael TMASF-564
            if ( bandeUsine.Type_de_materiel__c==Label.ASS_TypeMateriel_Setmeter
            || bandeUsine.Type_de_materiel__c==Label.ASS_TypeMateriel_Pager){
                equipementDeMesure.Status=label.ASS_Statut_Valide;
            }

            for(Dom.XMLNode childs: child.getChildElements()){
                
                System.debug('$$$childs name child '+childs.getName());
                System.debug('$$$childs text child '+childs.getText());
                if(childs.getName() == 'Product_Reference'){
                    equipementDeMesure.Reference_produit__c = childs.getText();
                }
                if(childs.getName() == 'Serial_Number'){
                    equipementDeMesure.SerialNumber = childs.getText();
                }
                if(childs.getName() == 'Production_Date'){
                    equipementDeMesure.Date_de_production__c = Date.valueOf(childs.getText());
                }
                if(childs.getName()=='Software_Version'){
                    equipementDeMesure.Version_du_Logiciel__c = childs.getText();
                }
                if(childs.getName()=='Meter_ID'){
                    equipementDeMesure.Audimetre__c = childs.getText();
                }
                if(childs.getName()=='IMEI'){
                    equipementDeMesure.Numero_IMEI__c = decimal.valueOf(childs.getText());
                }
                //Regarder pour le code le carte SIM
                if(childs.getName() == 'SIM'){
                    Asset carteSim = new Asset();
                    carteSim.Name = 'Nom provisoire SIM';
                    carteSim.Bande_Usine__c = bandeUsine.Id;
                    for(Dom.XMLNode sim: childs.getChildElements()){
                        if(sim.getName() == 'Card_Id'){
                            carteSim.Identifiant_SIM__c = sim.getText();
                        }
                        if(sim.getName() == 'IMSI'){
                            carteSim.Sim_IMSI__c = sim.getText();
                        }
                        if(sim.getName() == 'CCID'){
                            carteSim.Sim_CCID__c = sim.getText();
                        }
                    }
                    equipementDeMesureCarteSimMap.put(equipementDeMesure.SerialNumber, carteSim);
                }
            }
            
            
            for(String ProductCode:produitIdreferenceProduitMap.keySet()) {
                System.debug('$$$$$ ProductCode: ' + ProductCode);
                System.debug('$$$$$ produitIdreferenceProduitMap.get(ProductCode): ' + produitIdreferenceProduitMap.get(ProductCode));
            } 
            
            
            System.debug('$$$$$ produitIdreferenceProduitMap.get(equipementDeMesure.Reference_produit__c): ' + produitIdreferenceProduitMap.get(equipementDeMesure.Reference_produit__c));
            System.debug('$$$$$ equipementDeMesure.Reference_produit__c: ' + equipementDeMesure.Reference_produit__c);
            equipementDeMesure.Product2Id = produitIdreferenceProduitMap.get(equipementDeMesure.Reference_produit__c);
            
            equipementDeMesure.Duree_de_la_garantie__c = bandeUsine.Duree_de_la_garantie__c;
            
            if(equipementDeMesure.Date_de_production__c != null && bandeUsine.Date_de_fin_de_validite_de_la_garantie__c==null){
                bandeUsine.Date_de_fin_de_validite_de_la_garantie__c = equipementDeMesure.Date_de_production__c.addMonths(Integer.valueOf(bandeUsine.Duree_de_la_garantie__c));
            }
            
            System.debug('$$$equipementDeMesure: ' + equipementDeMesure);
            
            equipementDeMesureToInsert.add(equipementDeMesure);
        }
        
        List<Database.SaveResult> equipementInsertFail = new List<Database.SaveResult>();
        List<Database.SaveResult> cartSimInsertFail = new List<Database.SaveResult>();
        
        System.debug('$$$equipementDeMesureToInsert : '+equipementDeMesureToInsert);
        System.debug('$$$equipementDeMesureToInsert size : '+equipementDeMesureToInsert.size());
        
        if (equipementDeMesureToInsert.size() > 0 && equipementDeMesureToInsert != null){
            equipementInsertFail = Database.insert(equipementDeMesureToInsert, false);
            System.debug('$$$equipementDeMesureToInsert: ' + equipementDeMesureToInsert);
            
        }
        System.debug('$$$equipementInsertFail: ' + equipementInsertFail);
        Boolean isErrorEquipement = false;
        for (Database.SaveResult eqt : equipementInsertFail) {
            if (eqt.isSuccess()) {
                System.debug('$$$Successfully inserted contact. Contact ID: ' + eqt.getId());
            } else {
                for(Database.Error err : eqt.getErrors()) {
                    isErrorEquipement = true;
                    System.debug('$$$The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('$$$Contact fields that affected this error: ' + err.getFields());
                }
            }
        }
        
        List<Asset> equipementDemesureToAddCarteSim = new List<Asset>();
        
        equipementDemesureToAddCarteSim = [SELECT Id, SerialNumber, AccountId FROM Asset WHERE Bande_Usine__c = :bandeUsine.id];
        
        System.debug('$$$equipementDemesureToAddCarteSim: ' + equipementDemesureToAddCarteSim);
        
        if(equipementDemesureToAddCarteSim.size() != 0) {
            for(Asset equipementDeMesure:equipementDemesureToAddCarteSim) {
                if (equipementDeMesureCarteSimMap.get(equipementDeMesure.SerialNumber) != null) {
                    equipementDeMesureCarteSimMap.get(equipementDeMesure.SerialNumber).ParentId = equipementDeMesure.Id;
                    equipementDeMesureCarteSimMap.get(equipementDeMesure.SerialNumber).AccountId = equipementDeMesure.AccountId;
                    carteSimToInsert.add(equipementDeMesureCarteSimMap.get(equipementDeMesure.SerialNumber));
                }
            }
            
            System.debug('$$$carteSimToInsert: ' + carteSimToInsert);
            
            if (carteSimToInsert.size() > 0 && carteSimToInsert != null){
                cartSimInsertFail = Database.insert(carteSimToInsert, false);
            }
        }
        
        Boolean isErrorCartSim = false;
        for (Database.SaveResult cartSim : cartSimInsertFail) {
            if (cartSim.isSuccess()) {
                System.debug('$$$Successfully inserted cart: ' + cartSim.getId());
            } else {
                for(Database.Error err : cartSim.getErrors()) {
                    isErrorCartSim = true;
                    System.debug('$$$The following error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('$$$Contact fields that affected this error: ' + err.getFields());
                }
            }
        }
        System.debug('$$$isErrorCartSim: ' + isErrorCartSim);
        System.debug('$$$isErrorEquipement: ' + isErrorEquipement);
        System.debug('$$$equipementInsertFail: ' + equipementInsertFail);
        System.debug('$$$cartSimInsertFail: ' + cartSimInsertFail);
        System.debug('$$$bandeUsine: ' + bandeUsine);
        if (isErrorEquipement == true || isErrorCartSim == true) {
            traitementDesErreurs(equipementInsertFail, equipementDeMesureToInsert, cartSimInsertFail, carteSimToInsert);
            bandeUsine.Statut_de_l_import__c=label.BandeUsine_statut_Partiellement_Validee;
            System.debug('$$$bandeUsine: ' + bandeUsine);
        } else {
            bandeUsine.Statut_de_l_import__c=label.BandeUsine_statut_Valide;
            System.debug('$$$bandeUsine: ' + bandeUsine);
        }
        System.debug('$$$bandeUsine: ' + bandeUsine);
        
        update bandeUsine;
        
    }
    
    public static void traitementDesErreurs(Database.SaveResult[] equipementInsertFail, List<Asset> equipementInsert, Database.SaveResult[] cartSimInsertFail, List<Asset> cartSimInsert) {
        
        Integer i = 0;
        Integer j = 0;
        List<Bande_Usine_Erreur__c> bandeUsineErreurList = new List<Bande_Usine_Erreur__c>();
        System.debug('$$$Error$$$');
        System.debug('$$$equipementInsertFail: ' + equipementInsertFail);
        System.debug('$$$equipementInsert: ' + equipementInsert);
        System.debug('$$$cartSimInsertFail: ' + cartSimInsertFail);
        System.debug('$$$cartSimInsert: ' + cartSimInsert);
        
        for(Database.SaveResult result:equipementInsertFail) {
            if(!result.isSuccess()) {
                Bande_Usine_Erreur__c bandeUsineErreur = new Bande_Usine_Erreur__c();
                bandeUsineErreur.Bande_Usine__c = equipementInsert[i].Bande_Usine__c;
                bandeUsineErreur.Numero_de_Serie__c = equipementInsert[i].SerialNumber;
                bandeUsineErreur.Name = equipementInsert[i].SerialNumber;
                System.debug('$$$i: ' + i);
                System.debug('$$$result.getId(): ' + result.getId());
                System.debug('$$$equipementInsert[i]: ' + equipementInsert[i]);
                for(Database.Error error: result.getErrors()) {
                    System.debug('$$$error.getFields(): ' + error.getFields());
                    System.debug('$$$error.getMessage(): ' + error.getMessage());
                    System.debug('$$$error.getStatusCode(): ' + error.getStatusCode());
                    bandeUsineErreur.Message_d_Erreur__c = error.getStatusCode() + ' :' + error.getMessage();
                }
                bandeUsineErreurList.add(bandeUsineErreur);
            }
            i ++;
        }
        
        for(Database.SaveResult result:cartSimInsertFail) {
            if(!result.isSuccess()) {
                Bande_Usine_Erreur__c bandeUsineErreur = new Bande_Usine_Erreur__c();
                bandeUsineErreur.Bande_Usine__c = cartSimInsert[j].Bande_Usine__c;
                bandeUsineErreur.Identifiant_SIM__c = cartSimInsert[j].Identifiant_SIM__c;
                bandeUsineErreur.Name = cartSimInsert[j].Identifiant_SIM__c;
                System.debug('$$$result.getId(): ' + result.getId());
                System.debug('$$$cartSimInsert[j]: ' + cartSimInsert[j]);
                for(Database.Error error: result.getErrors()) {
                    System.debug('$$$error.getFields(): ' + error.getFields());
                    System.debug('$$$error.getMessage(): ' + error.getMessage());
                    System.debug('$$$error.getStatusCode(): ' + error.getStatusCode());
                    bandeUsineErreur.Message_d_Erreur__c = error.getStatusCode() + ' :' + error.getMessage();
                }
                
                bandeUsineErreurList.add(bandeUsineErreur);
            }
            j ++;
        }
        System.debug('$$$error.bandeUsineErreurList: ' + bandeUsineErreurList);
        
        if (bandeUsineErreurList.size() != 0 && !bandeUsineErreurList.isEmpty()) {
            System.debug('$$$error.bandeUsineErreurList.size(): ' + bandeUsineErreurList.size());
            
            insert bandeUsineErreurList;
        }
        
    }
    
    
}