/*
* @Auteur : Claire VEHRLE
* @date: 02/11/2021
* @Classe: Batch013_CreationRequeteAIPNonRep
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@IsTest
public class Batch013_CreationRequeteAIPNonRep_Test {
    
    @IsTest
    static void testCreationRequeteAIPNonRep() { 
         Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        Id ControleAIPId = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        
        list<Account> listFoyersToInsert = new list<Account>();
        account foyer1 = Test_Utils.createFoyer();
        foyer1.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyer1);
        
        account foyer2 = Test_Utils.createFoyer();
        foyer2.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyer2);
        
        account foyer3 = Test_Utils.createFoyer();
        foyer3.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyer3); 
        
        account foyer4 = Test_Utils.createFoyer();
        foyer4.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyer4); 
        
        insert listFoyersToInsert;
        
        List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanelPaME = new Referentiel_Panel__c();
        refPanelPaME.Name = Label.RFP_Nom_PaME;
        refPanelPaME.Type_de_panel__c = Label.RFP_Nom_PaME;
        listReferentielPanelToInsert.add(refPanelPaME);
        
        insert listReferentielPanelToInsert;
        
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();        
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = foyer2.Id;
        foyerPaneliste1.Referentiel_Panel__c = refPanelPaME.Id;
        foyerPanelisteList.add(foyerPaneliste1);
                
        Foyer_Paneliste__c foyerPaneliste3 = new Foyer_Paneliste__c();
        foyerPaneliste3.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste3.Name = 'Foyer Paneliste 1';
        foyerPaneliste3.Foyer__c = foyer3.Id;
        foyerPaneliste3.Referentiel_Panel__c = refPanelPaME.Id;
        foyerPanelisteList.add(foyerPaneliste3);
        
        insert foyerPanelisteList;
                
        List<Controle__c> contrleToInsert = new list<Controle__c>();
        Controle__c controle1 = Test_Utils.createControle(foyer1.Id, null, null, null, null);  
		controle1.Foyer_paneliste__c = foyerPaneliste1.Id;      
        controle1.RecordTypeId = ControleAIPId;  
        controle1.Type_de_controle__c = Label.CTRL_Type_NonRepondant;
        controle1.Statut__c = Label.CTRL_Statut_Precode;
        contrleToInsert.add(controle1);
        
        Controle__c controle2 = Test_Utils.createControle(foyer2.Id, null, null, null, null);  
        controle2.RecordTypeId = ControleAIPId;  
        controle2.Foyer_paneliste__c = foyerPaneliste1.Id;  
        controle2.Type_de_controle__c = Label.CTRL_Type_NonRepondant;  
        controle2.Statut__c = Label.CTRL_Statut_Precode;
        contrleToInsert.add(controle2);
        
        Controle__c controle3 = Test_Utils.createControle(foyer3.Id, null, null, null, null);  
		controle3.Foyer_paneliste__c = foyerPaneliste3.Id;       
        controle3.RecordTypeId = ControleAIPId;  
        controle3.Type_de_controle__c = Label.CTRL_Type_NonRepondant; 
        controle3.Statut__c = Label.CTRL_Statut_Precode;
        contrleToInsert.add(controle3);
        
        Controle__c controle4 = Test_Utils.createControle(foyer4.Id, null, null, null, null);  
        controle4.RecordTypeId = ControleAIPId;  
        controle4.Foyer_paneliste__c = foyerPaneliste3.Id;
        controle4.Type_de_controle__c = Label.CTRL_Type_NonRepondant; 
        controle4.Statut__c = Label.CTRL_Statut_Actif;
        contrleToInsert.add(controle4);
        
        insert contrleToInsert;
        
        list<Etiquette__c> listEtiquetteToInsert = new list<Etiquette__c>();
        Etiquette__c etq1 = Test_Utils.createEtiquette(foyer1.id, null, null, Date.Today(), Date.Today() + 2);
        etq1.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Raisons_Personnelles;
        listEtiquetteToInsert.add(etq1);
        
        Etiquette__c etq2 = Test_Utils.createEtiquette(foyer2.id, null, null, Date.Today(), Date.Today() + 2);
        etq2.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Refus_Temporaire_De_Participation;
        listEtiquetteToInsert.add(etq2);
        
        Etiquette__c etq3 = Test_Utils.createEtiquette(foyer3.id, null, null, Date.Today(), Date.Today() + 2);
        etq3.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Foyer_temoin;
        listEtiquetteToInsert.add(etq3);
        
        Etiquette__c etq4 = Test_Utils.createEtiquette(foyer3.id, null, null, Date.Today(), Date.Today() + 2);
        etq4.Nom_de_l_etiquette__c = Label.ETI_Nom_de_l_etiquette_Raisons_Personnelles;
        listEtiquetteToInsert.add(etq4);
        
        insert listEtiquetteToInsert;
        
        List<Etiquette__c> etiquetteToUpdate = new List<Etiquette__c>();
        Test.setCreatedDate(etq1.Id, Date.Today() - 6);
        etq1.Date_de_debut__c = Date.Today() - 5;
        etq1.Date_de_fin__c = Date.Today() - 1;
        etiquetteToUpdate.add(etq1);
        
        Test.setCreatedDate(etq2.Id, Date.Today() - 3);
        etq2.Date_de_debut__c = Date.Today() - 2;
        etq2.Date_de_fin__c = Date.Today() + 2;
        etiquetteToUpdate.add(etq2);
        
        Test.setCreatedDate(etq3.Id, Date.Today() - 11);
        etq3.Date_de_debut__c = Date.Today() - 10;
        etq3.Date_de_fin__c = Date.Today() - 3;
        etiquetteToUpdate.add(etq3);
        
        Test.setCreatedDate(etq4.Id, Date.Today() - 11);
        etq4.Date_de_debut__c = Date.Today() - 10;
        etq4.Date_de_fin__c = Date.Today() + 3;
        etiquetteToUpdate.add(etq4);
        
        update etiquetteToUpdate;
        
        Test.startTest();
        Batch013_CreationRequeteAIPNonRep btch = new Batch013_CreationRequeteAIPNonRep();
        database.executeBatch(btch);
        Test.stopTest();
        
        List<Case> requeteList =  [SELECT Id, Account.Id FROM Case];
        List<Controle__c> controleList =  [SELECT Id, Foyer__c, Requete__r.Id FROM Controle__c WHERE Foyer__r.Id = :foyer2.Id];
        
        System.debug('$$$requeteList: ' + requeteList);
        System.debug('$$$controle1: ' + controle1);
        
        //System.assertEquals(2, requeteList.size());
        //System.assertEquals(foyer2.id, requeteList[0].Account.Id);
        
        
    }
}