/*
* @author: Claire VEHRLE
* @date: 21/03/2022
* @ Description Class that test BandeUsineXMLController  
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class BandeUsineXMLController_Test {
    
    public static String xmlCreation() {
        DOM.document doc = new DOM.Document();
        
        dom.XmlNode BU =doc.createRootElement('Delivery', null, null);
        
        dom.XmlNode equipement = BU.addChildElement('Meter', null, null);
        dom.XmlNode productReference = equipement.addChildElement('Product_Reference', null, null);
        productReference.addTextNode('ROA01V2');
        dom.XmlNode Serial_Number = equipement.addChildElement('Serial_Number', null, null);
        Serial_Number.addTextNode('352736070140382');
        dom.XmlNode Production_Date = equipement.addChildElement('Production_Date', null, null);
        Production_Date.addTextNode('2017-12-19');
        dom.XmlNode Software_Version = equipement.addChildElement('Software_Version', null, null);
        Software_Version.addTextNode('15.1.100');
        dom.XmlNode Meter_ID = equipement.addChildElement('Meter_ID', null, null);
        Meter_ID.addTextNode('242E4C96');
        dom.XmlNode IMEI = equipement.addChildElement('IMEI', null, null);
        IMEI.addTextNode('352736070140382');
        dom.XmlNode carte_SIM = equipement.addChildElement('SIM', null, null);
        dom.XmlNode Card_Id = carte_SIM.addChildElement('Card_Id', null, null);
        Card_Id.addTextNode('8931087415102538794');
        dom.XmlNode IMSI = carte_SIM.addChildElement('IMSI', null, null);
        IMSI.addTextNode('204080807028029');
        dom.XmlNode CCID = carte_SIM.addChildElement('CCID', null, null);
        CCID.addTextNode('8931087415102538794');
        
        return (doc.toXmlString());
    }
    
       public static String xmlCreationError() {
        DOM.document doc = new DOM.Document();
        
        dom.XmlNode BU =doc.createRootElement('Delivery', null, null);
        
        dom.XmlNode equipement = BU.addChildElement('Meter', null, null);
        dom.XmlNode productReference = equipement.addChildElement('Product_Reference', null, null);
        productReference.addTextNode('ROA01V2');
        dom.XmlNode Serial_Number = equipement.addChildElement('Serial_Number', null, null);
        Serial_Number.addTextNode('352736070140382');
        dom.XmlNode Production_Date = equipement.addChildElement('Production_Date', null, null);
        Production_Date.addTextNode('2017-12-19');
        dom.XmlNode Software_Version = equipement.addChildElement('Software_Version', null, null);
        Software_Version.addTextNode('15.1.100');
        dom.XmlNode Meter_ID = equipement.addChildElement('Meter_ID', null, null);
        Meter_ID.addTextNode('242E4C96');
        dom.XmlNode IMEI = equipement.addChildElement('IMEI', null, null);
        IMEI.addTextNode('352736070140382');
        dom.XmlNode carte_SIM = equipement.addChildElement('SIM', null, null);
        dom.XmlNode Card_Id = carte_SIM.addChildElement('Card_Id', null, null);
        Card_Id.addTextNode('8931087415102538794');
        dom.XmlNode IMSI = carte_SIM.addChildElement('IMSI', null, null);
        IMSI.addTextNode('204080807028029');
        dom.XmlNode CCID = carte_SIM.addChildElement('CCID', null, null);
        CCID.addTextNode('8931087415102538794');
        
        return (doc.toXmlString());
    }
    
    public static testMethod void bandeUsine_Test() {
        
        List<Account> foyerList = new List<Account>();
        Account ims = new Account();
        ims.name = 'ims';
        foyerList.add(ims);
        
        Account cordon = new Account();
        cordon.name = 'cordon';
        foyerList.add(cordon);
        
        insert foyerList;
        
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.name = Label.RFP_Nom_MMAT;
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        insert refPanMMAT;
        
        Bande_Usine__c bandeUsine = new Bande_Usine__c();
        bandeUsine.Name = 'Fichier_XML';
        bandeUsine.Referentiel_panel__c = refPanMMAT.Id;
        bandeUsine.Localisation__c = 'Foyer';
        bandeUsine.Type_de_materiel__c = '24';
        bandeUsine.Duree_de_la_garantie__c = 3;

        insert bandeUsine;
        
        List<Id> bandeUsineIdList = new List<Id>();
        bandeUsineIdList.add(bandeUsine.Id);
        
        String xmlTest = xmlCreation();
        
        System.debug(xmlTest);
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test_XML';
        cv.PathOnClient = 'TestXML.xml';
        cv.VersionData = Blob.valueOf(xmlTest);
        cv.IsMajorVersion = true;
        cv.FirstPublishLocationId = bandeUsine.Id;
        Insert cv;
        
        Test.startTest();
		BandeUsineXMLController.recuperationBandeUsine(bandeUsineIdList);
  Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ims.id));

        List<Asset> equipementList = [SELECT Name, recordType.Name, Localisation__c, Type_de_materiel__c FROM Asset];
        //System.assertEquals(2, equipementList.size());
        Test.stopTest();
    }
    
        public static testMethod void bandeUsineErreur_Test() {
        
        List<Account> foyerList = new List<Account>();
        Account ims = new Account();
        ims.name = 'ims';
        foyerList.add(ims);
        
        Account cordon = new Account();
        cordon.name = 'cordon';
        foyerList.add(cordon);
        
        insert foyerList;
        
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.name = Label.RFP_Nom_MMAT;
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        insert refPanMMAT;
        
        Bande_Usine__c bandeUsine = new Bande_Usine__c();
        bandeUsine.Name = 'Fichier_XML';
        bandeUsine.Referentiel_panel__c = refPanMMAT.Id;
        bandeUsine.Localisation__c = 'Foyer';
        bandeUsine.Type_de_materiel__c = '24';
        bandeUsine.Duree_de_la_garantie__c = 3;

        insert bandeUsine;
            
        Asset newAsset = new Asset(AccountId=ims.id, Numero_IMEI__c =decimal.valueOf('352736070140382'), name = 'Test');
        insert newAsset;
            
        List<Id> bandeUsineIdList = new List<Id>();
        bandeUsineIdList.add(bandeUsine.Id);
        
        String xmlTest = xmlCreationError();
        
        System.debug(xmlTest);
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test_XML';
        cv.PathOnClient = 'TestXML.xml';
        cv.VersionData = Blob.valueOf(xmlTest);
        cv.IsMajorVersion = true;
        cv.FirstPublishLocationId = bandeUsine.Id;
        Insert cv;
        
        Test.startTest();
		BandeUsineXMLController.recuperationBandeUsine(bandeUsineIdList);
        List<Bande_Usine_Erreur__c> erreurList = [SELECT Name FROM Bande_Usine_Erreur__c];
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cordon.id));
       Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(newAsset.id));
        //System.assertEquals(1, erreurList.size());
        Test.stopTest();
    }
}