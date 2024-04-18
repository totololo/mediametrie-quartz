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

public class AP10_FoyerPaneliste_Test {
    @isTest static void testUpdateIndividuPan() {
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
        foyer.Name = 'Test AP10';
        insert foyer;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelistePaME = new Foyer_Paneliste__c();
        foyerPanelistePaME.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelistePaME.Name = 'FP MMAT';
        foyerPanelistePaME.Foyer__c = foyer.Id;
        foyerPanelistePaME.Foyer_equipe__c = true;
        foyerPanelistePaME.Referentiel_Panel__c = refPanPaME.Id;
        foyerPanelisteToInsert.add(foyerPanelistePaME);
        
        
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
        indPanTest.Foyer_paneliste__c = foyerPanelistePaME.id;
        indPanTest.Composition_du_foyer__c = cont.id;
        indPanTest.Date_de_chute_de_l_individu__c = null;
        insert indPanTest;
        
        System.debug('$$$Update');
        foyerPanelistePaME.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe; 
        foyerPanelistePaME.Type_d_intervention__c = Label.WOR_Type_d_intervention_Installation;
        foyerPanelistePaME.Date_d_installation__c = Date.today();
            
        update foyerPanelistePaME;
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelistePaME.id));
        Test.stopTest();
    }
}