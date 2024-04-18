/*
* @date: 08/09/2021
* @ Description Class qui teste Batch010_RequeteProcessusRestitution45j 
* @version 1.00   
* pourcentage : 95%
* @Auteur Ayoub Ghammaz EIT
*/
@isTest
public class Batch010_RequeteProcessusRestit_test {
    @isTest static void testDAteInf21(){
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        /*------------------------------- creation de 3 equipements desafectes moins de 45 jours , sa lication est au foyer et 3 equipements desafectes plus de 45 jours , sa lication est au foyer
		--------------------------------- ==> creation d'une requte Restitution Du Materiel et attacher les 3 equipements*/
        //creer foyer
        Account foyer1 = new Account(name='FoyerTest1');
        insert(foyer1);
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste1 = new Foyer_paneliste__c(name='PanelisteTest1',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel);
        insert(paneliste1);
        // creer requete de type 
        Case req = new Case(RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId(),
        Origin = Label.CAS_Origine_NouveauFoyer,
        AccountId=foyer1.id,
        Foyer_paneliste__c = paneliste1.id ,
        Type = Label.CAS_Type_Reclamation_Materiel,
        Sous_type__c = Label.CAS_Sous_type_Probleme_Equipement);
        insert(req );
        //creer equipements
        List<Asset> assetToInsert = new list<Asset>();
     
        asset equi1=new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi1',requete__c=req.id,Foyer_paneliste__c=paneliste1.id,audimetre__c='jikvv',AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45))+4,status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi1);
        
        asset equi2=new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi2',requete__c=req.id,audimetre__c='jizzfeékvv',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45))+4,status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi2);
        
        asset equi3=new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi3',requete__c=req.id,audimetre__c='jikvzefv',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45))+4,status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi3);
        
        
        asset equi5 = new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi5',requete__c=req.id,audimetre__c='jikvvee',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45)-1),status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi5);
        
        asset equi6 = new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi6',requete__c=req.id,audimetre__c='jikéf"rgeeevv',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45)-1),status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi6);
        
        asset equi7 = new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test1 equi7',requete__c=req.id,audimetre__c='jikvvffff',Foyer_paneliste__c=paneliste1.id,AccountId=foyer1.id,Date_de_desaffectation__c=date.today().addDAys(-integer.valueOf(Label.Batch010_DateDesaffectation45)-1),status=Label.ASS_Statut_Desaffecte,localisation__c=Label.ASS_Localisation_Foyer);
        assetToInsert.add(equi7);
        
        insert assetToInsert;
        Test.startTest();
        Batch010_RequeteProcessusRestitution45j bccfb = new Batch010_RequeteProcessusRestitution45j();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(1, [select id ,Sous_type__c,Status from case where Sous_type__c=:Label.CAS_SousType_RestitutionDuMateriel and type=:Label.CAS_Type_VieDuFoyer].size());
        //System.assertEquals(3, [select id ,Sous_type__c,Status,(select id from quipements__r) from case where Sous_type__c=:Label.CAS_SousType_RestitutionDuMateriel and type=:Label.CAS_Type_VieDuFoyer].quipements__r.size());
    }        

}