/*
* @Auteur : Téoman Sertçelik
* @date: 17/03/2022
* @Classe:  Batch020_AnonymisationConfirme
* @Coverage: 91 %
* * History
* <Date of modification>        <Author>            <Coverage>
*/
@isTest
public with sharing class Batch020_Eligibilite_Anonymisation_Test {

    @isTest
    public static void testBatch() {

        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMMAT = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        List <String> ExternalIds = new List <String>();
        List<Contact> listMembreFoyerToInsert = new List<Contact>();
        List<Foyer_paneliste__c> listFoyerPanToInsert = new List<Foyer_paneliste__c>();
        List<Individu_Paneliste__c> listIndToInsert = new List<Individu_Paneliste__c>();


        Account acc1 = new Account();
        acc1.Name = 'Foyer1';
        acc1.ShippingPostalCode = '98222';
        acc1.ShippingState = 'France';
        acc1.ShippingCountry = 'PHUKET';
        acc1.ShippingStreet = 'toto';
        acc1.ShippingCity = 'paname';
        insert acc1; 

        Contact ctToAno1 = new Contact();
        ctToAno1.A_anonymiser__c = true;
        ctToAno1.Date_d_anonymisation__c = null;
        ctToAno1.FirstName = 'firstNameAno';
        ctToAno1.LastName = 'lastNameAno';
        ctToAno1.Type__c = '1';
        ctToAno1.Birthdate = date.newInstance(1993, 02, 25);
        ctToAno1.Nombre_d_heures_travaillees__c=3;
        ctToAno1.Date_d_entree_individu__c = Date.today();
        ctToAno1.AccountId = acc1.Id;
        ctToAno1.Lien_parente__c = '1';
        ctToAno1.CSP42__c = 'test';
        ctToAno1.CSP4__c = 'testt';
        ctToAno1.MobilePhone='1234567891';
        ctToAno1.Lettre__c = 'A';
        ctToAno1.Lien_de_parente_stat__c = '1';
        ctToAno1.CON_ExtId_SIPanel__c = '122223456';
        ctToAno1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno1.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno1);
     
      
        Contact ctToAno2 = new Contact();
        ctToAno2.A_anonymiser__c = true;
        ctToAno2.Date_d_anonymisation__c = null;
        ctToAno2.FirstName = 'firstNameAno2';
        ctToAno2.LastName = 'lastNameAno2';
        ctToAno2.Type__c = '1';
        ctToAno2.Birthdate = Date.newInstance(1993, 02, 25);
        ctToAno2.Nombre_d_heures_travaillees__c=3;
        ctToAno2.Date_d_entree_individu__c = Date.today();
        ctToAno2.AccountId = acc1.Id;
        ctToAno2.Lien_parente__c = '1';
        ctToAno2.CSP42__c = 'test';
        ctToAno2.CSP4__c = 'testt';
        ctToAno2.MobilePhone='1234567891';
        ctToAno2.Lettre__c = 'A';
        ctToAno2.Lien_de_parente_stat__c = '1';
        ctToAno2.CON_ExtId_SIPanel__c = '123';
        ctToAno2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno2.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno2.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno2);
 

        Contact ctToAno3 = new Contact();
        ctToAno3.A_anonymiser__c = true;
        ctToAno3.Date_d_anonymisation__c = null;
        ctToAno3.FirstName = 'firstNameAno3';
        ctToAno3.LastName = 'lastNameAno3';
        ctToAno3.Type__c = '1';
        ctToAno3.Birthdate = date.newInstance(1993, 02, 25);
        ctToAno3.Nombre_d_heures_travaillees__c=3;
        ctToAno3.Date_d_entree_individu__c = Date.today();
        ctToAno3.AccountId = acc1.Id;
        ctToAno3.Lien_parente__c = '1';
        ctToAno3.CSP42__c = 'test';
        ctToAno3.CSP4__c = 'testt';
        ctToAno3.MobilePhone='1234567891';
        ctToAno3.Lettre__c = 'A';
        ctToAno3.Lien_de_parente_stat__c = '1';
        ctToAno3.CON_ExtId_SIPanel__c = '1234';
        ctToAno3.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno3.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno3.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno3);
    

        Contact ctToAno4 = new Contact();
        ctToAno4.A_anonymiser__c = true;
        ctToAno4.Date_d_anonymisation__c = null;
        ctToAno4.FirstName = 'firstNameAno';
        ctToAno4.LastName = 'lastNameAno';
        ctToAno4.Type__c = '1';
        ctToAno4.Birthdate = date.newInstance(1993, 02, 25);
        ctToAno4.Nombre_d_heures_travaillees__c=3;
        ctToAno4.Date_d_entree_individu__c = Date.today();
        ctToAno4.AccountId = acc1.Id;
        ctToAno4.Lien_parente__c = '1';
        ctToAno4.CSP42__c = 'test';
        ctToAno4.CSP4__c = 'testt';
        ctToAno4.MobilePhone='1234567891';
        ctToAno4.Lettre__c = 'A';
        ctToAno4.Lien_de_parente_stat__c = '1';
        ctToAno4.CON_ExtId_SIPanel__c = '123456';
        ctToAno4.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno4.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno4.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno4);
     

        Contact ctToAno5 = new Contact();
        ctToAno5.A_anonymiser__c = true;
        ctToAno5.Date_d_anonymisation__c = null;
        ctToAno5.FirstName = 'firstNameAno2';
        ctToAno5.LastName = 'lastNameAno2';
        ctToAno5.Type__c = '1';
        ctToAno5.Birthdate = Date.newInstance(1993, 02, 25);
        ctToAno5.Nombre_d_heures_travaillees__c=3;
        ctToAno5.Date_d_entree_individu__c = Date.today();
        ctToAno5.AccountId = acc1.Id;
        ctToAno5.Lien_parente__c = '1';
        ctToAno5.CSP42__c = 'test';
        ctToAno5.CSP4__c = 'testt';
        ctToAno5.MobilePhone='1234567891';
        ctToAno5.Lettre__c = 'A';
        ctToAno5.Lien_de_parente_stat__c = '1';
        ctToAno5.CON_ExtId_SIPanel__c = '1234567';
        ctToAno5.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno5.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno5.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno5);
     

        Contact ctToAno6 = new Contact();
        ctToAno6.A_anonymiser__c = true;
        ctToAno6.Date_d_anonymisation__c = null;
        ctToAno6.FirstName = 'firstNameAno2';
        ctToAno6.LastName = 'lastNameAno2';
        ctToAno6.Type__c = '1';
        ctToAno6.Birthdate = date.newInstance(1993, 02, 25);
        ctToAno6.Nombre_d_heures_travaillees__c=3;
        ctToAno6.Date_d_entree_individu__c = Date.today();
        ctToAno6.AccountId = acc1.Id;
        ctToAno6.Lien_parente__c = '1';
        ctToAno6.CSP42__c = 'test';
        ctToAno6.CSP4__c = 'testt';
        ctToAno6.MobilePhone='1234567891';
        ctToAno6.Lettre__c = 'A';
        ctToAno6.Lien_de_parente_stat__c = '1';
        ctToAno6.CON_ExtId_SIPanel__c = '12345678';
        ctToAno6.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        ctToAno6.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        ctToAno6.Code_profession__c = 132;
        listMembreFoyerToInsert.add(ctToAno6);
        insert listMembreFoyerToInsert;

        ExternalIds.add(ctToAno1.id);
        ctToAno1.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno1;
        ExternalIds.add(ctToAno2.id);
        ctToAno2.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno2;
        ExternalIds.add(ctToAno3.id);
        ctToAno3.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno3;
        ExternalIds.add(ctToAno4.id);
        ctToAno4.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno4;
        ExternalIds.add(ctToAno5.id);
        ctToAno5.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno5;        
        ExternalIds.add(ctToAno6.id);
        ctToAno6.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
        update ctToAno6;
        
        Referentiel_Panel__c refPan = new Referentiel_Panel__c();
        refPan.Name = Label.RFP_Nom_AIP;  //MD
        refPan.Type_de_panel__c =  Label.RFP_TypePanel_AIP;
        insert refPan;
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = Label.RFP_Nom_MMAT; 
        refPanMMAT.Type_de_panel__c =  Label.RFP_TypePanel_MMAT;
        insert refPanMMAT; 
        
        Referentiel_Panel__c refPanPAME = new Referentiel_Panel__c(); 
        refPanPAME.Name = Label.RFP_Nom_PaME;
        refPanPAME.Type_de_panel__c = Label.RFP_TypePanel_PaME;  
        insert refPanPAME;       
        
        Foyer_paneliste__c fpAIP1 = new Foyer_paneliste__c();
        fpAIP1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        fpAIP1.Referentiel_Panel__c = refPan.Id;
        fpAIP1.Name = 'FoyerPan1';
        fpAIP1.Foyer__c = acc1.Id;
        fpAIP1.Membre_du_foyer__c = ctToAno1.Id;
        fpAIP1.Panel_ExtId_SIPanel__c = null;
        fpAIP1.Date_d_anonymisation__c = null;
        fpAIP1.A_anonymiser__c = false;  
        fpAIP1.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Integre; 
        fpAIP1.Date_de_creation__c = date.newInstance(2022, 02, 25); 
        fpAIP1.Foyer_Paneliste_ExtId_SIPanel__c = '2450';
        listFoyerPanToInsert.add(fpAIP1);

        Foyer_paneliste__c fpAIP2 = new Foyer_paneliste__c();
        fpAIP2.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        fpAIP2.Referentiel_Panel__c = refPan.Id;
        fpAIP2.Name = 'FoyerPan2';
        fpAIP2.Foyer__c = acc1.Id;
        fpAIP2.Membre_du_foyer__c = ctToAno2.Id;
        fpAIP2.Date_d_anonymisation__c = null;
        fpAIP2.A_anonymiser__c = false;        
        fpAIP2.Date_de_creation__c = date.newInstance(2021, 02, 25);
        fpAIP2.Panel_ExtId_SIPanel__c = '1234';
        fpAIP2.Foyer_Paneliste_ExtId_SIPanel__c = '3456';
        fpAIP2.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Integre; 
        listFoyerPanToInsert.add(fpAIP2);

        Foyer_paneliste__c fpAIP3 = new Foyer_paneliste__c();
        fpAIP3.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        fpAIP3.Referentiel_Panel__c = refPan.Id;
        fpAIP3.Name = 'FoyerPan3';
        fpAIP3.Foyer__c = acc1.Id;
        fpAIP3.Membre_du_foyer__c = ctToAno3.Id;
        fpAIP3.A_anonymiser__c = false;
        fpAIP3.Foyer_Paneliste_ExtId_SIPanel__c = '123456'; 
        fpAIP3.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Chute_definitive;
        fpAIP3.Date_de_chute_temporaire__c = date.newInstance(2021, 02, 27);    //MD         
        listFoyerPanToInsert.add(fpAIP3);
        
        Foyer_paneliste__c fpMMAT1 = new Foyer_paneliste__c();
        fpMMAT1.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
        fpMMAT1.Referentiel_Panel__c = refPanMMAT.Id;
        fpMMAT1.Name = 'FoyerPan4';
        fpMMAT1.A_anonymiser__c = false;  //MD
        fpMMAT1.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Integre; //MD
        fpMMAT1.Foyer__c = acc1.Id;
        fpMMAT1.Membre_du_foyer__c = ctToAno4.Id;
        fpMMAT1.Panel_ExtId_SIPanel__c = null;
        fpMMAT1.Date_d_anonymisation__c = null;
        fpMMAT1.Date_de_creation__c = date.newInstance(2021, 02, 25);  //MD 
        fpMMAT1.Foyer_Paneliste_ExtId_SIPanel__c = '23459';
        listFoyerPanToInsert.add(fpMMAT1);

        Foyer_paneliste__c fpMMAT2 = new Foyer_paneliste__c();
        fpMMAT2.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
        fpMMAT2.Referentiel_Panel__c = refPanMMAT.Id;
        fpMMAT2.Name = 'FoyerPan5';
        fpMMAT2.Foyer__c = acc1.Id;
        fpMMAT2.Membre_du_foyer__c = ctToAno5.Id;
        fpMMAT2.Date_d_anonymisation__c = null;
        fpMMAT2.A_anonymiser__c = false;   //MD
        fpMMAT2.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Integre; 
        fpMMAT2.Date_de_creation__c = date.newInstance(2022, 02, 25);  //MD
        fpMMAT2.Foyer_Paneliste_ExtId_SIPanel__c = '23456';
        listFoyerPanToInsert.add(fpMMAT2);
       
        
        Foyer_paneliste__c fpMMAT3 = new Foyer_paneliste__c();
        fpMMAT3.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
        fpMMAT3.Referentiel_Panel__c = refPanPAME.Id;
        fpMMAT3.Name = 'FoyerPan6';
        fpMMAT3.Foyer__c = acc1.Id;
        fpMMAT3.Membre_du_foyer__c = ctToAno6.Id;
        fpMMAT3.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Chute_definitive;
        fpMMAT3.Foyer_Paneliste_ExtId_SIPanel__c = '78356';
        fpMMAT3.Date_de_chute_temporaire__c = date.newInstance(2021, 02, 25);    //MD
        listFoyerPanToInsert.add(fpMMAT3);
        insert listFoyerPanToInsert;
        

        /*Individu_Paneliste__c ind1 = new Individu_Paneliste__c();
        ind1.Foyer_paneliste__c = fpAIP1.Id;
        ind1.Composition_du_foyer__c = ctToAno1.Id;
        ind1.Lettre__c = 'F';
        ind1.Date_d_anonymisation__c = null;
        listIndToInsert.add(ind1);
        insert listIndToInsert;*/

        /* Foyer_paneliste__c fpMMAT = new Foyer_paneliste__c();
        fpMMAT.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
        fpMMAT.Name = 'FoyerPan4';
        fpMMAT.Foyer__c = acc1.Id;
        insert fpMMAT; */

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno1.CON_ExtId_SIPanel__c));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno2.CON_ExtId_SIPanel__c));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno3.CON_ExtId_SIPanel__c));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno4.CON_ExtId_SIPanel__c));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno5.CON_ExtId_SIPanel__c));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno6.CON_ExtId_SIPanel__c));
        Batch020_Eligibilite_Anonymisation ano = new Batch020_Eligibilite_Anonymisation();
        Id batchId = Database.executeBatch(ano);
        Test.stopTest();


    }
}