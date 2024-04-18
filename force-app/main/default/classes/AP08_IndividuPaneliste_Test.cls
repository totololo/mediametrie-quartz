/*
* @author: Bastien Pinard
* @date: 25/11/2022
* @ Description 
* @Coverage: 
* History
* Date of modification :
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest 

public class AP08_IndividuPaneliste_Test {
    @isTest static void testInsertIndividuPan() {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.Name = 'PaME';
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        referentielPanelToInsert.add(refPanPaME);
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
        
        Account foyer = new Account();
        foyer.Name = 'Test AP08';
        insert foyer;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = foyer.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        //foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanPaME.Id;
        foyerPanelisteMMAT.Identifiant_foyer_pame__c = 	74445;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c =label.PAN_Statut_Panel_Equipe;
        foyerPanelisteMMAT.Date_d_integration__c = date.today();
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);

        
        insert foyerPanelisteToInsert;
        
            list<Contact> listMembreFoyerToInsert = new list<Contact>();

        Contact Cont = Test_Utils.createMembreFoyer(foyer.id); 
            Cont.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            Cont.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            Cont.Code_profession__c = 132;
            listMembreFoyerToInsert.add(Cont);       
            insert listMembreFoyerToInsert; 
        
         Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
            indPanTest.name = 'indPanTest';
            indPanTest.Lettre__c = 'B';
            indPanTest.Foyer_paneliste__c = foyerPanelisteToInsert[0].id;
            indPanTest.Composition_du_foyer__c = cont.id;
            indPanTest.Date_de_chute_de_l_individu__c = null;
            insert indPanTest;
        
        Set<Id> IdList = new Set<Id>();
        for(Foyer_Paneliste__c pan : foyerPanelisteToInsert){
            pan.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Equipe;
            pan.Date_d_integration__c = date.today();
            IdList.add(pan.Id);
        }
        
        update foyerPanelisteToInsert;
    
         Individu_Paneliste__c indPantest2 = new Individu_Paneliste__c();
            indPantest2.name = 'indPanTest2';
            indPantest2.Lettre__c = 'C';
            indPantest2.Foyer_paneliste__c = foyerPanelisteToInsert[0].id;
            indPantest2.Composition_du_foyer__c = cont.id;
            indPantest2.Date_de_chute_de_l_individu__c = null;
            insert indPantest2;
        
        
        List<Individu_Paneliste__c> indiPanInserted = [SELECT Id, Name
                                                          FROM Individu_Paneliste__c
                                                          WHERE Id =:indPantest2.Id
                                                          ];
        
        System.assertNotEquals(indiPanInserted[0].Name, 'indPanTest');
        
        
               Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteMMAT.id));
        Test.stopTest();
    }
}