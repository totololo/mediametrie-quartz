/*
* @date: 20/09/2021
* @ Description Class qui teste Batch009_ClotureRequeteAutomatique. avant de lancer le test , modifier la variable Jour_de_traitement__c par J45__c a la ligne 62 du Batch009_ClotureRequeteAutomatique
* @version 1.00   
* pourcentage : 97%
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> 		<Author> 			<Description of modification>
* 06/09/2021 				Ayoub Ghammaz 			Cloture de la requete deType d’enregistrement = contrôle AIP
* 29/10/2021 				Claire VEHRLE 			Cloture des controles des requêtes non clôturées en fin de journée
* 12/01/2023				Marliatou D.			Clôturer la requête Welcome Call après la première collecte d'audience du dernier équipement
*/
@isTest
public class Batch009_ClotureRequeteAutomatique_Test {
        
    @isTest static void testDAteSup21(){
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
        Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        //------------------------------- test  cloturer la requete :tt  date debut detection > 21 jours
        //creer foyer
        Account foyer2 = new Account(name='FoyerTest2');
        insert(foyer2);
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste2 = new Foyer_paneliste__c(name='PanelisteTest2',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer2.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe);
        insert(paneliste2);
        //insert case welcome call
        Case reqWelcome= new case(RecordTypeId = recordTypeIdRequeteControleAIP,
                                  Origin = Label.CAS_Origine_NouveauFoyer,
                                  AccountId=foyer2.id,
                                  Foyer_paneliste__c = paneliste2.id,
                                  Type = Label.CAS_Type_Recrute,
                                  Sous_type__c = Label.CAS_Sous_type_PackInitial);
        insert reqWelcome;
        //creer equipements
        List<Asset> assetToInsert = new list<Asset>();
        For(Integer index=0 ;index<3;index++){//Date.newInstance(2021, 7, 17)
            assetToInsert.add(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                        Name='test2 equi'+index,audimetre__c='adaa'+index,Foyer_paneliste__c=paneliste2.id,AccountId=foyer2.id,Date_de_premiere_detection__c=Date.newInstance(2021, 7, 17)));
        }
        insert assetToInsert;

        
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 

