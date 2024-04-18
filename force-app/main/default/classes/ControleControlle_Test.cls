/*
* @version 1.00   18/10/2020
* @Auteur Astou NDIAYE
* @Classe ControleController
* @CodeCoverage  : 100%
*/
@isTest
private class ControleControlle_Test {
    
    @isTest
    private static void ListControleTest(){
        
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        account acc = Test_Utils.createFoyer(); 
        acc.Numero_de_portable__c = '0611111121';
        
        insert acc;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        insert referentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = acc.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        insert foyerPanelisteMMAT;
        
        Controle__c control = Test_Utils.createControle(acc.id, Null, Null, Null,System.today());  
        control.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        control.Foyer_paneliste__c=foyerPanelisteMMAT.id;
        control.Sous_type_de_controle__c=Label.CTRL_SousType_AutresUsages; 
        control.Statut__c=Label.CTRL_StatutActif;
        control.Foyer_paneliste__c = foyerPanelisteMMAT.Id;
        control.createdDate = date.today() - 1;
        
        insert control;
        
        Case c = new Case();
        c.Foyer_paneliste__c=foyerPanelisteMMAT.id;
        c.AccountId=acc.id;
        insert c;
        
        Test.startTest();
        List<Controle__c> con =ControleController.getRelatedList(c.Id);  
        Test.stopTest();
        
        system.assertEquals(1, con.size());
        
    }  
    
    @isTest
    private static void DeleteControleTest(){
        
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        account acc = Test_Utils.createFoyer(); 
        acc.Numero_de_portable__c = '0611111121';
        
        insert acc;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        
        insert referentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = acc.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        insert foyerPanelisteMMAT;
        
        Controle__c control = Test_Utils.createControle(acc.id, Null, Null, Null,System.today());  
        control.Type_de_controle__c=Label.CTRL_TypeAutresUsages;
        control.Sous_type_de_controle__c=Label.CTRL_SousType_AutresUsages; 
        control.Statut__c=Label.CTRL_StatutActif;
        control.Foyer_paneliste__c = foyerPanelisteMMAT.Id;
        control.createdDate = date.today() - 1;
        control.Foyer_paneliste__c=foyerPanelisteMMAT.id;
        insert control;
        
        Test.startTest();
        string statut =  ControleController.deleteControle(control.Id);
        Test.stopTest();
        system.assertEquals('DONE', statut);
        
    }                           
}