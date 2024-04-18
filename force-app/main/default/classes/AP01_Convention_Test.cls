/*
* @date: 25/03/2022
* @ Description : test class : appeler API mulesoft pour envoi de la convention à l'insert et l'update 
* @ Condition : - individu fait partie de la compo foyer où il est membre
*               - le foyer panéliste auquel l'individu appartient et le référentiel panel du foyer pan est de type pame
*               - que la (dernière) convention est rattachée à la dernière version de référentiel convention 
                  et que celle ci est signé et actif
* @Auteur : Téoman Sertçelik
* @Class: AP01_Convention
* @Coverage: 98 %
History
* <Date of modification> 		<Author> 			<Description of modification>
*/

@isTest
public with sharing class AP01_Convention_Test  {


    @isTest
    static void AP01_SendConvUpdate() {
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer; AP01_IndividuPaneliste;AP01_IndividuPaneliste;AP08_FoyerPaneliste';
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){

            List <String> listConventionIds = new List <String>();
    
            Id recordTypeIdFoyerPanelisteMMAT = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            List<Account> listAccountToInsert = new List<Account>();
            List<Contact> listMembreFoyerToInsert = new List<Contact>();
            List<Foyer_paneliste__c> listFoyerPanToInsert = new List<Foyer_paneliste__c>();
            List<Individu_Paneliste__c> listIndToInsert = new List<Individu_Paneliste__c>();
            List<Convention__c> listConvToInsert = new List<Convention__c>();
            List<Referentiel_convention__c> listRefConvToInsert = new List<Referentiel_convention__c>();
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
            cont1.CSP42__c = 'test';
            cont1.CSP4__c = 'testt';
            cont1.MobilePhone='1234567891';
            cont1.Lettre__c = 'A';
            cont1.Lien_de_parente_stat__c = '1';
            cont1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            cont1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            cont1.Code_profession__c = 132;
            listMembreFoyerToInsert.add(cont1);
            insert listMembreFoyerToInsert;
    
            Referentiel_Panel__c refPan = new Referentiel_Panel__c();
            refPan.Name	= Label.RFP_Nom_PaME;
            refPan.Type_de_panel__c =  Label.RFP_TypePanel_PaME;
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
            
    
            Referentiel_convention__c refConv = new Referentiel_convention__c();
            refConv.Name = 'refConv1';
            refConv.Referentiel_Panel__c = refPan.Id;
            refConv.Date_de_debut__c  = date.newInstance(2005, 02, 22);
            refConv.Date_de_fin__c = system.today();
            refConv.CreatedDate = date.newInstance(2005, 02, 22);
            refConv.Version__c = '35';
            listRefConvToInsert.add(refConv); 
            insert listRefConvToInsert;
        
    
            Individu_Paneliste__c ind1 = new Individu_Paneliste__c();
            ind1.Composition_du_foyer__c = cont1.Id;
            ind1.Foyer_paneliste__c = fpMMAT1.Id;
            ind1.Lettre__c = 'F';
            listIndToInsert.add(ind1);
            insert listIndToInsert;
    
            Convention__c conv1 = new Convention__c(); 
            conv1.Individu_Paneliste__c = ind1.Id;
            conv1.Composition_du_foyer__c = cont1.Id;
            conv1.Referentiel_convention__c = refConv.Id;
            conv1.Foyer_paneliste__c = fpMMAT1.Id;
            conv1.Foyer__c = acc1.Id;
            conv1.Date_de_signature_de_la_convention__c = date.newInstance(1993, 02, 25);
            listConvToInsert.add(conv1);
            insert listConvToInsert;
        
            listConventionIds.add(conv1.Id);
          
            MembreFoyerCallout_Mock fakeSendConv = new MembreFoyerCallout_Mock(conv1.Id);
            Test.startTest(); 
            Test.setMock(HttpCalloutMock.class, fakeSendConv);
            Test.stopTest();
    
        }
    }
}