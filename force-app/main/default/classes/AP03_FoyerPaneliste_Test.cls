/*
* @date: 06/09/2021
* @ Description : tester la classe AP03_FoyerPaneliste
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @Coverage: 93%
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP03_FoyerPaneliste_Test {
    
    @isTest static void TestStatusPane2(){
        Id recordTypeIdAssetAip =Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest12');
        insert foyer1;
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest12',RecordTypeId=recordTypeIdPanelAIP,
                                                               Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel);
        insert(paneliste1);
        //creer equipements
        List<Asset> assetToInsert = new list<Asset>();
        asset equi1 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test12 equi 1',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,audimetre__c='lkhkoli');
        assetToInsert.add(equi1);
        asset equi2 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test12 equi 2',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,audimetre__c='lkhkoliaze');
        assetToInsert.add(equi2);
        asset equi3 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test12 equi 3',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,audimetre__c='lkhkoliaé&s');
        assetToInsert.add(equi3);
        insert assetToInsert;
        Asset ass = [select id , status from asset Limit 1];
        ass.status=Label.ASS_Statut_Installe;
        update ass;
        System.assertNotEquals([select id ,Statut_Foyer_paneliste__c from Foyer_paneliste__c where id=:paneliste1.id].Statut_Foyer_paneliste__c, Label.PAN_Statut_Panel_Installe);
        
    }
    @isTest static void TestStatusPane1(){
        Id recordTypeIdAssetAip =Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest1');
        insert(foyer1);
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest1',RecordTypeId=recordTypeIdPanelAIP,
                                                               Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel);
        insert(paneliste1);
        //creer equipements
        List<Asset> assetToInsert = new list<Asset>();
        asset equi1 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test1 equi1',Foyer_paneliste__c=paneliste1.id,audimetre__c='lkhkoli',AccountId=foyer1.id,Date_de_premiere_detection__c=date.today());
        assetToInsert.add(equi1);
        asset equi2 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test1 equi2',Foyer_paneliste__c=paneliste1.id,audimetre__c='lkhaakoli',AccountId=foyer1.id,Date_de_premiere_detection__c=date.today());
        assetToInsert.add(equi2);
        asset equi3 = new asset(recordtypeid=recordTypeIdAssetAip,Name='test1 equi3',Foyer_paneliste__c=paneliste1.id,audimetre__c='lkuugghkoli',AccountId=foyer1.id,Date_de_premiere_detection__c=date.today());
        assetToInsert.add(equi3);
        insert assetToInsert;
        list<Asset> equiToUpdate= new List<Asset>();
        for(Asset ass : [select id , status from asset]){
            ass.status=Label.ASS_Statut_Installe;
            equiToUpdate.add(ass);
        }
        
        if(equiToUpdate!=null && equiToUpdate.size()>0){
            update equiToUpdate;
        }
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id));        
        System.assertEquals([select id ,Statut_Foyer_paneliste__c from Foyer_paneliste__c].Statut_Foyer_paneliste__c, Label.PAN_Statut_Panel_Installe);
        System.assertNotEquals([select id ,Date_d_installation__c from Foyer_paneliste__c].Date_d_installation__c, null);
        Test.stopTest();
        
    }
    
    
}