@isTest

public class Batch_delete_case_FoyerAnonymTest {
    
    public static testMethod void Batch_delete_case_FoyerAnonymTest(){
        //create contact
        contact c = new contact();
        c.LastName='nom_142';
        c.Lien_parente__c='1';
        c.Date_d_entree_individu__c=system.today();
        c.Sexe__c='1';
        c.Type__c='1';
        c.Lettre__c='A';
        c.Birthdate=system.Date.today();
        c.FirstName='test';
        insert c;
        
        //create foyer
        account acc1 = Test_Utils.createFoyer(); 
            acc1.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
            acc1.Numero_de_portable__c = '0611111121';
        	
        insert acc1;
        c.AccountId=acc1.Id;
        update c;
        acc1.Personne_de_reference__c=c.Id;
        update acc1;
        
        //creer foyer paneliste 
        Foyer_paneliste__c paneliste = new Foyer_paneliste__c(name='PanelisteTest',Foyer__c= acc1.id,Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe); //MD
        insert paneliste; //MD

       //create case
        case cs = new case();
        cs.Foyer_paneliste__c = paneliste.id; //MD 
        cs.Origin='	Appel sortant';
        cs.Status='	Nouveau';
        cs.AccountId=acc1.Id;
        insert cs;
        
        Test.startTest();
	 		Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(acc1.id));
            Batch_delete_case_FoyerAnonym obj = new Batch_delete_case_FoyerAnonym();
            DataBase.executeBatch(obj); 
        Test.stopTest();
        list<case> liste = [select id from case];
        system.assertEquals(liste.size(), 0);
    }
}