/*
* @date: 01/04/2022
* @ Description : test class qui test AP02_MembreDuFoyer qui appele API mulesoft Google 
                  pour envoi du contact à l'update 
* @ Condition : - suite changement du nom prénom
*               - suite changement de l'adresse mail
*               - suite changement de la date de naissance
*               - lorsque le champ Lettre__c de l'un des individu panéliste 
                  appartenant à la composition du foyer (contact) mis à jour est mis à jour

* @Auteur : Téoman Sertçelik
* @Coverage: 96 %
History
* <Date of modification> 		<Author> 			<Description of modification>
*/
@isTest
public with sharing class AP02_MembreDuFoyer_Test {

    @isTest
    public static void AP02_SendContactUpdated () {
        
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer; AP01_IndividuPaneliste;AP01_IndividuPaneliste;AP08_FoyerPaneliste;AP03_Individu_paneliste';
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){
            List<Account> listAccountToInsert = new List<Account>();
            List<Contact> listMembreFoyerToInsert = new List<Contact>();
            List<Individu_Paneliste__c> listIndToInsert = new List<Individu_Paneliste__c>();
            List<Foyer_paneliste__c> listFoyerPanToInsert = new List<Foyer_paneliste__c>();
            Id recordTypeIdFoyerPanelisteMMAT = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            List<Referentiel_Panel__c> listRefPanToInsert = new List<Referentiel_Panel__c>();
    
            Account acc1 = new Account();
            acc1.Name = 'Foyer1';
            acc1.ShippingPostalCode = '98222';
            acc1.ShippingState = 'France';
            acc1.ShippingCountry = 'PHUKET';
            acc1.ShippingStreet = 'toto';
            acc1.ShippingCity = 'paname';
            listAccountToInsert.add(acc1);
            insert listAccountToInsert;
        
            Contact cont1 = new Contact();
            cont1.FirstName = 'firstNameAno';
            cont1.LastName = 'lastNameAno';
            cont1.Type__c = Label.CON_Type_MEMBRE;
            cont1.Birthdate = date.newInstance(1993, 02, 25);
            cont1.Nombre_d_heures_travaillees__c=3;
            cont1.Date_d_entree_individu__c = Date.today();
            cont1.AccountId = acc1.Id;
            cont1.Lien_parente__c = '1';
            cont1.Tech_lettre_MAJ__c = 1;
            cont1.CSP42__c = 'test';
            cont1.CSP4__c = 'testt';
            cont1.MobilePhone='1234567891';
            cont1.Lien_de_parente_stat__c = '1';
            cont1.CON_ExtId_SIPanel__c = '122223456';
            cont1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            cont1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            cont1.Code_profession__c = 132;
            listMembreFoyerToInsert.add(cont1);
            insert listMembreFoyerToInsert;
           
            Referentiel_Panel__c refPan = new Referentiel_Panel__c();
            refPan.Name	= Label.RFP_TypePanel_PaME;
            refPan.Type_de_panel__c =  Label.REF_PANEL_TypePan_PAME;
            listRefPanToInsert.add(refPan);
            insert refPan;
            
    
            Foyer_paneliste__c fpMMAT1 = new Foyer_paneliste__c();
            fpMMAT1.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
            fpMMAT1.Name = 'FoyerPan1';
            fpMMAT1.Foyer__c = acc1.Id;
            fpMMAT1.Membre_du_foyer__c = cont1.Id;
            fpMMAT1.Referentiel_Panel__c = refPan.Id;
            fpMMAT1.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Integre;
            fpMMAT1.Date_de_creation__c = date.newInstance(2005, 02, 25);
            listFoyerPanToInsert.add(fpMMAT1);
            insert listFoyerPanToInsert;
    
    
            Individu_Paneliste__c ind1 = new Individu_Paneliste__c();
            ind1.Composition_du_foyer__c = cont1.Id;
            ind1.Foyer_paneliste__c = fpMMAT1.Id;
            ind1.Lettre__c = 'F';
            listIndToInsert.add(ind1);
            insert listIndToInsert;
    
            MembreFoyerCallout_Mock fakeSendCont = new MembreFoyerCallout_Mock(cont1.Id);
            Test.startTest();
            cont1.FirstName = 'updated';            
            update cont1;
            Test.setMock(HttpCalloutMock.class, fakeSendCont);
            Test.stopTest();
        }
    }
}