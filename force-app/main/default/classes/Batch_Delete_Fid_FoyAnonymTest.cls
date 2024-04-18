@isTest

public class Batch_Delete_Fid_FoyAnonymTest {
    
    public static testMethod void Batch_Delete_Fid_FoyAnonymTest(){
        //create contact
        contact c = new contact();
        c.LastName='nom_147';
        c.Lien_parente__c='1';
        c.Date_d_entree_individu__c=system.today();
        c.Sexe__c='1';
        c.Type__c='1';
        c.Lettre__c='B';
        c.Birthdate=system.Date.today();
        c.FirstName='test';
        insert c;
        
        //create foyer
        account acc1 = Test_Utils.createFoyer(); 
            acc1.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
            acc1.Numero_de_portable__c = '0611141121';
        	
        insert acc1;
        c.AccountId=acc1.Id;
        update c;
        acc1.Personne_de_reference__c=c.Id;
        update acc1;
        Id recordTypeIdFIDcredit =Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
        
        //creer Référentiel panel
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c(); //MD
        refPanAIP.name = Label.RFP_Nom_AIP; //MD
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP; //MD
        insert refPanAIP; //MD
        
        //creer foyer paneliste 
       Foyer_paneliste__c paneliste = new Foyer_paneliste__c(name='PanelisteTest',Foyer__c= acc1.id,referentiel_panel__c = refPanAIP.Id); //MD
       insert paneliste; //MD
        
        //compo foyer
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = new Contact();
            Cont.AccountId = acc1.id;
            Cont.Lastname = 'compoFoyerLastName1';
            Cont.FirstName='cc';
            Cont.Lien_parente__c='1';
            Cont.Type__c='1';
            Cont.CSP42__c='ttt';
            Cont.CSP4__c='ddd';
            Cont.Birthdate = date.today().addDays(- 10000);
            Cont.CON_ExtId_SIPanel__c = '122221111';
            Cont.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
            Cont.Lettre__c='A'; 
                listMembreFoyerToInsert.add(Cont);
        
        insert listMembreFoyerToInsert;
        
        //indiv paneliste
        list<Individu_Paneliste__c> listIndividuPanelisteToInsert = new list<Individu_Paneliste__c>();
            Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
                indPanTest.name = 'indPanTest1';
                indPanTest.Lettre__c = 'B';
                indPanTest.Foyer_paneliste__c = paneliste.id;
                indPanTest.Composition_du_foyer__c = Cont.id;
                indPanTest.Date_de_chute_de_l_individu__c = null;
                indPanTest.Date_de_derniere_activite_mobile__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPanTest);
        
        insert listIndividuPanelisteToInsert;
        
        // create fid
        Fidelisation__c fid = new Fidelisation__c();
        fid.Foyer__c=acc1.id;
        fid.Foyer_paneliste__c = paneliste.Id; //MD
        fid.RecordTypeId=recordTypeIdFIDcredit;
        fid.Type_de_mouvement__c='6';
        fid.Motif_de_credit__c='4';
        fid.Points_credites__c=50;
        fid.Composition_du_foyer__c=Cont.Id;
        fid.Individu_paneliste__c=indPanTest.Id;
        insert fid;
        
        
       List<case> listcase = [select id from case ];
        system.debug('case==='+listcase);
        delete(listcase);
        Test.startTest();
	 		Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(acc1.id));
            Batch_Delete_Fid_FoyAnonym obj = new Batch_Delete_Fid_FoyAnonym();
            DataBase.executeBatch(obj); 
        Test.stopTest();
        list<account> listacc=[select id from account];
        list<Fidelisation__c> listfid =[select id from Fidelisation__c];
        system.assertEquals(listacc.size(), 0);
        system.assertEquals(listfid.size(), 0);
    }
}