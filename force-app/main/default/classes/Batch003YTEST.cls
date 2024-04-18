/*
* @author: Joyce Saidy
* @date: 21/09/2020
* @ Description Class that test Batch003_CreationRequeteControle  
* History
* <Date of modification>   <Author>    <Description of modification>
* 		06/10/2021   			Claire VEHRLE  		   Création des requêtes pour les contrôle de type Contrôle AIP
*/
@isTest
public class Batch003YTEST {
    public static testMethod void Batch003_CreationRequeteControleTest(){
       
        Id recordTypeIdControleControleAIP =Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdControleControleMediamat_PaME =Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleMediamat_PaME).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdAsseteAIP =Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
                
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount); 
        account testAccount2 = Test_Utils.createFoyer();
        testAccount2.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount2); 
        insert listFoyersToInsert;
        System.debug('acc1: ' + testAccount);
        System.debug('acc2: ' + testAccount2);
        
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = testAccount.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        
        Foyer_Paneliste__c foyerPanelisteAIP = new Foyer_Paneliste__c();
        foyerPanelisteAIP.recordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPanelisteAIP.Name = 'FP AIP';
        foyerPanelisteAIP.Foyer__c = testAccount2.Id;
        foyerPanelisteAIP.Foyer_equipe__c = true;
        foyerPanelisteAIP.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel_Chute_temporaire;
        foyerPanelisteAIP.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteToInsert.add(foyerPanelisteAIP);
        
        insert foyerPanelisteToInsert;
        
       //Create Case
       
        Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
       
        list<Case> listCaseToInsert = new list<Case>();
        Case testCase = Test_Utils.createCase(testAccount2.id);
        testCase.foyer_paneliste__c = foyerPanelisteAIP.Id;
        testCase.Status = Label.CAS_Statut_Nouveau;
        testCase.RecordtypeId = recordTypeIdRequeteControleAIP;
        testCase.Type =Label.CAS_Type_Non_repondant;
        listCaseToInsert.add(testCase); 
        insert listCaseToInsert;
        
        //Mikael
        //Create asset
        list<asset> listassetToInsert = new list<asset>();
        
        
        Asset ass1=Test_Utils.createEquipement(testAccount.id);
        ass1.Type_de_materiel__c=Label.ASS_TypeMateriel_Pager;
        ass1.Audimetre__c='lnlnklne';
        ass1.recordTypeId = recordTypeIdAsseteAIP;
        listassetToInsert.add(ass1);
        
        Asset ass2=Test_Utils.createEquipement(testAccount.id);
        ass2.Type_de_materiel__c=Label.ASS_TypeMateriel_Pager;
        ass2.Audimetre__c='lnlnAZFTNYklne';
        ass2.recordTypeId = recordTypeIdAsseteAIP;
        listassetToInsert.add(ass2);
        
        Asset ass3=Test_Utils.createEquipement(testAccount2.id);
        ass3.Type_de_materiel__c=Label.ASS_TypeMateriel_Pager;
        ass3.Audimetre__c='lnSDZlnklne';
        ass3.recordTypeId = recordTypeIdAsseteAIP;
        listassetToInsert.add(ass3);
        
        Asset ass4=Test_Utils.createEquipement(testAccount2.id);
        ass4.Type_de_materiel__c=Label.ASS_TypeMateriel_Pager;
        ass4.Audimetre__c='lFEnlnklne';
        ass4.recordTypeId = recordTypeIdAsseteAIP;
        listassetToInsert.add(ass4);
        
        Asset ass5=Test_Utils.createEquipement(testAccount2.id);
        ass5.Type_de_materiel__c=Label.ASS_TypeMateriel_Pager;
        ass5.Audimetre__c='lFEnlnklne12';
        ass5.recordTypeId = recordTypeIdAsseteAIP;
        listassetToInsert.add(ass5);

        insert listassetToInsert; 
        //Create Controle
        list<Controle__c> listControleToInsert = new list<Controle__c>();
        Controle__c testCtrl1 = Test_Utils.createControle(testAccount.id,null,null,null,System.today());
        testCtrl1.RecordTypeId = recordTypeIdControleControleMediamat_PaME;
        testCtrl1.Date_de_controle__c=system.now();
        testCtrl1.Statut__c=Label.CTRL_StatutActif;
        testCtrl1.Tech_Priority__c='1';
        testCtrl1.Type_de_controle__c=Label.CTRL_Type_NonRepondant;
        testCtrl1.Date_de_controle__c=system.now();
        testCtrl1.foyer_paneliste__c=foyerPanelisteMMAT.Id;
        testCtrl1.Audimetre__c=ass1.Id;
        listControleToInsert.add(testCtrl1);  
         
        Controle__c testCtrl2 = Test_Utils.createControle(testAccount.id,null,null,null,System.today());
        testCtrl2.RecordTypeId = recordTypeIdControleControleMediamat_PaME;
        testCtrl2.Date_de_controle__c=system.now();
        testCtrl2.Statut__c=Label.CTRL_StatutActif;
        testCtrl2.Tech_Priority__c='2';
        testCtrl2.Type_de_controle__c=Label.CTRL_Type_NonRepondant; 
        testCtrl2.Date_de_controle__c=system.now();
        testCtrl2.foyer_paneliste__c=foyerPanelisteMMAT.Id;
        testCtrl2.Audimetre__c=ass2.Id;
        listControleToInsert.add(testCtrl2);
        
        Controle__c testCtrl4 = Test_Utils.createControle(testAccount2.id,null,null,null,System.today());
        testCtrl4.RecordTypeId = recordTypeIdControleControleAIP;
        testCtrl4.Date_de_controle__c=system.now();
        testCtrl4.Statut__c=Label.CTRL_StatutActif;
        testCtrl4.Tech_Priority__c='4';
        testCtrl4.Type_de_controle__c=Label.CTRL_Type_NonRepondant; 
        testCtrl4.Date_de_controle__c=system.now();
        testCtrl4.foyer_paneliste__c=foyerPanelisteAIP.Id;
        testCtrl4.Audimetre__c=ass4.Id;
        listControleToInsert.add(testCtrl4);
        
        Controle__c testCtrl3 = Test_Utils.createControle(testAccount2.id,null,null,null,System.today());
        testCtrl3.RecordTypeId = recordTypeIdControleControleAIP;
        testCtrl3.Date_de_controle__c=system.now();
        testCtrl3.Statut__c=Label.CTRL_StatutActif;
        testCtrl3.Tech_Priority__c='3';
        testCtrl3.Type_de_controle__c=Label.CTRL_Type_NonRepondant; 
        testCtrl3.Date_de_controle__c=system.now();
        testCtrl3.foyer_paneliste__c=foyerPanelisteAIP.Id;
        testCtrl3.Audimetre__c=ass3.Id;
        listControleToInsert.add(testCtrl3);
        
        Controle__c testCtrl5 = Test_Utils.createControle(testAccount2.id,null,null,null,System.today());
        testCtrl5.RecordTypeId = recordTypeIdControleControleAIP;
        testCtrl5.Date_de_controle__c=system.now();
        testCtrl5.Statut__c=Label.CTRL_Statut_Precode;
        testCtrl5.Libelle_de_pre_codage__c=Label.CTRL_LibellePrecodage_JourFerie;
        testCtrl5.Tech_Priority__c='6';
        testCtrl5.Type_de_controle__c=Label.CTRL_Type_NonRepondant; 
        testCtrl5.Date_de_controle__c=system.now();
        testCtrl5.foyer_paneliste__c=foyerPanelisteAIP.Id;
        testCtrl5.Audimetre__c=ass5.Id;
        listControleToInsert.add(testCtrl5);
        
        
        insert listControleToInsert; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Batch003Y btch = new Batch003Y();
        database.executeBatch(btch);
        Test.stopTest();
        
        
        List<Case> createCase = [SELECT id, AccountId, RecordType.Name, Nombre_de_controles__c, foyer_paneliste__c FROM Case];
        System.debug('createCase: ' + createCase);
       // System.assertEquals(2, createCase.size());
    } 
}