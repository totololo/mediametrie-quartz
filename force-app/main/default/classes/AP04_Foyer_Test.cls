/*
* @date: 23/07/2021
* @ Description : tester la classe AP04_Foyer
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @Coverage: 90%
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP04_Foyer_Test {
    @isTest
    public static void TestMajRefFoyer(){
        
        List<Account> listFoyer = new List<Account>();// foyer 
        Account foyer1 = new account(name='TestFoyer - 1');
        listFoyer.add(foyer1);
        Account foyer2 = new account(name='TestFoyer - 2');
        listFoyer.add(foyer2);
        Account foyer3 = new account(name='TestFoyer - 3');
        listFoyer.add(foyer3);
        Account foyer4 = new account(name='TestFoyer - 4');
        listFoyer.add(foyer4);
        insert listFoyer;
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recodTypeCredit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.name = Label.RFP_Nom_AIP;
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        insert refPanAIP;
        
        List<Foyer_paneliste__c> paneliste = new List<Foyer_paneliste__c>();// foyer paneliste
        
        Foyer_paneliste__c fp11 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 11',Foyer__c=foyer1.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp11);
        Foyer_paneliste__c fp12 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 12',Foyer__c=foyer1.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp12);
        Foyer_paneliste__c fp13 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 13',Foyer__c=foyer1.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp13);
        Foyer_paneliste__c fp14 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 14',Foyer__c=foyer1.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp14);
        
        Foyer_paneliste__c fp21 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 21',Foyer__c=foyer2.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp21);
        Foyer_paneliste__c fp22 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 22',Foyer__c=foyer2.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp22);
        Foyer_paneliste__c fp23 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 23',Foyer__c=foyer2.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp23);
        Foyer_paneliste__c fp24 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 24',Foyer__c=foyer2.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp24);
        
        Foyer_paneliste__c fp31 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 31',Foyer__c=foyer3.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp31);
        Foyer_paneliste__c fp32 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 32',Foyer__c=foyer3.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp32);
        Foyer_paneliste__c fp33 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 33',Foyer__c=foyer3.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp33);
        Foyer_paneliste__c fp34 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 34',Foyer__c=foyer3.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp34);
        
        Foyer_paneliste__c fp41 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 41',Foyer__c=foyer4.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp41);
        Foyer_paneliste__c fp42 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 42',Foyer__c=foyer4.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp42);
        Foyer_paneliste__c fp43 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 43',Foyer__c=foyer4.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp43);
        Foyer_paneliste__c fp44 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip 44',Foyer__c=foyer4.id, 
                                                         referentiel_panel__c = refPanAIP.Id);
        paneliste.add(fp44);
        
        insert paneliste;
        
        // composition du foyer
        List<Contact> compo = new List<Contact>();   
        
        contact comp1 =new contact(Lastname='TestCompo - 1',FirstName='FirstName 1',Type__c='1',AccountId=foyer1.id,Birthdate=Date.newInstance(1960, 2, 17),Lien_de_parente_stat__c='1',CSP4__c='',CSP42__c='');
        comp1.CSP4__c='1';
        compo.add(comp1);
        
        contact comp2 =new contact(Lastname='TestCompo - 2',FirstName='FirstName 2',Type__c='1',AccountId=foyer2.id,Birthdate=Date.newInstance(1960, 2, 17),Lien_de_parente_stat__c='1',CSP4__c='test',CSP42__c='test');
        comp2.CSP4__c='1';
        compo.add(comp2);
        
        contact comp3 =new contact(Lastname='TestCompo - 3',FirstName='FirstName 3',Type__c='1',AccountId=foyer3.id,Birthdate=Date.newInstance(1960, 2, 17),Lien_de_parente_stat__c='1',CSP4__c='test',CSP42__c='test');
        comp3.CSP4__c='1';
        compo.add(comp3);
        
        contact comp4 =new contact(Lastname='TestCompo - 4',FirstName='FirstName 4',Type__c='1',AccountId=foyer4.id,Birthdate=Date.newInstance(1960, 2, 17),Lien_de_parente_stat__c='1',CSP4__c='test',CSP42__c='test');
        comp4.CSP4__c='1';
        compo.add(comp4);
        insert compo;
        
        //indiv paneliste
        list<Individu_Paneliste__c> listIndividuPanelisteToInsert = new list<Individu_Paneliste__c>();
            Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
                indPanTest.name = 'indPanTest1';
                indPanTest.Lettre__c = 'B';
                indPanTest.Foyer_paneliste__c = fp11.id;
                indPanTest.Composition_du_foyer__c = comp1.id;
                indPanTest.Date_de_chute_de_l_individu__c = null;
                indPanTest.Date_de_derniere_activite_mobile__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPanTest);
        
        insert listIndividuPanelisteToInsert;
        
        // fidelisations Foyer_paneliste__c=
        List<Fidelisation__c> fid = new List<Fidelisation__c>();
        integer indexPan=0;
        
        Fidelisation__c fd11 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer1.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp11.id, Composition_du_foyer__c = comp1.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd11);
        Fidelisation__c fd12 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer1.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp12.id, Composition_du_foyer__c = comp1.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd12);
        Fidelisation__c fd13 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer1.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp13.id, Composition_du_foyer__c = comp1.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd13);
        Fidelisation__c fd14 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer1.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp14.id, Composition_du_foyer__c = comp1.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd14);
        
        Fidelisation__c fd21 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer2.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp21.id, Composition_du_foyer__c = comp2.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd21);
        Fidelisation__c fd22 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer2.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp22.id, Composition_du_foyer__c = comp2.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd22);
        Fidelisation__c fd23 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer2.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp23.id, Composition_du_foyer__c = comp2.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd23);
        Fidelisation__c fd24 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer2.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp24.id, Composition_du_foyer__c = comp2.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd24);
        
        Fidelisation__c fd31 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer3.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp31.id, Composition_du_foyer__c = comp3.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd31);
        Fidelisation__c fd32 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer3.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp32.id, Composition_du_foyer__c = comp3.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd32);
        Fidelisation__c fd33 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer3.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp33.id, Composition_du_foyer__c = comp3.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd33);
        Fidelisation__c fd34 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer3.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp34.id, Composition_du_foyer__c = comp3.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd34);
        
        Fidelisation__c fd41 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer4.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp41.id, Composition_du_foyer__c = comp4.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd41);
        Fidelisation__c fd42 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer4.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp42.id, Composition_du_foyer__c = comp4.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd42);
        Fidelisation__c fd43 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer4.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp43.id, Composition_du_foyer__c = comp4.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd43);
        Fidelisation__c fd44 = new Fidelisation__c(recordTypeId=recodTypeCredit,Foyer__c=foyer4.id,Points_credites__c=Decimal.ValueOf(Label.FID_NbrPoints_100),
                                                   Foyer_paneliste__c=fp44.id, Composition_du_foyer__c = comp4.Id,
                                                   Motif_de_credit__c='1',Type_de_mouvement__c = '6' ,Individu_paneliste__c=indPanTest.Id );
        fid.add(fd44);
        insert fid;
                
        List<Account> accToUpdate = new List<Account>();
        for(Account acc : [select  id ,Personne_de_reference__c, (select id from contacts) from account where id IN:listFoyer]){
            if(Acc.contacts.size() > 0){                
                acc.Personne_de_reference__c=acc.contacts[0].id;
                accToUpdate.add(acc);
                
            } 
        }        
       
        // ajout des lignes 53 , 54 et 56 car un appel au web service empeche le test , ces lignes ont ete copier de la class AP02_Foyer_test cree par joyce 
        String accExtId = '042f0722-5ea4-4211-8319-329320ac82ff';
        MembreFoyerCallout_Mock fakeGetAcc = new MembreFoyerCallout_Mock(accExtId);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetAcc); 
        if(accToUpdate!=null && accToUpdate.size()>0 && test.isRunningTest()){
            System.debug('----> Update account');
            update accToUpdate;
        }
        Test.stopTest();   
        AP04_Foyer.MajRefFoyer(accToUpdate);
        
    }
    
    public static testMethod void AP04Foyertest(){
        
        
        MembreFoyerCallout_Mock fakeGETAssets = new MembreFoyerCallout_Mock('ee');
        Test.setMock(HttpCalloutMock.class, fakeGETAssets); 
        
        
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account acc2 = Test_Utils.createFoyer();
        acc2.Name='test';
        listFoyersToInsert.add(acc2); 
        insert listFoyersToInsert;  
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.name = Label.RFP_Nom_PaME;
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.foyer__c = acc2.Id;
        foyerPaneliste.name = 'FOyer Pan';
        foyerPaneliste.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste.Intervention_en_cours__c = false;
        Insert foyerPaneliste;
        
        //Create Equipement
        list<asset> listEquipementsToInsert = new list<asset>();
        asset a1 = Test_Utils.createEquipement(acc2.Id);
        listEquipementsToInsert.add(a1);
        insert listEquipementsToInsert;
        
        
        //Create workOrder
        List<WorkOrder> listWorkOrderToInsert = new List<WorkOrder>();
        WorkOrder intervention = new WorkOrder();
        intervention.AccountId = acc2.Id;
        intervention.Foyer_paneliste__c = foyerPaneliste.Id;
        intervention.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
        intervention.Tech_TestClass__c = true;
        listWorkOrderToInsert.add(intervention);
        insert listWorkOrderToInsert;
        
        
        //create ServiceAppointment
        list<serviceAppointment> listServiceAppointmentToInsert = new list<serviceAppointment>();
        serviceAppointment SA = Test_Utils.createSA(intervention.Id); 
        SA.SchedStartTime=system.today();
        SA.SchedendTime=system.today()+1;
        listServiceAppointmentToInsert.add(SA); 
        
        insert listServiceAppointmentToInsert;
        
        acc2=[select name,ShippingStreet,ShippingCountry,ShippingpostalCode,ShippingCity from account Limit 1];
        acc2.ShippingCity='Grenoble';
        acc2.ShippingStreet='Rue des Arts';
        acc2.ShippingCountry='France';
        acc2.ShippingpostalCode='38000';
        update acc2;
        
        SA=[select City,Country,postalcode,street from ServiceAppointment LIMIT 1  ];
        System.assertEquals('Grenoble', sa.city);
        System.assertEquals('Rue des Arts', sa.Street);     
        System.assertEquals('France', sa.country);
        System.assertEquals('38000', sa.postalcode);     
        
        
        
    }
    
}