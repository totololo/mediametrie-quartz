/*
* @Auteur : Jérôme HE EIT
* @date: 29/01/2022
* @Classe: Batch017_InstallControlesSoftMeters
* @Coverage: 94%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
* 31-1-2023                      Mikael 					Adaptaion au chagement 
*/
@isTest
public class Batch017_InstallControlesSoftMeters_test {
    
    
    @isTest 
    static void testBatch17NonCreationRequeteReqNonRep() {
        
                
        List<Account> 				  foyerToInsert 			= new List<Account>();
        List<Referentiel_Panel__c>    refPanToInsert			= new List<Referentiel_Panel__c>();
        List<Foyer_paneliste__c>      foyerPanToInsert   		= new List<Foyer_paneliste__c>();
        List<Contact> 				  contactToInsert			= new List<Contact>();
        List<Individu_Paneliste__c>   indPanToInsert  			= new List<Individu_Paneliste__c>();
        List<Asset> 				  assetToInsert		 		= new List<Asset>();
        List<Case>					  caseToInsert				= new List<Case>();
        List<Equipements_du_foyer__c> eqfToInsert				= new List<Equipements_du_foyer__c>();
        List<Equipement_du_foyer_de_l_individu__c> eqtIndToInsert = new List<Equipement_du_foyer_de_l_individu__c>();
        
        List <String> ExternalIds = new List <String>();

        Id recordTypeIdFoyerPanMMPaME  = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdRequeteControle = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();
        Id recordTypeIdEquipementDuFoyerDevice = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();

        Account foyerTest = new Account();
        foyerTest.Name = 'foyerTest';
        foyerToInsert.add(foyerTest);
        insert foyerToInsert;

        Referentiel_Panel__c refPanTest = new Referentiel_Panel__c();
        refPanTest.Type_de_panel__c 	= Label.RFP_TypePanel_PaME;
        refPanTest.Name					= Label.RFP_Nom_PaME;
        refPanToInsert.add(refPanTest);
        insert refPanToInsert;
        
        Foyer_paneliste__c foyerPanTest     = new Foyer_paneliste__c();
        foyerPanTest.foyer__c				= foyerTest.id;
        foyerPanTest.Referentiel_Panel__c = refPanTest.id;
        foyerPanTest.Name = 'foyerPanTest';
        //foyerPanTest.Statut_Foyer_paneliste__c	='4';
        foyerPanTest.RecordTypeId = recordTypeIdFoyerPanMMPaME;
        foyerPanToInsert.add(foyerPanTest);
        insert foyerPanToInsert;
        
        Contact compoFoyerTest = new Contact();
        compoFoyerTest.AccountId = foyerTest.id;
        compoFoyerTest.Lastname = 'compoFoyer1';
        compoFoyerTest.FirstName='cc';
        compoFoyerTest.Type__c = Label.CON_Type_MEMBRE;
        compoFoyerTest.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyerTest.Birthdate = date.today().addDays(- 10000);
        compoFoyerTest.Frequence_de_connexion_mobile__c=label.Acc_Freq_Conx_Mobile_PresqueTousLesJours;
        compoFoyerTest.Frequence_de_connexion_ordinateur__c=label.Acc_Freq_Conx_Ordi_TousLesJours;
        compoFoyerTest.Frequence_de_connexion_tablette__c=label.Acc_Freq_Conx_Tablette_TousLesJours;
        contactToInsert.add(compoFoyerTest);
        
        Contact compoFoyerTest2 = new Contact();
        compoFoyerTest2.AccountId = foyerTest.id;
        compoFoyerTest2.Lastname = 'compoFoyerTest2';
        compoFoyerTest2.FirstName='cc';
        compoFoyerTest2.Type__c = Label.CON_Type_MEMBRE;
        compoFoyerTest2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyerTest2.Birthdate = date.today().addDays(- 10000);
        compoFoyerTest2.Frequence_de_connexion_mobile__c=label.Acc_Freq_Conx_Mobile_PresqueTousLesJours;
        compoFoyerTest2.Frequence_de_connexion_ordinateur__c=label.Acc_Freq_Conx_Ordi_TousLesJours;
        compoFoyerTest2.Frequence_de_connexion_tablette__c=label.Acc_Freq_Conx_Tablette_TousLesJours;
        contactToInsert.add(compoFoyerTest2);
        
        Contact compoFoyerTest3 = new Contact();
        compoFoyerTest3.AccountId = foyerTest.id;
        compoFoyerTest3.Lastname = 'compoFoyerTest3';
        compoFoyerTest3.FirstName='cc';
        compoFoyerTest3.Type__c = Label.CON_Type_MEMBRE;
        compoFoyerTest3.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyerTest3.Birthdate = date.today().addDays(- 10000);
        compoFoyerTest3.Frequence_de_connexion_mobile__c=label.Acc_Freq_Conx_Mobile_PresqueTousLesJours;
        compoFoyerTest3.Frequence_de_connexion_ordinateur__c=label.Acc_Freq_Conx_Ordi_TousLesJours;
        compoFoyerTest3.Frequence_de_connexion_tablette__c=label.Acc_Freq_Conx_Tablette_TousLesJours;
        contactToInsert.add(compoFoyerTest3);
        
        insert compoFoyerTest;
        insert compoFoyerTest2;
        insert compoFoyerTest3;
        
        Individu_Paneliste__c indPanTest = new Individu_Paneliste__c();
        indPanTest.name = 'indPanTest';
        indPanTest.Lettre__c = 'D';
        indPanTest.Date_de_derniere_activite_mobile__c  = date.today()-2;
        indPanTest.Foyer_paneliste__c = foyerPanTest.id;
        indPanTest.Composition_du_foyer__c = compoFoyerTest.id;
        indPanToInsert.add(indPanTest);
        
        Individu_Paneliste__c indPanTest2 = new Individu_Paneliste__c();
        indPanTest2.name = 'indPanTest2';
        indPanTest2.Lettre__c = 'E';
        indPanTest2.Date_de_derniere_activite_browser__c = date.today()-2;
        indPanTest2.Foyer_paneliste__c = foyerPanTest.id;
        indPanTest2.Composition_du_foyer__c = compoFoyerTest2.id;
        indPanToInsert.add(indPanTest2);
        
        Individu_Paneliste__c indPanTest3 = new Individu_Paneliste__c();
        indPanTest3.name = 'indPanTest3';
        indPanTest3.Lettre__c = 'F';
        indPanTest3.Date_de_derniere_activite_browser__c = date.today()-2;
        indPanTest3.Date_de_derniere_activite_mobile__c  = date.today()-2;
        indPanTest3.Foyer_paneliste__c = foyerPanTest.id;
        indPanTest3.Composition_du_foyer__c = compoFoyerTest3.id;
        indPanToInsert.add(indPanTest3);
        
        insert indPanToInsert;

        Equipements_du_foyer__c eqf1 = new Equipements_du_foyer__c();
        eqf1.RecordTypeId = recordTypeIdEquipementDuFoyerDevice;
        eqf1.foyer__c= foyerTest.id;
        eqf1.Type__c = Label.EQF_Type_Smartphone;
        eqf1.Utilisateur_principal__c = compoFoyerTest.id;
        eqfToInsert.add(eqf1);

        Equipements_du_foyer__c eqf2= new Equipements_du_foyer__c();
        eqf2.RecordTypeId = recordTypeIdEquipementDuFoyerDevice;
        eqf2.foyer__c= foyerTest.id;
        eqf2.Type__c = Label.EQF_Type_Tablette;
        eqf2.Utilisateur_principal__c = compoFoyerTest3.id;
        eqfToInsert.add(eqf2);

        Equipements_du_foyer__c eqf3= new Equipements_du_foyer__c();
        eqf3.RecordTypeId = recordTypeIdEquipementDuFoyerDevice;
        eqf3.foyer__c = foyerTest.id;
        eqf3.Type__c = Label.EQF_Type_OrdinateurPortable;
        eqf3.Utilisateur_principal__c = compoFoyerTest2.id;
        eqfToInsert.add(eqf3);

        insert eqfToInsert;        
        
        /*Equipement_du_foyer_de_l_individu__c eqtInd1 = new Equipement_du_foyer_de_l_individu__c();
        eqtInd1.Composition_du_foyer__c = compoFoyerTest.id;
        eqtInd1.Equipement_du_foyer__c = eqf1.id;
        eqtInd1.Utilisation_de_l_equipement__c = 'Oui';
        eqtIndToInsert.add(eqtInd1);
        
        Equipement_du_foyer_de_l_individu__c eqtInd2 = new Equipement_du_foyer_de_l_individu__c();
        eqtInd2.Composition_du_foyer__c = compoFoyerTest2.id;
        eqtInd2.Equipement_du_foyer__c = eqf3.id;
        eqtInd2.Utilisation_de_l_equipement__c = 'Oui';
        eqtIndToInsert.add(eqtInd2);
        
        Equipement_du_foyer_de_l_individu__c eqtInd3 = new Equipement_du_foyer_de_l_individu__c();
        eqtInd3.Composition_du_foyer__c = compoFoyerTest3.id;
        eqtInd3.Equipement_du_foyer__c = eqf2.id;
        eqtInd3.Utilisation_de_l_equipement__c = 'Oui';
        eqtIndToInsert.add(eqtInd3);
        
        Equipement_du_foyer_de_l_individu__c eqtInd4 = new Equipement_du_foyer_de_l_individu__c();
        eqtInd4.Composition_du_foyer__c = compoFoyerTest3.id;
        eqtInd4.Equipement_du_foyer__c = eqf3.id;
        eqtInd4.Utilisation_de_l_equipement__c = 'Oui';
        eqtIndToInsert.add(eqtInd4);
        
        insert eqtIndToInsert;*/
    
        Case caseTest70 = new Case();
        caseTest70.foyer_paneliste__c = foyerPanTest.id;
        caseTest70.AccountId		  = foyerTest.id;
        caseTest70.RecordTypeId		  = recordTypeIdRequeteControle;
        caseTest70.type=label.CAS_Type_Inactif_Meter_J_1;
        caseToInsert.add(caseTest70);
        
        Case caseTest90 = new Case();
        caseTest90.foyer_paneliste__c = foyerPanTest.id;
        caseTest90.AccountId		  = foyerTest.id;
        caseTest90.RecordTypeId		  = recordTypeIdRequeteControle;
        caseTest90.type=label.CAS_Type_Inactif_Meter_J_1;
        caseToInsert.add(caseTest90); 
        
        insert caseToInsert;
        
		Test.setCreatedDate(caseTest70.id, Date.Today() - 69);
        Test.setCreatedDate(caseTest90.id, Date.Today() - 89);
        
        System.debug('c.Jour_de_traitement__c');
		List<Case> caseTest=[SELECT id,Jour_de_traitement__c FROM CASE];
        for (Case c:caseTest) {
            System.debug('c.Jour_de_traitement__c: ' + c.Jour_de_traitement__c);
        }
        
        //System.debug(caseTest);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyerTest.Id));
        //AP01_MembreDuFoyer.getContactFromSipanel(ExternalIds); 
        Batch017_InstallControlesSoftMeters batch = new Batch017_InstallControlesSoftMeters();
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        
        List<Case> caseListToTest = [Select id from Case];
        List<Task> tastListToTest = [Select id from Task];
        
        //System.assertEquals(4, caseListToTest.size());
        //System.assertEquals(1, tastListToTest.size());
    }
    
}