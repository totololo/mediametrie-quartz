/*
* @author: Maribelle ZARAZIR EI
* @date: 08/2021
* @ Description Test class for Batch009_Debit_RemiseSoldeAZero
* @Coverage: 88%
* History
* <Date of modification>   <Author>    <Description of modification>
*/

@isTest
public class Batch009_Debit_RemiseSoldeAZero_Test {
   
    
     @istest
    static void createTestData() {
        
        User u= [SELECT Id, Bypass_validation_rules__c FROM User where  isactive=true and Profile.Name like '%admin%' limit 1];
    u.Bypass_flows__c=true;
        u.Bypass_validation_rules__c=true;
    update u;
        system.runAs(u){
        list<Account> listFoyersToInsert = new list<Account>();
        
        account testAccount = Test_Utils.createFoyer();
        testAccount.Date_d_installation__c = system.today() - 120;
        testAccount.Numero_de_portable__c = '0611111121';
        testAccount.Date_de_chute__c = system.today() - 80;
        //testAccount.Statut_du_foyer__c='5';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.name = Label.RFP_Nom_PaME;
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste = new Foyer_Paneliste__c();
        foyerPaneliste.foyer__c = testAccount.Id;
        foyerPaneliste.name = 'FOyer Pan';
        foyerPaneliste.Statut_Foyer_paneliste__c='5';
        foyerPaneliste.Date_de_chute__c=Date.today().adddays(-80);
        foyerPaneliste.Date_de_chute_temporaire__c=Date.today().adddays(-80);
        foyerPaneliste.referentiel_panel__c = refPanPaME.Id;
        foyerPaneliste.Intervention_en_cours__c = false;
        Insert foyerPaneliste;
            
        foyerPaneliste.Date_de_chute__c=Date.today().adddays(-80);
        foyerPaneliste.Date_de_chute_temporaire__c=Date.today().adddays(-80);
            update foyerPaneliste;
        system.debug('fp'+foyerPaneliste.Date_de_chute__c);
        //compo foyer
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = new Contact();
            Cont.AccountId = testAccount.id;
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
        
        
       
        list<Individu_Paneliste__c> listIndividuPanelisteToInsert = new list<Individu_Paneliste__c>();
            Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
                indPanTest.name = 'indPanTest1';
                indPanTest.Lettre__c = 'B';
                indPanTest.Foyer_paneliste__c = foyerPaneliste.id;
                indPanTest.Composition_du_foyer__c = cont.id;
                indPanTest.Date_de_chute_de_l_individu__c = null;
                indPanTest.Date_de_derniere_activite_mobile__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPanTest);
        
        insert listIndividuPanelisteToInsert;
        
        
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        
        Id creditRecordTypeId = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByDeveloperName().get('Credit').getRecordTypeId();
        
        list<Fidelisation__c> listFidelisationsToInsert = new list<Fidelisation__c>();
        
        Fidelisation__c ligneCredit = new Fidelisation__c(
            ACC_EXTId_SIPanel__c = testAccount.ACC_EXTId_SIPanel__c,
            Foyer__c = testAccount.Id,
            Points_credites__c = 2500,
            Composition_du_foyer__c=Cont.Id,
            Individu_paneliste__c=indPanTest.Id,
            Foyer_paneliste__c=foyerPaneliste.id,
            Solde_de_points_a_creation__c = testAccount.Solde_de_points__c,
            RecordTypeId = creditRecordTypeId,
            Motif_de_credit__c='1',
            Type_de_mouvement__c = '6' //credit automatique
        );
        
        listFidelisationsToInsert.add(ligneCredit);
        
        insert ligneCredit;

        
        //Account testAccount = [SELECT Id, Solde_de_points__c FROM Account LIMIT 1]; 
        
        
        Test.startTest();
        Batch009_Debit_RemiseSoldeAZero btch = new Batch009_Debit_RemiseSoldeAZero();
           
        database.executeBatch(btch);
        Test.stopTest();
        }
    }
}