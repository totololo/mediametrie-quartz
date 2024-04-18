/*
* @author: Claire VEHRLE
* @date: 24/04/2023
* @ Description 
* @Coverage: 
* History
* Date of modification :
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class Batch_RDDIdentifiantPaME_Test {
    
    @isTest
    static void testBatchRDDIdPaME() {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.Name = 'PaME';
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        referentielPanelToInsert.add(refPanPaME);

        insert referentielPanelToInsert;
        
        Account foyer = new Account();
        foyer.Name = 'Test AP08';
        insert foyer;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        
        Foyer_Paneliste__c foyerPanelistePAME = new Foyer_Paneliste__c();
        foyerPanelistePAME.Name = 'FP MMAT';
        foyerPanelistePAME.Foyer__c = foyer.Id;
        foyerPanelistePAME.Referentiel_Panel__c = refPanPaME.Id;
        foyerPanelistePAME.RecordTypeId=recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelistePAME.Lettre_operateur__c = 'B';
        foyerPanelistePAME.numero_foyer__c = 1234;
        foyerPanelisteToInsert.add(foyerPanelistePAME);  
        
        insert foyerPanelisteToInsert; 
        
        Test.startTest();
        Batch_RDDIdentifiantPaME bccfb = new Batch_RDDIdentifiantPaME();
        Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<Foyer_Paneliste__c> foyerPanelisteToCheck = new List<Foyer_Paneliste__c>();
        foyerPanelisteToCheck = [SELECT Id, Identifiant_foyer_PaME__c FROM Foyer_Paneliste__c];
        System.debug('$$$foyerPanelisteToCheck[0].Identifiant_foyer_PaME__c: ' + foyerPanelisteToCheck[0].Identifiant_foyer_PaME__c);
        System.assertEquals(41234, foyerPanelisteToCheck[0].Identifiant_foyer_PaME__c);
    }
    
}