/*
* @author: Maribelle Zarazir
* @date: 31/03/2021
* @ Description Class that tests the execution of AP01_Conge.apxc and CongeAfterInsert.apxt
* History
* <Date of modification>   <Author>    <Description of modification>		
*/

@istest
public class AP01_Conge_Test {
    @testSetup
    static void setup() {
        list<Account> listFoyersToInsert = new list<Account>();
        account acc = Test_Utils.createFoyer();
        listFoyersToInsert.add(acc); 
        
        Conge__c conge1 = new Conge__c(Foyer__c = acc.Id, Date_de_debut__c = System.today(), Date_de_fin__c = (System.today()+2), Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2');
        insert conge1;
   
        account acc1 = Test_Utils.createFoyer();
        acc1.Numero_de_portable__c='1234567899';
        listFoyersToInsert.add(acc1); 
        insert listFoyersToInsert;
        
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        Contact Cont = Test_Utils.createMembreFoyer(acc.id); 
        Cont.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        Cont.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        Cont.Code_profession__c = 132;
        Cont.CON_ExtId_SIPanel__c = '12222345';
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont.CON_ExtId_SIPanel__c));
        listMembreFoyerToInsert.add(Cont);
        
        Contact Cont1 = Test_Utils.createMembreFoyer(acc1.id); 
        Cont1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        Cont1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        Cont1.Code_profession__c = 132;
        Cont1.CON_ExtId_SIPanel__c = '122223451';
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont1.CON_ExtId_SIPanel__c));
        listMembreFoyerToInsert.add(Cont1);
        insert listMembreFoyerToInsert;
    }
	@isTest
    static void congeAnterieurExistant(){
        
        List<Conge__c> listConges = new List<Conge__c>();
        account acc = Test_Utils.createFoyer();
        insert acc;
        
        contact cont = new contact();
        cont.LastName='testCont';
        cont.FirstName = 'testCont';
        cont.Nombre_d_heures_travaillees__c=3;
        cont.Date_d_entree_individu__c = Date.today();
        cont.Type__c = '0';
        cont.AccountId = acc.id;  
        cont.MobilePhone='1234567891';
        cont.Birthdate = date.newInstance(1993, 02, 25);
        cont.Lettre__c = 'C';
        cont.Lien_parente__c = '1';
        cont.Lien_de_parente_stat__c = '1';
        insert cont;
        conge__c conge= new conge__c();
        conge.Date_de_debut__c=system.today();
        conge.Date_de_fin__c=system.today()+5;
        conge.Foyer__c=acc.id;
        conge.Type_de_conge__c='3';
        conge.Motif__c='0';
        listConges.add(conge);
        
        conge__c con= new conge__c();
        con.Date_de_debut__c=system.today()+1;
        con.Date_de_fin__c=system.today()+3;
        con.Foyer__c=acc.id;
        con.Type_de_conge__c='3';
        con.Motif__c='0';
        listConges.add(con);
        
        conge__c conge2= new conge__c();
        conge2.Date_de_debut__c=system.today();
        conge2.Date_de_fin__c=system.today()+5;
        conge2.Foyer__c=acc.id;
        conge2.Conge_de_l_individu__c=cont.id;
        conge2.Type_de_conge__c='3';
        conge2.Motif__c='0';
        insert conge2;
        listConges.add(conge2);
        
        conge__c cong1= new conge__c();
        cong1.Date_de_debut__c=system.today()+1;
        cong1.Date_de_fin__c=system.today()+3;
        cong1.Conge_de_l_individu__c=cont.Id;
        cong1.Foyer__c=acc.id;
        cong1.Type_de_conge__c='3';
        cong1.Motif__c='0';
        
        listConges.add(cong1);
            Boolean exceptionThrown = false;
		
        try{
            insert cong1;
        }
        catch(Exception ex){
            exceptionThrown=true;
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Script-thrown exception') ? true : false;
			System.assertEquals(expectedExceptionThrown, true);
        }

  
        

    }
	@isTest
    static void CreateCongeFoyer(){
        String accExtId = '042f0722-5ea4-4211-8319-329320ac82ff';
        MembreFoyerCallout_Mock fakeUpdateAcc = new MembreFoyerCallout_Mock(accExtId);
        
        Account acc = [SELECT Id FROM Account limit 1];
        Conge__c conge = new Conge__c(Foyer__c = acc.Id, Date_de_debut__c = System.today()-5, Date_de_fin__c = (System.today()+1),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2');
        
        Conge__c conge1 = new Conge__c(Foyer__c = acc.Id, Date_de_debut__c = System.today()-1, Date_de_fin__c = (System.today()+2),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2', Conge_de_l_individu__c=null);
        Conge__c conge2 = new Conge__c(Foyer__c = acc.Id, Date_de_debut__c = System.today()-1, Date_de_fin__c = (System.today()+1),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2', Conge_de_l_individu__c=null);
        test.startTest();
        acc.TECH_CongePrincipal__c=conge.id;
		update acc;
        Test.setMock(HttpCalloutMock.class, fakeUpdateAcc); 
        insert conge;
        insert conge1;
        insert conge2;
        test.stopTest();
    }
    
    @isTest
    static void CreateCongeIndividu(){
        String accExtId = '042f0722-5ea4-4211-8319-329320ac82ff';
        MembreFoyerCallout_Mock fakeUpdateAcc = new MembreFoyerCallout_Mock(accExtId);
        
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        
        Conge__c conge = new Conge__c(Foyer__c = con.AccountId, Conge_de_l_individu__c = con.Id,
                                      Date_de_debut__c = System.today()-1, Date_de_fin__c = (System.today()+1),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2');
        Conge__c conge1 = new Conge__c(Foyer__c = con.AccountId, Conge_de_l_individu__c = con.Id,
                                      Date_de_debut__c = System.today()+5, Date_de_fin__c = (System.today()+7),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2');
        
        Conge__c conge2 = new Conge__c(Foyer__c = con.AccountId, Date_de_debut__c = System.today()-1, Conge_de_l_individu__c = null, Date_de_fin__c = (System.today()+7),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '1');
        Conge__c conge3 = new Conge__c(Foyer__c = con.AccountId, Conge_de_l_individu__c = con.Id,
                                      Date_de_debut__c = System.today()+5, Date_de_fin__c = (System.today()+6),
                                      Motif__c = Label.CONG_Motif_Autre, Type_de_conge__c = '2');
        
        
        List<Conge__c> listConges = new List<Conge__c>();
        listConges.add(conge);
        listConges.add(conge1);
        listConges.add(conge2);
        listConges.add(conge3);
                
        con.TECH_CongePrincipal__c=conge1.id;
        update con;
        test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeUpdateAcc); 
        insert conge;
        insert conge1;
        insert conge2;
        insert conge3;
        conge.Date_de_fin__c = (System.today()+4);
        update conge;
        delete conge;
        test.stopTest();
        
    }
}