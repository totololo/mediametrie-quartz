/*
* @Auteur : Téoman Sertçelik
* @date: 17/03/2022
* @Classe:  Batch019_CompositionFoyerAnonymisation
* @Coverage: 100 %
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*08/04/2022                      Téoman Sertçelik   Fix the test to pass following realized apex triggers / flows validation on insert + update 
                                                    Modification on equipement du foyer : implementation of a many to many relationship beetwen contact && equipement du foyer
                                                    with junction object Equipement_du_foyer_de_l_individu__c
*/
 @isTest
public with sharing class Batch019_CompositionFoyerAno_Test {
    
    @isTest
    public static void testBatch() {

        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdEquipementFoyer = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQF_RecodType_Device).getRecordTypeId();
        Id recordTypeIdCaseDemandeAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List <String> ExternalIds = new List <String>();
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer;AP01_IndividuPaneliste';
        update u;
        
        System.runAs(u){
            Account acc1 = new Account();
            acc1.Name = 'Foyer1';
            insert acc1; 

            Referentiel_Panel__c refPan = new Referentiel_Panel__c();
            refPan.Name	= Label.RFP_Nom_AIP;
            refPan.Type_de_panel__c =  Label.RFP_TypePanel_AIP;
            insert refPan;
            
            Foyer_paneliste__c fp1 = new Foyer_paneliste__c();
            fp1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
            fp1.Name = 'FoyerPan1';
            fp1.Referentiel_Panel__c = refPan.Id;
            fp1.Foyer_equipe__c = true;
            fp1.Foyer__c = acc1.Id;
            insert fp1;

            
            Contact ctToAno = new Contact();
            ctToAno.A_anonymiser__c = true;
            ctToAno.Date_d_anonymisation__c = null;
            ctToAno.FirstName = 'firstNameAno';
            ctToAno.LastName = 'lastNameAno';
            ctToAno.Type__c = '1';
            ctToAno.Birthdate = date.newInstance(1993, 02, 25);
            ctToAno.Nombre_d_heures_travaillees__c=3;
            ctToAno.Date_d_entree_individu__c = Date.today();
            ctToAno.AccountId = acc1.Id;
            ctToAno.Lien_parente__c = '1';
            ctToAno.CSP42__c = 'test';
            ctToAno.CSP4__c = 'testt';
            ctToAno.MobilePhone='1234567891';
            ctToAno.Lettre__c = 'A';
            ctToAno.Lien_de_parente_stat__c = '1';
            ctToAno.CON_ExtId_SIPanel__c = '122223456';
            ctToAno.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            ctToAno.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            ctToAno.Code_profession__c = 132;
            listMembreFoyerToInsert.add(ctToAno);
            insert listMembreFoyerToInsert;
            ExternalIds.add(ctToAno.id);
            ctToAno.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
            update ctToAno;

            Equipements_du_foyer__c equipFoyer1 = new Equipements_du_foyer__c();
            equipFoyer1.RecordTypeId = recordTypeIdEquipementFoyer;
            //equipFoyer1.Utilisateur_principal__c  = ctToAno.Id;
            equipFoyer1.Name = 'equipmt1';
            insert equipFoyer1;

            Equipement_du_foyer_de_l_individu__c eqFoyerInd = new Equipement_du_foyer_de_l_individu__c();
            eqFoyerInd.Equipement_du_foyer__c = equipFoyer1.Id;
            eqFoyerInd.Composition_du_foyer__c = ctToAno.Id;
            insert eqFoyerInd;

            Case cs  = new Case();
            cs.RecordTypeId = recordTypeIdCaseDemandeAIP;
            //cs.ContactId = ctToAno.Id;
            cs.Contact_sur_place__c = ctToAno.Id;
            cs.Origin = 'Appel Entrant';
            cs.Status = 'Nouveau';
            cs.AccountId = acc1.Id;
            cs.Foyer_paneliste__c = fp1.Id;
            insert cs;

            Individu_Paneliste__c ind1 = new Individu_Paneliste__c();
            ind1.Foyer_paneliste__c = fp1.Id;
            ind1.Composition_du_foyer__c = ctToAno.Id;
            ind1.Lettre__c = 'F';
            insert ind1;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(ctToAno.CON_ExtId_SIPanel__c));
            Batch019_CompositionFoyerAnonymisation ano = new Batch019_CompositionFoyerAnonymisation();
            Id batchId = Database.executeBatch(ano);
            Test.stopTest();
            
            List<Contact> testContact = [select id , Date_d_anonymisation__c from Contact where Date_d_anonymisation__c != null];
            System.assertEquals(1, testContact.size() ); 
           /*  List<Equipement_du_foyer_de_l_individu__c> testEqmtFoyerInd = [select id , Date_d_anonymisation__c from Equipement_du_foyer_de_l_individu__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testEqmtFoyerInd.size() );  */
            List<Equipements_du_foyer__c> testEqmtFoyer = [select id , Date_d_anonymisation__c from Equipements_du_foyer__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testEqmtFoyer.size() ); 
            List<Case> testCase = [select id , Date_d_anonymisation__c from Case where Date_d_anonymisation__c != null];
            //System.assertEquals(1, testCase.size() ); 
            List<Individu_Paneliste__c> testIndividuPan = [select id , Date_d_anonymisation__c from Individu_Paneliste__c where Date_d_anonymisation__c != null];
            System.assertEquals(1, testIndividuPan.size() ); 
        }
    }
}