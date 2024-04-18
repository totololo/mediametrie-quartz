@istest
public class BATCH0014_UpdateConge_Test {
    public static testMethod void BATCH0014_UpdateConge_Test() {
        list<Account> listFoyersToInsert = new list<Account>();
        account acc1 = Test_Utils.createFoyer();
        listFoyersToInsert.add(acc1); 
        account acc2 = Test_Utils.createFoyer();
        listFoyersToInsert.add(acc2); 
        account acc3 = Test_Utils.createFoyer();
        listFoyersToInsert.add(acc3); 
        account acc4 = Test_Utils.createFoyer();
        listFoyersToInsert.add(acc4); 
        insert listFoyersToInsert;
        
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
       
        Contact contact1 = Test_Utils.createMembreFoyer(acc1.id); 
        contact1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contact1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        contact1.Code_profession__c = 132;
        contact1.CON_ExtId_SIPanel__c = '122233458';
        
        Contact contact2 = Test_Utils.createMembreFoyer(acc2.id); 
        contact2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contact2.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        contact2.Code_profession__c = 132;
        contact2.CON_ExtId_SIPanel__c = '124433458';
        
        Contact contact3 = Test_Utils.createMembreFoyer(acc3.id); 
        contact3.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contact3.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        contact3.Code_profession__c = 132;
        contact3.CON_ExtId_SIPanel__c = '114433458';
        
        Contact contact4 = Test_Utils.createMembreFoyer(acc4.id); 
        contact4.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contact4.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        contact4.Code_profession__c = 132;
        contact4.CON_ExtId_SIPanel__c = '814433458';
        
        listMembreFoyerToInsert.add(contact1);
        listMembreFoyerToInsert.add(contact2);
        listMembreFoyerToInsert.add(contact3);
        listMembreFoyerToInsert.add(contact4);

        insert listMembreFoyerToInsert; 
        
        Conge__c conge1 = new Conge__c();
		conge1.Date_de_debut__c= system.today() - 5;
        conge1.Date_de_fin__c= system.today() ;
        conge1.Conge_de_l_individu__c=contact1.Id;
        conge1.Foyer__c=acc1.Id;
        conge1.Type_de_conge__c= '1';
        conge1.Motif__c='1';
        insert conge1;
        
        
        Conge__c conge2 = new Conge__c();
		conge2.Date_de_debut__c= system.today();
        conge2.Date_de_fin__c= system.today() + 3;
        conge2.Conge_de_l_individu__c= contact2.Id;
        conge2.Foyer__c=acc2.Id;
        conge2.Type_de_conge__c= '1';
        conge2.Motif__c='1';
        insert conge2;
        
        Conge__c conge3 = new Conge__c();
		conge3.Date_de_debut__c= system.today()+4;
        conge3.Date_de_fin__c= system.today() +6;
        //conge3.Conge_de_l_individu__c= contact3.Id;
       
        conge3.Foyer__c=acc3.Id;
        conge3.Type_de_conge__c= '1';
        conge3.Motif__c='1';
        insert conge3;
        
        
        
        Conge__c conge4 = new Conge__c();
		conge4.Date_de_debut__c= system.today()-9;
        conge4.Date_de_fin__c= system.today()+7;
        conge4.Conge_de_l_individu__c= contact4.Id;
        conge4.Foyer__c=acc4.Id;
        conge4.Type_de_conge__c= '1';
        conge4.Motif__c='1';
        insert conge4;
        
        contact2.TECH_CongePrincipal__c=conge3.Id;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(contact1.CON_ExtId_SIPanel__c));
        BATCH0014_UpdateConge btch = new BATCH0014_UpdateConge();
        database.executeBatch(btch); 
        Test.stopTest();
      
        system.assertEquals( contact2.TECH_CongePrincipal__c,conge3.Id);
    }
}