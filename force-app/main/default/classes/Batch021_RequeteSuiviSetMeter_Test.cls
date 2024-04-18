/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 25/02/2022
* @Classe:  Batch021_RequeteSuiviSetMeter
* @Coverage: 93%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class Batch021_RequeteSuiviSetMeter_Test {
    @isTest
    public static void testCreationRequete(){
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdControleControleAIP = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
         //creer des foyers
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        Foyer_paneliste__c foyerPaneliste1 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPaneliste1.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteList.add(foyerPaneliste1);
        
        Foyer_paneliste__c foyerPaneliste2 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste2.Foyer__c = foyer2.Id;
        foyerPaneliste2.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPanelisteList;
        
        List<Asset> equipementMesureList = new List<Asset>();
        Asset asset1 = Test_Utils.createEquipement(foyer1.Id);
        asset1.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset1.Foyer_paneliste__c = foyerPaneliste1.Id;
        asset1.Audimetre__c='lkjoioi';
        asset1.Type_de_materiel__c = Label.ASS_TypeMateriel_Setmeter;
        equipementMesureList.add(asset1);
        
        Asset asset2 = Test_Utils.createEquipement(foyer1.Id);
        asset2.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset2.Foyer_paneliste__c = foyerPaneliste1.Id;
        asset2.Audimetre__c='lkjazdoioi';
        asset2.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        equipementMesureList.add(asset2);
        
        Asset asset3 = Test_Utils.createEquipement(foyer2.Id);
        asset3.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset3.Foyer_paneliste__c = foyerPaneliste2.Id;
        asset3.Audimetre__c='lkjazdoioi234567';
        asset3.Type_de_materiel__c = Label.ASS_TypeMateriel_Setmeter;
        equipementMesureList.add(asset3);
        
        insert equipementMesureList;
        
          //conroles
        list<Controle__c> listControles = new list<Controle__c>();
        Controle__c ctr1 = new Controle__c();
        ctr1.RecordTypeId = recordTypeIdControleControleAIP;
        ctr1.Foyer__c = foyer1.id;
        ctr1.Foyer_paneliste__c = foyerPaneliste1.id;
        ctr1.Audimetre__c=asset1.id;
        ctr1.Date_de_controle__c = date.today();
        ctr1.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        listControles.add(ctr1);
        
        Controle__c ctr1Prime = new Controle__c();
        ctr1Prime.RecordTypeId = recordTypeIdControleControleAIP;
        ctr1Prime.Foyer__c = foyer1.id;
        ctr1Prime.Foyer_paneliste__c = foyerPaneliste1.id;
        ctr1Prime.Audimetre__c=asset1.id;
        ctr1Prime.Date_de_controle__c = date.today();
        ctr1Prime.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        listControles.add(ctr1Prime);
        
        Controle__c ctr2 = new Controle__c();
        ctr2.RecordTypeId = recordTypeIdControleControleAIP;
        ctr2.Foyer__c = foyer1.id;
        ctr2.Foyer_paneliste__c = foyerPaneliste1.id;
        ctr2.Audimetre__c=asset2.id;
        ctr2.Date_de_controle__c = date.today();
        ctr2.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        listControles.add(ctr2);  
        
        Controle__c ctr3 = new Controle__c();
        ctr3.RecordTypeId = recordTypeIdControleControleAIP;
        ctr3.Foyer__c = foyer2.id;
        ctr3.Foyer_paneliste__c = foyerPaneliste2.id;
        ctr3.Audimetre__c=asset3.id;
        ctr3.Date_de_controle__c = date.today();
        ctr3.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        listControles.add(ctr3);
        
        Controle__c ctr4 = new Controle__c();
        ctr4.RecordTypeId = recordTypeIdControleControleAIP;        
        ctr4.Foyer__c = foyer2.id;
        ctr4.Foyer_paneliste__c = foyerPaneliste2.id;
        ctr4.Audimetre__c=asset3.id;
        ctr4.Date_de_controle__c = date.today();
        ctr4.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        listControles.add(ctr4);
        
        Controle__c ctr5 = new Controle__c();
        ctr5.RecordTypeId = recordTypeIdControleControleAIP;        
        ctr5.Foyer__c = foyer1.id;
        ctr5.Foyer_paneliste__c = foyerPaneliste1.id;
        ctr5.Audimetre__c=asset3.id;
        ctr5.Date_de_controle__c = date.today();
        ctr5.Type_de_controle__c = Label.CTRL_Type_NonRepondant  ; 
        ctr5.Statut__c=Label.CTRL_Statut_Precode;
        ctr5.Libelle_de_pre_codage__c=Label.CTRL_LibellePrecodage_JourFerie;
        listControles.add(ctr5);
        
        insert listControles;
        
        Case testCase = Test_Utils.createCase(foyer2.id);
        testCase.foyer_paneliste__c = foyerPaneliste2.Id;
        testCase.Status=Label.CAS_Statut_Nouveau;
        testCase.Type=Label.CAS_Type_NonRepondantSetMeter;
        insert testCase;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer2.id));
        Batch021_RequeteSuiviSetMeter bccfb = new Batch021_RequeteSuiviSetMeter();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<Case> testcases = [SELECT id FROM case];
         //System.assertEquals(2, testcases.size());
    }

}