/*
* @author: Claire VEHRLE
* @date: 20/01/2023
* @ Description: Classe qui test AP01_BandeUsine les méthodes : getBandeUsine // sendBandeUsineToOCOM // createHttpRequest
* @TestClass: 
* @Coverage:
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
@isTest
public class AP02_BandeUsine_Test {
    
    @isTest
    static void buProvisionner() {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        insert referentielPanelToInsert;
        
        Account foyer = new Account();
        foyer.Name = 'Test BU provisionner';
        insert foyer;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = foyer.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        
        insert foyerPanelisteToInsert;
        
        Bande_Usine__c BU = new Bande_Usine__c();
        BU.Name = 'bandeUTest';
        BU.Date_declaration_OCOM__c = date.today();
        BU.Statut_de_l_import__c = Label.BandeUsine_statut_Valide;
        BU.Referentiel_Panel__c = refPanMMAT.Id;
        
        insert BU;
        
        Asset eqt = new Asset();
        Eqt.AccountId = foyer.Id;
        eqt.Foyer_paneliste__c = foyerPanelisteMMAT.Id;
        eqt.Bande_Usine__c = BU.Id;
        eqt.Name='1432';
        //
        insert eqt;
        
        IndividuPanelisteCallout_Mock fakeGetBandeUsine = new IndividuPanelisteCallout_Mock(BU.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetBandeUsine);
        BU.Statut_de_l_import__c = Label.BandeUsine_statut_Rejete;
        
        Update BU;
        Test.stopTest();
    }
    
    @isTest
    static void buNonProvisionner() {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        insert referentielPanelToInsert;
        
        Account foyer = new Account();
        foyer.Name = 'Test BU provisionner';
        insert foyer;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = foyer.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        
        insert foyerPanelisteToInsert;
        
        Bande_Usine__c BU = new Bande_Usine__c();
        BU.Name = 'bandeUTest';
        BU.Date_declaration_OCOM__c = null;
        BU.Statut_de_l_import__c = Label.BandeUsine_statut_Valide;
        BU.Referentiel_Panel__c = refPanMMAT.Id;
        
        insert BU;
        
        Asset eqt = new Asset();
        Eqt.AccountId = foyer.Id;
        eqt.Foyer_paneliste__c = foyerPanelisteMMAT.Id;
        eqt.Bande_Usine__c = BU.Id;
        eqt.Name='123';
        //
        insert eqt;
        
        IndividuPanelisteCallout_Mock fakeGetBandeUsine = new IndividuPanelisteCallout_Mock(BU.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetBandeUsine); 
        BU.Statut_de_l_import__c = Label.BandeUsine_statut_Rejete;
        
        Update BU;
        Test.stopTest();
    }
    
}