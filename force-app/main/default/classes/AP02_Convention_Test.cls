/*
* @author: Khaled Hammoudeh
* @date: 07/03/2022
* @ Description: Classe qui test AP02_Convention
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
@isTest
public class AP02_Convention_Test {
    
    @isTest
    static void AP02_GETSignature_Success(){
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        String individuPanelisteId = '042f0722-5ea4-4211-8319-329320ac82ff';
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        insert foyer1;
        
        Referentiel_Panel__c refPanelAIP = Test_Utils.createRefPanel(Label.RFP_TypePanel_AIP, Label.RFP_TypePanel_AIP);
        insert refPanelAIP;
        
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = Foyer1.Id;
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste1.Referentiel_Panel__c = refPanelAIP.Id;
        insert foyerPaneliste1;
        
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
        compoFoyer1.Lien_de_parente_stat__c = '1';  //MD
        insert compoFoyer1;
        
        Individu_Paneliste__c individuPaneliste1 = new Individu_Paneliste__c();
        individuPaneliste1.Name = 'Individu Paneliste 1';
        individuPaneliste1.Foyer_paneliste__c = foyerPaneliste1.Id;
        individuPaneliste1.Composition_du_foyer__c = compoFoyer1.Id;
        individuPaneliste1.Lettre__c = 'A';
        insert individuPaneliste1;
        
        List <String> listIndividuPanelisteIds = new List <String>();
        listIndividuPanelisteIds.add(individuPaneliste1.id);
        
        IndividuPanelisteCallout_Mock fakeGetIndividuPanel = new IndividuPanelisteCallout_Mock(individuPanelisteId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndividuPanel); 
        List<AP02_Convention.CalloutResponse> resp = AP02_Convention.getSigantureConventionFromGoogle(listIndividuPanelisteIds);
        Test.stopTest();
    }
    
}