        // Test.startTest();
        Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
       // System.assertEquals(Label.CAS_Statut_Cloture, [select id ,Sous_type__c,Status from case where Sous_type__c=:Label.CAS_Sous_type_PackInitial].status);
    }
  } 
    
    @isTest static void testUneDAteInf21(){
        
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
            Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
            
            //------------------------------- test  ne pas cloturer la requete :une  date debut detection < 21 jours
            //creer foyer
            Account foyer3 = new Account(name='FoyerTest3');
            insert(foyer3);
            //creer foyer paneliste aip
            Foyer_paneliste__c paneliste3 = new Foyer_paneliste__c(name='PanelisteTest3',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer3.id,Statut_Audimetrique__c = Label.PAN_Statut_Audimetrique_nonRepondant);
            insert(paneliste3);
            //insert case welcome call
            Case reqWelcome= new case(RecordTypeId = recordTypeIdControleAIP,
                                      Origin = Label.CAS_Origine_NouveauFoyer,
                                      AccountId=foyer3.id,
                                      Foyer_paneliste__c = paneliste3.id,
                                      Type = Label.CAS_Type_Recrute,
                                      Sous_type__c = Label.CAS_Sous_type_PackInitial
                                     );
            insert reqWelcome;
            
            //creer equipements
            For(Integer index=0 ;index<3;index++){
                insert(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                 Name='test3 equi'+index,audimetre__c='iuyhhg'+index,Foyer_paneliste__c=paneliste3.id,AccountId=foyer3.id,Date_de_premiere_detection__c=Date.newInstance(2021, 7, 17)));
            }
            insert(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                             Name='test2 equi223',Foyer_paneliste__c=paneliste3.id,AccountId=foyer3.id,Date_de_premiere_detection__c=date.today()));
            System.debug('bastien reqWelcome : '+ reqWelcome.CreatedDate);
            System.debug('bastien reqWelcome.id : '+ reqWelcome.id);
            
            
            Test.setCreatedDate(reqWelcome.id, Date.Today() - 45);
            
            List<Case> testCase  = [SELECT Id, CreatedDate, Jour_de_traitement__c FROM Case WHERE Id =:reqWelcome.Id];
            System.debug('bastien testCase : '+ testCase);
            
            
            String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
            List <String> listOrderId = new List <String>();
            listOrderId.add(orderId);
            
            IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
            //Test.startTest();
            
            Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
            Id batchId = Database.executeBatch(bccfb);
            Test.stopTest();
            // after the testing stops, assert records were updated properly
            //System.assertEquals(Label.CAS_Statut_Cloture, [select id ,Sous_type__c,Status from case where Sous_type__c=:Label.CAS_Sous_type_PackInitial].status);
        }
    } 
    @isTest static void testCaseRemplacementMateriel(){
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
            
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            
            /*------------------------------- test   cloturer la requete de type remplacement materiel :une  date debut detection >= 7 jours*/
            //creer foyer
            Account foyer3 = new Account(name='FoyerTest3');
            insert(foyer3);
            //creer foyer paneliste aip
            Foyer_paneliste__c paneliste3 = new Foyer_paneliste__c(name='PanelisteTest3',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer3.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel);
            insert(paneliste3);
            case req=new case(RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId(),
                              Origin = Label.CAS_Origine_NouveauFoyer,
                              AccountId=foyer3.id,
                              Foyer_paneliste__c = paneliste3.id ,
                              Type = Label.CAS_Type_RemplacementMateriel);
            insert req;
            //creer equipement
            insert(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                             Name='test3 equi',Foyer_paneliste__c=paneliste3.id,AccountId=foyer3.id,requete__c=req.id,Date_de_premiere_detection__c=Date.newInstance(2022, 7, 17)));
            
            
            
            Test.startTest();
            Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
            Id batchId = Database.executeBatch(bccfb);
            Test.stopTest();        
            
        }
    }  
    @isTest static void testCaseRemplacementMaterielInf(){
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            
            /*------------------------------- test   ne pas cloturer la requete de type remplacement materiel :une  date debut detection < 7 jours*/
            //creer foyer
            Account foyer3 = new Account(name='FoyerTest3');
            insert(foyer3);
            //creer foyer paneliste aip
            Foyer_paneliste__c paneliste3 = new Foyer_paneliste__c(name='PanelisteTest3',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer3.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_panel);
            insert(paneliste3);
            case req=new case(RecordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId(),
                              Origin = Label.CAS_Origine_NouveauFoyer,
                              AccountId=foyer3.id,
                              Foyer_paneliste__c = paneliste3.id ,
                              Type = Label.CAS_Type_RemplacementMateriel);
            insert req;
            //creer equipement
            insert(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                             Name='test3 equi',Foyer_paneliste__c=paneliste3.id,AccountId=foyer3.id,requete__c=req.id,Date_de_premiere_detection__c=Date.today().addDAys(-2)));
            
            
            
            Test.startTest();
            Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
            Id batchId = Database.executeBatch(bccfb);
            Test.stopTest();
            System.assertNotEquals(Label.CAS_Statut_Cloture, [select id ,Sous_type__c,Status from case where type=:Label.CAS_Type_RemplacementMateriel].status);
            
        }
    }  
    @isTest static void testCollecteAudience(){
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
            Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            //------------------------------- test  cloturer la requete :tt  date debut detection > 21 jours
            //creer foyer
            Account foyer2 = new Account(name='FoyerTest2');
            insert(foyer2);
            //creer foyer paneliste aip
            Foyer_paneliste__c paneliste2 = new Foyer_paneliste__c(name='PanelisteTest2',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer2.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe);
            insert(paneliste2);
            //insert case welcome call
            Case reqWelcome= new case(RecordTypeId = recordTypeIdRequeteControleAIP,
                                      Origin = Label.CAS_Origine_NouveauFoyer,
                                      AccountId=foyer2.id,
                                      Foyer_paneliste__c = paneliste2.id,
                                      Type = Label.CAS_Type_Recrute,
                                      Sous_type__c = Label.CAS_Sous_type_WelcomeCall,
                                      Nombre_de_tentatives_welcome_call__c = 5
                                     );
            insert reqWelcome;
            //creer equipements
            List<Asset> assetToInsert = new list<Asset>();
            For(Integer index=0 ;index<3;index++){//Date.newInstance(2021, 7, 17)
                assetToInsert.add(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                            Name='test2 equi'+index,audimetre__c='iuyhEEhg'+index,Foyer_paneliste__c=paneliste2.id,AccountId=foyer2.id,Date_de_premiere_detection__c=Date.newInstance(2021, 7, 17),
                                            Date_de_premiere_collecte_d_audience__c=Date.newInstance(2021, 7, 17)));
            }
            insert assetToInsert;
            Test.startTest();
            Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
            Id batchId = Database.executeBatch(bccfb);
            Test.stopTest();
            // after the testing stops, assert records were updated properly
            //System.assertEquals(Label.CAS_Statut_Cloture, [select id ,Sous_type__c,Status from case where Sous_type__c=:Label.CAS_Sous_type_WelcomeCall].status);
        }
    } 
    @isTest static void testCollect(){
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Commande';
        update u;
        
        System.runAs(u){
            Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
            Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
            //------------------------------- test  cloturer la requete :tt  date debut detection > 21 jours
            //creer foyer
            Account foyer2 = new Account(name='FoyerTest2');
            insert(foyer2);
            //creer foyer paneliste aip
            Foyer_paneliste__c paneliste2 = new Foyer_paneliste__c(name='PanelisteTest2',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer2.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe);
            insert(paneliste2);
            //insert case welcome call
            Case reqWelcome= new case(RecordTypeId = recordTypeIdRequeteControleAIP,
                                      Origin = Label.CAS_Origine_NouveauFoyer,
                                      AccountId=foyer2.id,
                                      Foyer_paneliste__c = paneliste2.id,
                                      Type = Label.CAS_Type_Anomalie_Materiel,
                                      Nombre_de_tentatives_welcome_call__c = 5
                                     );
            insert reqWelcome;
            //creer equipements
            List<Asset> assetToInsert = new list<Asset>();
            For(Integer index=0 ;index<3;index++){//Date.newInstance(2021, 7, 17)
                assetToInsert.add(new asset(recordtypeid=Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId(),
                                            Name='test2 equi'+index,audimetre__c='iuyheeeehg'+index,Foyer_paneliste__c=paneliste2.id,AccountId=foyer2.id,Date_de_premiere_detection__c=Date.newInstance(2021, 7, 17),
                                            Date_de_premiere_collecte_d_audience__c=Date.newInstance(2021, 7, 17)));
            }
            insert assetToInsert;
            Test.startTest();
            Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
            Id batchId = Database.executeBatch(bccfb);
            Test.stopTest();
        }
    }  
    @isTest static void testStatutAudim(){
        
        Id recordTypeIdRequeteControleAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        //creer foyer
        Account foyer2 = new Account(name='FoyerTest2');
        insert(foyer2);
        //creer foyer paneliste aip
        Foyer_paneliste__c paneliste2 = new Foyer_paneliste__c(name='PanelisteTest2',RecordTypeId=recordTypeIdPanelAIP,Foyer__c=foyer2.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe,
                                                               Statut_Audimetrique__c = Label.PAN_Statut_Audimetrique_Present_Batch009);
        insert(paneliste2);
        //insert case
        Case req= new case(RecordTypeId = recordTypeIdRequeteControleAIP,
                           Origin = Label.CAS_Origine_NouveauFoyer,
                           AccountId=foyer2.id,
                           Foyer_paneliste__c = paneliste2.id,
                           Type = Label.CAS_Type_Non_repondant,
                           Type_de_controle__c = Label.CAS_TypeControle_Non_Repondant);
        insert req;
        
        Controle__c controleTest = Test_Utils.createControle(foyer2.Id, null, null, req.Id, null);
        controleTest.Foyer_Paneliste__c= paneliste2.Id;
        insert controleTest;
        
        Test.startTest();
        Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
    }
    
    
    
    @isTest
    static void testPassageControleAIPAbandonne() {
        
        Id recordTypeIdControleAIP =Schema.SObjectType.case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdControleControleAIP =Schema.SObjectType.controle__c.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        
        list<Account> listFoyersToInsert = new list<Account>();
        account foyer = Test_Utils.createFoyer();
        foyer.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyer); 
        
        insert listFoyersToInsert;
        
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Name = 'Foyer panéliste';
        foyerPaneliste.Foyer__c = foyer.id;
        foyerPaneliste.RecordTypeId = recordTypeIdPanelAIP;
        foyerPaneliste.Statut_Audimetrique__c = Label.PAN_Statut_Audimetrique_Present_Batch009;
        listFoyerPaneliste.add(foyerPaneliste);
        
        insert listFoyerPaneliste;
        
        List<Case> caseToInsert = new list<Case>();
        Case requete1 = Test_Utils.createCase(foyer.Id);
        requete1.RecordTypeId = recordTypeIdControleAIP;
        requete1.Origin = Label.CAS_Origine_Controle;
        requete1.Status = Label.CAS_Statut_Cloture;
        requete1.Foyer_paneliste__c = foyerPaneliste.Id;
        requete1.Type_de_controle__c = Label.CAS_TypeControle_Non_Repondant;
        caseToInsert.add(requete1);
        
        Case requete2 = Test_Utils.createCase(foyer.Id);
        requete2.RecordTypeId = recordTypeIdControleAIP;
        requete2.Origin = Label.CAS_Origine_Controle;
        requete2.Status = Label.CAS_Statut_En_cours;
        requete2.Foyer_paneliste__c = foyerPaneliste.Id;
        caseToInsert.add(requete2);
        
        Case requete3 = Test_Utils.createCase(foyer.Id);
        requete3.RecordTypeId = recordTypeIdControleAIP;
        requete3.Origin = Label.CAS_Origine_Controle;
        requete3.Status = Label.CAS_Statut_Nouveau;
        requete3.Foyer_paneliste__c = foyerPaneliste.Id;
        caseToInsert.add(requete3);
        
        Case requete4 = Test_Utils.createCase(foyer.Id);
        requete4.RecordTypeId = recordTypeIdControleAIP;
        requete4.Origin = Label.CAS_Origine_Controle;
        requete4.Status = Label.CAS_Statut_Hierarchise;
        requete4.Foyer_paneliste__c = foyerPaneliste.Id;
        caseToInsert.add(requete4);
        
        Case requete5 = Test_Utils.createCase(foyer.Id);
        requete5.RecordTypeId = recordTypeIdControleAIP;
        requete5.Origin = Label.CAS_Origine_Controle;
        requete5.Type   = Label.CAS_Type_NonRepondantSetMeter;
        requete5.Foyer_paneliste__c = foyerPaneliste.Id;
        caseToInsert.add(requete5);
        
        Case requete6 = Test_Utils.createCase(foyer.Id);
        requete6.RecordTypeId = recordTypeIdControleAIP;
        //requete6.Origin = Label.CAS_Origine_Controle;
        requete6.Type   =  Label.CAS_Type_Non_repondant;
        requete6.Foyer_paneliste__c = foyerPaneliste.Id;
        caseToInsert.add(requete6);
        
        insert caseToInsert;
        
        List<Asset> equipementDuFoyerList = new List<Asset>();
        Id recordTypeIdEquipementDeMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(Label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Asset asset1 = Test_Utils.createEquipement(foyer.Id);
        asset1.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset1.Foyer_paneliste__c = foyerPaneliste.Id;
        asset1.Type_de_materiel__c = Label.ASS_TypeMateriel_Setmeter;
        asset1.Audimetre__c='lkdzgteii';
        asset1.Name = 'asset1';
        equipementDuFoyerList.add(asset1);        
        
        Asset asset2 = Test_Utils.createEquipement(foyer.Id);
        asset2.RecordTypeId = recordTypeIdEquipementDeMesureAIP;
        asset2.Foyer_paneliste__c = foyerPaneliste.Id;
        asset2.Type_de_materiel__c = Label.ASS_TypeMateriel_Pager;
        asset2.Audimetre__c='lkjogteioi';
        asset2.Name = 'asset2';
        equipementDuFoyerList.add(asset2);
        
        insert equipementDuFoyerList;
        
        System.debug('Asset2' + asset2);
        
        
        List<Controle__c> contrleToInsert = new list<Controle__c>();
        Controle__c controle1 = Test_Utils.createControle(foyer.Id, null, null, requete1.Id, null);
        controle1.Foyer_Paneliste__c= foyerPaneliste.Id;
        controle1.recordTypeId = recordTypeIdControleControleAIP;
        contrleToInsert.add(controle1);
        
        Controle__c controle2 = Test_Utils.createControle(foyer.Id, null, null, requete2.Id, null);
        controle2.Foyer_Paneliste__c= foyerPaneliste.Id;
        controle2.recordTypeId = recordTypeIdControleControleAIP;
        contrleToInsert.add(controle2);
        
        Controle__c controle3 = Test_Utils.createControle(foyer.Id, null, null, requete3.Id, null);
        controle3.Foyer_Paneliste__c= foyerPaneliste.Id;
        controle3.recordTypeId = recordTypeIdControleControleAIP;
        contrleToInsert.add(controle3);
        
        Controle__c controle4 = Test_Utils.createControle(foyer.Id, null, null, requete4.Id, null);
        controle4.Foyer_Paneliste__c = foyerPaneliste.Id;
        controle4.recordTypeId = recordTypeIdControleControleAIP;
        contrleToInsert.add(controle4);
      
        Controle__c controle5 = Test_Utils.createControle(foyer.Id, null, asset1.Id, requete5.Id, null);
        controle5.Foyer_Paneliste__c= foyerPaneliste.Id;
        controle5.recordTypeId = recordTypeIdControleControleAIP;
        contrleToInsert.add(controle5);
        
        Controle__c controle6 = Test_Utils.createControle(foyer.Id, null, asset2.Id, requete6.Id, null);
        controle6.Foyer_Paneliste__c= foyerPaneliste.Id;
        controle6.recordTypeId = recordTypeIdControleControleAIP;
        controle6.statut__c = Label.CTRL_Statut_Actif;
        contrleToInsert.add(controle6);
        
        insert contrleToInsert;
        
        System.debug('controle5  ' + controle5);
        System.debug('controle6  ' + controle6);
        
        Test.startTest();
        Batch009_ClotureRequeteAutomatique bccfb = new Batch009_ClotureRequeteAutomatique();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
                 
    }
    
    
}