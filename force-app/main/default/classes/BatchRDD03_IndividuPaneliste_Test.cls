/*
* @Auteur Elia KARAM
* @date: 08/03/2022
* @Classe: BatchRDD03_IndividuPaneliste
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD03_IndividuPaneliste_Test {
    static testMethod void testMethod1() {
        
          
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){
          Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Numero_de_portable__c = '0611111121';
        foyer1.Type_de_foyer__c = Label.ACC_Type_de_panel_PaMe;
        foyerList.add(foyer1);
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
        foyer2.Type_de_foyer__c = Label.ACC_Type_de_panel_AIP;
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanelPaME = Test_Utils.createRefPanel(Label.RFP_Nom_PaME, Label.RFP_Nom_PaME);
        listReferentielPanelToInsert.add(refPanelPaME);
        
        Referentiel_Panel__c refPanelAIP = Test_Utils.createRefPanel(Label.RFP_Nom_AIP, Label.RFP_Nom_AIP);
        listReferentielPanelToInsert.add(refPanelAIP);
        
        insert listReferentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPaneliste1.referentiel_panel__c = refPanelPaME.Id;
        foyerPanelisteList.add(foyerPaneliste1);
        
        Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste2.Name = 'Foyer Paneliste 2';
        foyerPaneliste2.Foyer__c = foyer2.Id;
        foyerPaneliste2.referentiel_panel__c = refPanelPaME.Id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPanelisteList;
        
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        Contact Cont = Test_Utils.createMembreFoyer(foyer1.id); 
        Cont.Lien_parente__c = 'Conjoint';
        Cont.Activite_actuelle__c = 'Congé maternité';
        Cont.Code_profession__c = 132;
        Cont.CON_ExtId_SIPanel__c = '122223456';
       // ExternalIds.add(Cont.CON_ExtId_SIPanel__c);
       listMembreFoyerToInsert.add(Cont);
        
        insert listMembreFoyerToInsert; 

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer1.id));
      //  AP01_MembreDuFoyer.getContactFromSipanel(ExternalIds); 
        BatchRDD03_IndividuPaneliste obj = new BatchRDD03_IndividuPaneliste();
        DataBase.executeBatch(obj); 
        Test.stopTest();
        
        }  
    }
}