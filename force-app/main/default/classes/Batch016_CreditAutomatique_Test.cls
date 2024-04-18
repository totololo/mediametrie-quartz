/*
* @author: Nancy Al Kalach
* @date: 09/12/2021
* @ Description Class that test Batch016_CreditAutomatique 
* History
* <Date of modification>   <Author>    <Description of modification>
*/

@isTest
public class Batch016_CreditAutomatique_Test {
    public static testMethod void Batch016_CreditAutomatiqueTest(){
        
        //insert Account(foyer)
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Date_d_installation__c=system.today()-60;
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        account testAccount2 = Test_Utils.createFoyer();
        testAccount2.Date_d_installation__c=Date.today().addMonths(-1).addDays(-1);
        testAccount2.Date_de_recensement__c=Date.today().addMonths(-1);
        testAccount2.Date_d_integration__c=Date.today().addDays(-21);
        testAccount2.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount2);
        
      	account testAccount3 = Test_Utils.createFoyer();
      	testAccount3.Date_d_installation__c = date.newInstance(system.today().year() - 2, system.today().month() - 1, system.today().day());
       	testAccount3.Numero_de_portable__c = '0611131121';
      	listFoyersToInsert.add(testAccount3);//Date.today().addDays(-30)
        insert listFoyersToInsert;
        
        
        List<Referentiel_Panel__c> listRefPanelToInsert = new List <Referentiel_Panel__c>();
        Referentiel_Panel__c testRefAIP = Test_Utils.createRefPanel(Label.RFP_Nom_AIP, Label.RFP_TypePanel_AIP);
        Referentiel_Panel__c testRefMMAT = Test_Utils.createRefPanel(Label.RFP_Nom_MMAT, Label.RFP_TypePanel_MMAT);
        Referentiel_Panel__c testRefPAME = Test_Utils.createRefPanel(Label.RFP_Nom_PAME, Label.RFP_TypePanel_PaME);
        listRefPanelToInsert.add(testRefAIP);
        listRefPanelToInsert.add(testRefMMAT);        
        listRefPanelToInsert.add(testRefPAME); 
        insert listRefPanelToInsert;
        
        List<Contact> listContactToInsert = new List<Contact>();
        Contact con = Test_Utils.createMembreFoyer(testAccount.Id);
        Contact con2 = Test_Utils.createMembreFoyer(testAccount2.Id);
        con.CSP4__c='1';
        con2.CSP4__c='2';
        listContactToInsert.add(con);
        listContactToInsert.add(con2);
        insert listContactToInsert;
        
        List<Account> listAccountToUpdate = new List<Account>();
        testAccount.Contact_principal__c = con.Id;
        listAccountToUpdate.add(testAccount);
        testAccount2.Contact_principal__c = con2.Id;
        listAccountToUpdate.add(testAccount2);
        update listAccountToUpdate;
        
        List<Foyer_paneliste__c> listFPToInsert= new list<Foyer_paneliste__c>();
      	Foyer_paneliste__c testFoyerPan = new Foyer_paneliste__c (name='TestFP',foyer__c=testAccount.id, Referentiel_Panel__c = testRefAIP.Id);
        testFoyerPan.Freeze__c=false;
        testFoyerPan.Date_de_creation__c = system.today()-61;
        testFoyerPan.Date_d_installation__c=system.today().addMonths(-2);
        testFoyerPan.Statut_Foyer_paneliste__c='1';
      	listFPToInsert.add(testFoyerPan);
        
        Foyer_paneliste__c testFoyerP = new Foyer_paneliste__c (name='TestFP',foyer__c=testAccount2.id, Referentiel_Panel__c = testRefAIP.Id);
        testFoyerP.Freeze__c=true;
        testFoyerP.Date_de_creation__c = system.today().addMonths(-13);
        testFoyerP.Date_d_installation__c=system.today().addMonths(-2);
   		testFoyerP.Statut_Foyer_paneliste__c='1';
        testFoyerP.Date_de_recensement__c=Date.today().addMonths(-1);
        listFPToInsert.add(testFoyerP); 
        
        Foyer_paneliste__c testFoyerPanelisteMediamat = new Foyer_paneliste__c (name='TestFP',foyer__c=testAccount2.id, Referentiel_Panel__c = testRefMMAT.Id);
        testFoyerPanelisteMediamat.Freeze__c=false;
        testFoyerPanelisteMediamat.Date_de_creation__c = system.today().addMonths(-13);
        testFoyerPanelisteMediamat.Date_d_installation__c=system.today().addMonths(-2);
        testFoyerPanelisteMediamat.Statut_Foyer_paneliste__c='1';
        testFoyerPanelisteMediamat.Date_de_recensement__c=Date.today().addMonths(-1);
        listFPToInsert.add(testFoyerPanelisteMediamat); 
        
        Foyer_paneliste__c testFoyerPanelistePame = new Foyer_paneliste__c (name='TestFP',foyer__c=testAccount2.id, Referentiel_Panel__c = testRefPAME.Id);
        testFoyerPanelistePame.Freeze__c=true;
        testFoyerPanelistePame.Date_de_creation__c = system.today().addMonths(-13);
        testFoyerPanelistePame.Statut_Foyer_paneliste__c='2';
        testFoyerPanelistePame.Date_de_recensement__c=Date.today().addMonths(-1);
        listFPToInsert.add(testFoyerPanelistePame); 
        
        insert listFPToInsert;
        
        List<Individu_Paneliste__c> listIndividuPanelisteToInsert = new List<Individu_Paneliste__c>();
      	Individu_Paneliste__c individuPaneliste = Test_Utils.createIndividuPaneliste(con.Id, testFoyerPan.Id, 'A');
        listIndividuPanelisteToInsert.add(individuPaneliste);
        Individu_Paneliste__c individuPaneliste2 = Test_Utils.createIndividuPaneliste(con2.Id, testFoyerP.Id, 'B');
        listIndividuPanelisteToInsert.add(individuPaneliste2);
        Individu_Paneliste__c individuPaneliste3 = Test_Utils.createIndividuPaneliste(con2.Id, testFoyerPanelisteMediamat.Id, 'C');
        listIndividuPanelisteToInsert.add(individuPaneliste3);
        insert listIndividuPanelisteToInsert;
        
        Test.startTest();
        Batch016_CreditAutomatique btch = new Batch016_CreditAutomatique();
        database.executeBatch(btch);
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Test.stopTest();
    }
}