/*
* @author: Claire VEHRLE
* @date: 23/03/2022
* @ Description Class that test AP04_IndividuPaneliste  
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest
public class AP04_IndividuPaneliste_Test {

    public static testMethod void pasChuteIndividuPaneliste() {
        
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        List<Account> foyerListToInsert = new List<Account>();
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerListToInsert.add(Foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'foyer2';
        foyer2.Types_de_Panel__c = 'MMT';
        foyerListToInsert.add(foyer2);
        
        Account foyer3 = new Account();
        foyer3.Name = 'foyer3';
        foyerListToInsert.add(foyer3);
        
        insert foyerListToInsert;
        
        List<Contact> contactToInsertList = new List<Contact>();
        Contact compoFoyer1 = new Contact();
        compoFoyer1.AccountId = Foyer1.Id;
        compoFoyer1.LastName = 'Composition';
        compoFoyer1.FirstName = 'Foyer 1';
        compoFoyer1.Birthdate = Date.today();
        compoFoyer1.CSP4__c = '1';
        compoFoyer1.CSP42__c = '3';
        compoFoyer1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer1.Type__c = Label.CON_Type_Invite;
        compoFoyer1.Contact_principal__c = true;
        compoFoyer1.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        contactToInsertList.add(compoFoyer1);
        
        Contact compoFoyer2 = new Contact();
        compoFoyer2.AccountId = Foyer2.Id;
        compoFoyer2.LastName = 'Composition';
        compoFoyer2.FirstName = 'Foyer 2';
        compoFoyer2.Birthdate = Date.today();
        compoFoyer2.CSP4__c = '1';
        compoFoyer2.CSP42__c = '3';
        compoFoyer2.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer2.Type__c = Label.CON_Type_Invite;
        compoFoyer2.Contact_principal__c = true;
        compoFoyer2.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        contactToInsertList.add(compoFoyer2);
        
        Contact compoFoyer3 = new Contact();
        compoFoyer3.AccountId = Foyer3.Id;
        compoFoyer3.LastName = 'Composition';
        compoFoyer3.FirstName = 'Foyer 3';
        compoFoyer3.Birthdate = Date.today();
        compoFoyer3.CSP4__c = '1';
        compoFoyer3.CSP42__c = '3';
        compoFoyer3.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer3.Type__c = Label.CON_Type_Invite;
        compoFoyer3.Contact_principal__c = false;
        compoFoyer3.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        contactToInsertList.add(compoFoyer3);
        
        insert contactToInsertList;
        
        List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanelPaME = Test_Utils.createRefPanel(Label.RFP_TypePanel_PaME, Label.RFP_TypePanel_PaME);
        listReferentielPanelToInsert.add(refPanelPaME);
        
        Referentiel_Panel__c refPanelMMAT = Test_Utils.createRefPanel(Label.RFP_TypePanel_MMAT, Label.RFP_TypePanel_MMAT);
        listReferentielPanelToInsert.add(refPanelMMAT);
        
        Referentiel_Panel__c refPanelAIP = Test_Utils.createRefPanel(Label.RFP_TypePanel_AIP, Label.RFP_TypePanel_AIP);
        listReferentielPanelToInsert.add(refPanelAIP);
        
        insert listReferentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = Foyer1.Id;
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste1.Referentiel_Panel__c = refPanelAIP.Id;
        foyerPaneliste1.Statut_Foyer_Paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteToInsert.add(foyerPaneliste1);
        
        Foyer_Paneliste__c foyerPaneliste2A = new Foyer_Paneliste__c();
        foyerPaneliste2A.Name = 'Foyer Paneliste 2A';
        foyerPaneliste2A.Foyer__c = Foyer2.Id;
        foyerPaneliste2A.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste2A.Referentiel_Panel__c = refPanelAIP.Id;
        foyerPaneliste2A.Statut_Foyer_Paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteToInsert.add(foyerPaneliste2A);
        
        Foyer_Paneliste__c foyerPaneliste2B = new Foyer_Paneliste__c();
        foyerPaneliste2B.Name = 'Foyer Paneliste 2B';
        foyerPaneliste2B.Foyer__c = Foyer2.Id;
        foyerPaneliste2B.RecordTypeId = recordTypeIdFoyerPanelisteMediamatPame;
        foyerPaneliste2B.Referentiel_Panel__c = refPanelMMAT.Id;
        foyerPaneliste2B.Date_de_chute_temporaire__c= Date.today(); //MD
        foyerPaneliste2B.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Chute_definitive;
        foyerPanelisteToInsert.add(foyerPaneliste2B);
        
        Foyer_Paneliste__c foyerPaneliste2C = new Foyer_Paneliste__c();
        foyerPaneliste2C.Name = 'Foyer Paneliste 2C';
        foyerPaneliste2C.Foyer__c = Foyer2.Id;
        foyerPaneliste2C.RecordTypeId = recordTypeIdFoyerPanelisteMediamatPame;
        foyerPaneliste2C.Referentiel_Panel__c = refPanelPaME.Id;
        foyerPaneliste2C.Date_d_anonymisation__c = Date.today() - 10;
        foyerPanelisteToInsert.add(foyerPaneliste2C);
        
        Foyer_Paneliste__c foyerPaneliste3 = new Foyer_Paneliste__c();
        foyerPaneliste3.Name = 'Foyer Paneliste 3';
        foyerPaneliste3.Foyer__c = Foyer3.Id;
        foyerPaneliste3.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste3.Referentiel_Panel__c = refPanelAIP.Id;
        foyerPanelisteToInsert.add(foyerPaneliste3);
        
        insert foyerPanelisteToInsert;
        
        List<Individu_Paneliste__c> individuPanelisteToInsert = new List<Individu_Paneliste__c>();
        Individu_Paneliste__c individuPaneliste1 = new Individu_Paneliste__c();
        individuPaneliste1.Name = 'Individu Paneliste 1';
        individuPaneliste1.Foyer_paneliste__c = foyerPaneliste1.Id;
        individuPaneliste1.Composition_du_foyer__c = compoFoyer1.Id;
        individuPaneliste1.Lettre__c = 'A';
        individuPanelisteToInsert.add(individuPaneliste1);
        
        Individu_Paneliste__c individuPaneliste2 = new Individu_Paneliste__c();
        individuPaneliste2.Name = 'Individu Paneliste 2';
        individuPaneliste2.Foyer_paneliste__c = foyerPAneliste2A.Id;
        individuPaneliste2.Composition_du_foyer__c = compoFoyer2.Id;
        individuPaneliste2.Lettre__c = 'A';
        individuPanelisteToInsert.add(individuPaneliste2);
        
        Individu_Paneliste__c individuPaneliste3 = new Individu_Paneliste__c();
        individuPaneliste3.Name = 'Individu Paneliste 3';
        individuPaneliste3.Foyer_paneliste__c = foyerPAneliste3.Id;
        individuPaneliste3.Composition_du_foyer__c = compoFoyer3.Id;
        individuPaneliste3.Lettre__c = 'A';
        individuPanelisteToInsert.add(individuPaneliste3);
        
        Insert individuPanelisteToInsert;
        
        List<Individu_paneliste__c> individuPanelisteToUpdate = new List<Individu_Paneliste__c>();
        individuPaneliste1.Date_de_chute_de_l_individu__c = Date.today();
        individuPanelisteToUpdate.add(individuPaneliste1);
        individuPaneliste2.Date_de_chute_de_l_individu__c = Date.today();
        individuPanelisteToUpdate.add(individuPaneliste2);
        individuPaneliste3.Date_de_chute_de_l_individu__c = Date.today();
        individuPanelisteToUpdate.add(individuPaneliste3);
                
        Database.SaveResult[] results = Database.update(individuPanelisteToUpdate, false);
        for(Database.SaveResult resultIndPan:results) {
            if (resultIndPan.isSuccess()) {
                System.debug('$$$ result.getId(): ' + resultIndPan.getId());
            } else {
                for(Database.Error err : resultIndPan.getErrors()) {
                    System.debug('$$$ err.getStatusCode(): ' + err.getStatusCode());
                    System.debug('$$$ err.getMessage(): '+ err.getMessage());
                    System.assert(err.getMessage().contains('individu paneliste'));
                }
            }
        }
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer1.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer2.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(compoFoyer3.id));
        Test.stopTest();
        
    }
}