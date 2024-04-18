/*
* @author: Bastien Pinard
* @date: 09/01/2023
* @ Description 
* @Classe: BatchRDD013_Conventions
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD13_ConventionsFoyerRouteur_Test {
    
    @isTest
    Static void RDD_ConventionMMAT() {
        Id recordTypeIdFoyerPanelisteMMAT = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyer1.Date_de_signature_de_la_convention__c=Date.today();
        insert foyer1;
        
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        insert refPanMMAT;
        
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = Foyer1.Id;
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMAT;
        foyerPaneliste1.Referentiel_Panel__c = refPanMMAT.Id;
        insert foyerPaneliste1;
        
        Contact compoFoyer1 = new Contact();
        compoFoyer1.AccountId = Foyer1.Id;
        compoFoyer1.LastName = 'Composition';
        compoFoyer1.FirstName = 'Foyer 1';
        compoFoyer1.Birthdate = Date.today();
        compoFoyer1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer1.Type__c = Label.CON_Type_Membre;
        compoFoyer1.Contact_principal__c = true;
        compoFoyer1.Signature_convention_individuelle_meter__c= Date.today();
        insert compoFoyer1;
        
        Individu_Paneliste__c individuPaneliste1 = new Individu_Paneliste__c();
        individuPaneliste1.Name = 'Individu Paneliste 1';
        individuPaneliste1.Foyer_paneliste__c = foyerPaneliste1.Id;
        individuPaneliste1.Composition_du_foyer__c = compoFoyer1.Id;
        individuPaneliste1.Lettre__c = 'B';
        insert individuPaneliste1;
                
        Referentiel_convention__c refConv = new Referentiel_convention__c();
        refConv.Name = 'Foyer MMT';
        refConv.Referentiel_Panel__c = refPanMMAT.Id;
        refConv.Type_de_la_convention__c = Label.RFC_Type_Convention_Foyer;
        refConv.Date_de_debut__c  = date.newInstance(2005, 02, 22);
        refConv.Version__c = '35';
        
        insert refConv;
        
        IndividuPanelisteCallout_Mock fakeGetIndividuPanel = new IndividuPanelisteCallout_Mock(individuPaneliste1.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndividuPanel); 
        BatchRDD13_ConventionsFoyerRouteur btch = new BatchRDD13_ConventionsFoyerRouteur();
        database.executeBatch(btch);
        Test.stopTest();
        
        Integer conventionBatch = [SELECT COUNT() FROM Convention__c];
        
        System.assertEquals(1, conventionBatch);
    }
    
    @isTest
    Static void RDD_ConventionPAME() {
        Id recordTypeIdFoyerPanelistePaME = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
                
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyer1.Date_de_reception_de_la_convention__c=Date.today();
        insert foyer1;
        
        Referentiel_Panel__c refPanPaME = new Referentiel_Panel__c();
        refPanPaME.Name = 'PaME';
        refPanPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
        insert refPanPaME;
        
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = Foyer1.Id;
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelistePaME;
        foyerPaneliste1.Referentiel_Panel__c = refPanPaME.Id;
        insert foyerPaneliste1;
        
        Contact compoFoyer1 = new Contact();
        compoFoyer1.AccountId = Foyer1.Id;
        compoFoyer1.LastName = 'Composition';
        compoFoyer1.FirstName = 'Foyer 1';
        compoFoyer1.Birthdate = Date.today();
        compoFoyer1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        compoFoyer1.Type__c = Label.CON_Type_Invite;
        compoFoyer1.Contact_principal__c = true;
        compoFoyer1.Signature_convention_individuelle_meter__c= Date.today();
        insert compoFoyer1;
        
        Individu_Paneliste__c individuPaneliste1 = new Individu_Paneliste__c();
        individuPaneliste1.Name = 'Individu Paneliste 1';
        individuPaneliste1.Foyer_paneliste__c = foyerPaneliste1.Id;
        individuPaneliste1.Composition_du_foyer__c = compoFoyer1.Id;
        individuPaneliste1.Lettre__c = 'C';
        insert individuPaneliste1;
        
        List<Referentiel_convention__c> refConvList =  new List<Referentiel_convention__c>();
        Referentiel_convention__c refConv = new Referentiel_convention__c();
        refConv.Name = 'Foyer PaME';
        refConv.Referentiel_Panel__c = refPanPaME.Id;
        refConv.Type_de_la_convention__c = Label.RFC_Type_Convention_Foyer;
        refConv.Date_de_debut__c  = date.newInstance(2005, 02, 22);
        refConv.Version__c = '35';
        refConvList.add(refConv);
        
        Referentiel_convention__c refConvRouteur = new Referentiel_convention__c();
        refConvRouteur.Name = 'routeur PaME';
        refConvRouteur.Referentiel_Panel__c = refPanPaME.Id;
        refConvRouteur.Type_de_la_convention__c = Label.RFC_Type_Convention_Routeur;
        refConvRouteur.Date_de_debut__c  = date.newInstance(2005, 02, 22);
        refConvRouteur.Version__c = '35';
        refConvList.add(refConvRouteur);
        
        insert refConvList;
        
        IndividuPanelisteCallout_Mock fakeGetIndividuPanel = new IndividuPanelisteCallout_Mock(individuPaneliste1.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndividuPanel);         
        BatchRDD13_ConventionsFoyerRouteur btch = new BatchRDD13_ConventionsFoyerRouteur();
        database.executeBatch(btch);
        Test.stopTest();
        
        Integer conventionBatch = [SELECT COUNT() FROM Convention__c];
        
        System.assertEquals(2, conventionBatch);
    }
}