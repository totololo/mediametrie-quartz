/*
* @author: Jérôme HE
* @date: 25/02/2022
* @Classe: AP01_IndividuPaneliste
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class AP01_IndividuPaneliste_Test {
    @testSetup
    static void setup(){
        
    }
    public static testMethod void AP01_IndPanTest(){
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer;AP08_FoyerPaneliste;AP03_Individu_paneliste';
        u.Bypass_flows__c = true;
        update u;
        
        //System.runAs(u){

            List <String> ExternalIds = new List <String>();
            Id recordTypeIdFoyerPanMMPaME  = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            Id recordTypeIdFoyerPanMMAIP  = Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        
            list<Account> listFoyersToInsert = new list<Account>();
            account acc = Test_Utils.createFoyer();
            listFoyersToInsert.add(acc); 
            insert listFoyersToInsert;
            
            Referentiel_Panel__c refPanTest = new Referentiel_Panel__c();
            refPanTest.Type_de_panel__c = Label.RFP_TypePanel_PaME;
            refPanTest.Name = Label.RFP_Nom_PaME;
            insert refPanTest;
            
            Foyer_paneliste__c foyerPanTest = new Foyer_paneliste__c(Name ='foyerPanTest');
            foyerPanTest.Referentiel_Panel__c = refPanTest.id;
            foyerPanTest.foyer__c = acc.id;
            foyerPanTest.RecordTypeId = recordTypeIdFoyerPanMMPaME;
            insert foyerPanTest;
            
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = Test_Utils.createMembreFoyer(acc.id); 
            Cont.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            Cont.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            Cont.Code_profession__c = 132;
            listMembreFoyerToInsert.add(Cont);       
            insert listMembreFoyerToInsert;        
            
            
            Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
            indPanTest.name = 'indPanTest';
            indPanTest.Lettre__c = 'B';
            indPanTest.Foyer_paneliste__c = foyerPanTest.id;
            indPanTest.Composition_du_foyer__c = cont.id;
            indPanTest.Date_de_chute_de_l_individu__c = null;
        	indPanTest.ID_Google__c = '12345';
            insert indPanTest;
            
            IndividuPanelisteCallout_Mock indPanMock = new IndividuPanelisteCallout_Mock(indPanTest.id);
            indPanTest.Date_de_chute_de_l_individu__c = date.today();
            Test.startTest();
            Update indPanTest;
            Test.setMock(HttpCalloutMock.class, indPanMock);
            //Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont.CON_ExtId_SIPanel__c)); 
            Test.stopTest();
            
        //}
    }
}