/*
* @date: 22/07/2021
* @ Description Class qui teste AP01_Commande . Associatée au declenchers : REqueteAfterUpdate & REqueteAfterInsert
* @version 1.00   
* pourcentage : 95%
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest 
public class AP01_Commande_Test {
    @testSetup static void setup() {
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP08_FoyerPaneliste';
        u.Bypass_flows__c = true;
        update u;

        System.runAs(u){
        Id recordTypeIdRequeteDemandePaneliste =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePaneliste).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdEQTMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
        Referentiel_Panel__c refPAnel = new Referentiel_Panel__c(Name = Label.RFP_Nom_AIP);
        refPAnel.Type_de_panel__c =Label.RFP_TypePanel_AIP;
        insert (refPAnel);
        System.debug('Test refPAnel ' + refPAnel.Type_de_panel__c);
        
        Id catalogueId = Test.getStandardPricebookId();
        //Inserer beacon
        Product2 Beacon =new Product2(name=Label.Panel_Beacon_PackStandard,Type_de_produit__c=Label.Pro_type_Beacon,IsActive = true,Renvoi_Beacon__c = true, Pack_Initial_Pager__c = true, Pack_initial_pager_et_setmeter__c = true);
        insert(Beacon);
        insert(new pricebookentry(Product2Id=Beacon.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));
        //Inserer beacon 2
        /* Product2 Beacon2 =new Product2(name=Label.Panel_Beacon_PackStandard,Type_de_produit__c=Label.Pro_type_Beacon,IsActive = true,Pack_Initial_Pager__c = true);
        insert(Beacon2);
        insert(new pricebookentry(Product2Id=Beacon2.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));*/
        //Inserer pager
        Product2 pager =new Product2(name=Label.Panel_Pager_PackStandard,Type_de_produit__c=Label.Pro_type_Pager,IsActive = true,Pack_initial_pager_et_setmeter__c = true, Family = Label.PRO_Family_AIP);
        insert(pager);
        insert(new pricebookentry(Product2Id=pager.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));
        //Inserer setMeter
        Product2 setMeter =new Product2(name=Label.Panel_SetMeter_PackStandard,Type_de_produit__c=Label.Pro_type_SetMeter,IsActive = true,Pack_initial_pager_et_setmeter__c = true, Family = Label.PRO_Family_AIP);
        insert(setMeter);
        insert(new pricebookentry(Product2Id=setMeter.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));
        //Inserer usb
        Product2 chargeur =new Product2(name='cable usb',Type_de_produit__c='Accessoire',IsActive = true,Pack_initial_pager_et_setmeter__c = true, Family = Label.PRO_Family_AIP);
        insert(chargeur);
        insert(new pricebookentry(Product2Id=chargeur.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));
        //Inserer cordon cou
        Product2 cordCou =new Product2(name='cordon cou',Type_de_produit__c='Accessoire',IsActive = true,Pack_initial_pager_et_setmeter__c = true, Family = Label.PRO_Family_AIP);
        insert(cordCou);
        insert(new pricebookentry(Product2Id=cordCou.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));
        //Inserer EnveloppeDeRetour
        Product2 EnveloppeDeRetour =new Product2(name=Label.Prod_EnveloppeDeRetour,IsActive = true,Chute__c = true );
        insert(EnveloppeDeRetour);
        insert(new pricebookentry(Product2Id=EnveloppeDeRetour.id ,UnitPrice=2,Pricebook2Id=catalogueId,IsActive = true));  
        // Créer un foyer pour l'insérer dans le panel
        Account foyerTest = new Account(Name='testPanel');
        insert foyerTest;
        
        // Foyer paneliste Chute
        List<Foyer_paneliste__c> FpChute = new List<Foyer_paneliste__c>();
        Foyer_paneliste__c fpchute1 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='test1',Foyer__c=foyerTest.id,
                                                             Nombre_de_beacons__c=1,Nombre_de_pagers__c=2,Nombre_de_set_meters__c=2,
                                                             Referentiel_Panel__c = refPAnel.Id, Date_de_chute_temporaire__c = date.newInstance(2022, 02, 27));
        FpChute.add(fpchute1);
        
        Foyer_paneliste__c fpchute2 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='test2',Foyer__c=foyerTest.id,
                                                             Nombre_de_beacons__c=1,Nombre_de_pagers__c=2,Nombre_de_set_meters__c=2);
                                                            
                                                             
                                                             
        FpChute.add(fpchute2);
        insert FpChute;
        
        List<Asset> assetToInsert = new list<Asset>();
        For(Integer index=0 ; index < 3 ; index++){//Date.newInstance(2021, 7, 17)
            Asset eqtMesure = new Asset();
            eqtMesure.recordtypeid = recordTypeIdEQTMesureAIP;
            eqtMesure.Name = 'test1 equi' + index;
            eqtMesure.Audimetre__c='kjiz'+index;
            eqtMesure.Foyer_paneliste__c=Fpchute[0].id;
            eqtMesure.AccountId=Fpchute[0].Foyer__c;
            eqtMesure.Date_de_premiere_detection__c=Date.newInstance(2021, 7, 17);
            assetToInsert.add(eqtMesure);
        }
        insert assetToInsert;
        // Foyer paneliste Pack initial
        List<Foyer_paneliste__c> FpPackInit = new List<Foyer_paneliste__c>();
        Foyer_paneliste__c fpPackInit1 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='test1',Foyer__c=foyerTest.id,
                                                                Nombre_de_beacons__c=1,Nombre_de_pagers__c=1,Nombre_de_set_meters__c=3, Referentiel_Panel__c = refPAnel.Id);
        FpPackInit.add(fpPackInit1);
        
        Foyer_paneliste__c fpPackInit2 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='test2',Foyer__c=foyerTest.id,
                                                                Nombre_de_beacons__c=1,Nombre_de_pagers__c=1,Nombre_de_set_meters__c=2, Referentiel_Panel__c = refPAnel.Id);
        FpPackInit.add(fpPackInit2);
 
        insert FpPackInit;  
        
        // creer des requetes de type Label.Cas_Type_DemandeChute demande de chute
        List<Case> caseChuteToInsert = new List<Case>();
        //case chute 1
        Case casechute1 = new Case(Chute_confirmee__c=false,type=Label.Cas_Type_DemandeChute,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePaneliste,AccountId=fpchute1.Foyer__c,Foyer_paneliste__c=fpchute1.id);
        caseChuteToInsert.add(casechute1);
        //case chute 2
        Case casechute2 = new Case(Chute_confirmee__c=false,type=Label.Cas_Type_DemandeChute,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePaneliste,AccountId=fpchute2.Foyer__c,Foyer_paneliste__c=fpchute2.id);
        caseChuteToInsert.add(casechute2);
        insert(caseChuteToInsert);
        System.debug('Test caseChuteToInsert ' + caseChuteToInsert);
        System.debug('Test caseChute2 ' + casechute2);
        
        List<Case> requeteUpdate = new List<Case>();
        casechute1.Chute_confirmee__c = true;
        casechute1.Motif_de_chute__c = 'Ondes';
        requeteUpdate.add(casechute1);
        casechute2.Chute_confirmee__c = true;
        casechute2.Motif_de_chute__c = 'Ondes';
        requeteUpdate.add(casechute2);
        
        update requeteUpdate;
            
        List<Foyer_paneliste__c> FpChuteToUpdate = new List<Foyer_paneliste__c>();
        fpchute1.Date_de_chute__c = date.today();        
	    FpChuteToUpdate.add(fpchute1);
        Update FpChuteToUpdate;
        
        //creer des requetes de type recrute 
        List<Case> caseRecruteToInsert = new List<Case>();
        // case recrute 1
        Case caseRecrute1 =new Case(type=Label.CAS_Type_Recrute,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePanelisteAIP,AccountId=fpPackInit1.Foyer__c,Foyer_paneliste__c=fpPackInit1.id, sous_type__c = Label.CAS_Sous_type_PackInitial_SetMeter);
        caseRecruteToInsert.add(caseRecrute1);
        // case recrute 2
        Case caseRecrute2 =new Case(type=Label.CAS_Type_Recrute,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePanelisteAIP,AccountId=fpPackInit2.Foyer__c,Foyer_paneliste__c=fpPackInit2.id, sous_type__c = Label.CAS_Sous_type_PackInitial_SetMeter);
        caseRecruteToInsert.add(caseRecrute2);
        insert(caseRecruteToInsert);
        //creer des requetes de type renvoi 
        List<Case> caseRenvoiToInsert = new List<Case>();
        For(Foyer_paneliste__c fp :FpPackInit) {
            caseRenvoiToInsert.add(new Case(type=Label.CAS_Type_Reclamation_Materiel,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePaneliste,AccountId=fp.Foyer__c,Foyer_paneliste__c=fp.id));
        }
        Case caseRenvoi1 = new Case(type=Label.CAS_Type_Reclamation_Materiel,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePaneliste,AccountId=fpPackInit1.Foyer__c,Foyer_paneliste__c=fpPackInit1.id);
        caseRenvoiToInsert.add(caseRenvoi1);
        Case caseRenvoi2 = new Case(type=Label.CAS_Type_Reclamation_Materiel,origin=Label.CAS_Origine_NouveauFoyer,RecordTypeId=recordTypeIdRequeteDemandePaneliste,AccountId=fpPackInit2.Foyer__c,Foyer_paneliste__c=fpPackInit2.id);
        caseRenvoiToInsert.add(caseRenvoi2);
        insert(caseRenvoiToInsert);
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        update standardPricebook;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerTest.id));
        Test.stopTest();
            
        }
    }
    //@IsTest
    /*public static void TestCreerCommandeChute(){//Chute_definitive__c
        System.debug('stdr '+[select id, name from Pricebook2 where isStandard = true limit 1].id);
        System.debug('stdr '+Test.getStandardPricebookId());
        List<Case> cases =[select id , AccountId , Foyer_paneliste__c , type, Chute_confirmee__c  from case where type != :Label.CAS_Type_Recrute AND Sous_type__c=:label.Ord_Type_PackInitialPager];
        //AP01_Commande.creerCommandeChute(cases);
        List<Order> testOrders =[select id, (select id from OrderItems) from order where type=:Label.Ord_Type_PackChute];
        
        
        System.assertEquals(2, testOrders.size());
        System.assertEquals(1, testOrders[0].OrderItems.size());
    }*/
    
     @IsTest
    public static void TestCreerCommandeFPanChute(){        
        
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
                
        List<Foyer_paneliste__c> listfoyerPantt =[select id ,referentiel_panel__c, referentiel_panel__r.type_de_panel__c, date_de_chute__c from Foyer_paneliste__c where date_de_chute__c != null];
        System.debug('Test listfoyerPantt : '+ listfoyerPantt);
              
        AP01_Commande.creerCommandeChuteFoyerPan(listfoyerPantt);
        
        List<Order> testOrders = [select id, Name,(select id, product2.name from OrderItems) from order where type=:Label.Ord_Type_PackChute];
                
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
        System.assertEquals(2, testOrders.size());
        System.assertEquals(1, testOrders[0].OrderItems.size());
        Test.stopTest();
        
    }
    
    @IsTest
    public static void TestCreerCommandePackInitial(){
        String orderId = '04a14d54-f45e-4d41-9b59-a01bed2d9de3';
        List <String> listOrderId = new List <String>();
        listOrderId.add(orderId);
        
        IndividuPanelisteCallout_Mock fakeGetOrder = new IndividuPanelisteCallout_Mock(orderId);
        
        List<Case> cases =[select id , AccountId , Foyer_paneliste__c, sous_type__c , type ,Chute_confirmee__c  from case where type=:Label.CAS_Type_Recrute];
        System.debug('cases : '+cases);
        List<Order> testOrders = [select id, Name,(select id, product2.name from OrderItems) from order where type=:Label.Ord_Type_PackInitialPagerSetmeter];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetOrder); 
        System.assertEquals(2, testOrders.size());
        System.assertEquals(5, testOrders[0].OrderItems.size());
        Test.stopTest();
    }
    @IsTest 
    public static void TestCreerCommandeRenvoiBeacon(){
        List<Case> cases =[select id , AccountId , Foyer_paneliste__c , type   from case where type=:Label.CAS_Type_Reclamation_Materiel];
        System.debug('casesR :'+cases.size());
        AP01_Commande.creerCommandeRenvoieBeacon(cases);
        List<Order> testOrders = [select id, (select id from OrderItems) from order where type=:Label.Ord_TypeCommande_RenvoiBeacon];
        System.debug('testOrders--> '+testOrders);
        System.assertEquals(4, testOrders.size());
        System.assertEquals(1, testOrders[0].OrderItems.size());
    }
   
}