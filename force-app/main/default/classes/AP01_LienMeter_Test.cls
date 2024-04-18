/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 24/02/2022
* @Classe: AP01_LienMeter
* @Coverage: 100%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class AP01_LienMeter_Test {
    @IsTest
    public static void LienMeterTestSuccess() {
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Account foyer5 = new Account();
        foyer5.Name = 'foyer5';
        
        insert foyer5;
        
        Referentiel_Panel__c refPan1 = Test_Utils.createRefPanel(Label.RFP_Nom_AIP, Label.RFP_Nom_AIP);
        insert refPan1;
        
        Foyer_paneliste__c foyerPaneliste51 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste51.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste51.Foyer__c = foyer5.Id;
        foyerPaneliste51.Referentiel_Panel__c =refPan1.id;
        insert foyerPaneliste51;
        
        Contact compo5 = new Contact();
        compo5.AccountId = foyer5.id;
        compo5.Lastname = 'compo5';
        compo5.FirstName='cc';
        compo5.Lien_parente__c='1';
        compo5.Type__c='1';
        compo5.CSP42__c='ttt';
        compo5.CSP4__c='ddd';
        compo5.Birthdate=date.today().addDays(- 10000);
        compo5.Lien_de_parente_stat__c = '1';  
        
        insert compo5;
        
        Individu_Paneliste__c indiv51 = Test_Utils.createIndividuPaneliste(compo5.id, foyerPaneliste51.id, 'A');
        indiv51.Name='indiv51';
        indiv51.Frequence_de_connexion_tablette__c=label.IndPan_FreqConnexion_Jamais;
        indiv51.Frequence_de_connexion_mobile__c =Label.IndPan_FreqConnexion_NSP_Refus;
        insert indiv51;
        
        list<Id> listIdiv = new list<Id>();
        listIdiv.add(indiv51.id);
        
         AP01_LienMeter_CalloutMock fakeGetIndiv = new AP01_LienMeter_CalloutMock(indiv51.id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndiv); 
         AP01_LienMeter.GetLienMeter(listIdiv);
        Test.stopTest();
    } 
    @IsTest
    public static void LienMeterTestError() {
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Account foyer5 = new Account();
        foyer5.Name = 'foyer5';
        
        insert foyer5;
        
        Referentiel_Panel__c refPan1 = Test_Utils.createRefPanel(Label.RFP_Nom_AIP, Label.RFP_Nom_AIP);
        insert refPan1;
        
        Foyer_paneliste__c foyerPaneliste51 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste51.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste51.Foyer__c = foyer5.Id;
        foyerPaneliste51.Referentiel_Panel__c =refPan1.id;
        insert foyerPaneliste51;
        
        Contact compo5 = new Contact();
        compo5.AccountId = foyer5.id;
        compo5.Lastname = 'compo5';
        compo5.FirstName='cc';
        compo5.Lien_parente__c='1';
        compo5.Type__c='1';
        compo5.CSP42__c='ttt';
        compo5.CSP4__c='ddd';
        compo5.Birthdate=date.today().addDays(- 10000);
        compo5.Lien_de_parente_stat__c = '1';  
        
        insert compo5;
        
        Individu_Paneliste__c indiv51 = Test_Utils.createIndividuPaneliste(compo5.id, foyerPaneliste51.id, 'A');
        indiv51.Name='indiv51';
        indiv51.Frequence_de_connexion_tablette__c=label.IndPan_FreqConnexion_Jamais;
        indiv51.Frequence_de_connexion_mobile__c =Label.IndPan_FreqConnexion_NSP_Refus;
        indiv51.type__c = Label.IndPan_Type_Invite;
        insert indiv51;
        
        list<Id> listIdiv = new list<Id>();
        listIdiv.add(indiv51.id);
        
         AP01_LienMeter_CalloutMock fakeGetIndiv = new AP01_LienMeter_CalloutMock('');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndiv); 
         AP01_LienMeter.GetLienMeter(listIdiv);
        Test.stopTest();
    } 
    
}