/*
* @author: Claire VEHRLE
* @date: 28/04/2022
* @ Description: Classe qui test AP08_FoyerPaneliste
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
@isTest
public class AP08_FoyerPaneliste_Test {
    
    public static testMethod void changementTypesDepanelFoyer() {
        
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
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        
        Foyer_Paneliste__c foyerPanelisteAIP = new Foyer_Paneliste__c();
        foyerPanelisteAIP.recordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPanelisteAIP.Name = 'FP AIP';
        foyerPanelisteAIP.Foyer__c = foyer.Id;
        foyerPanelisteAIP.Foyer_equipe__c = true;
        foyerPanelisteAIP.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel_Chute_temporaire;
        foyerPanelisteAIP.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteToInsert.add(foyerPanelisteAIP);
        
        Foyer_Paneliste__c foyerPanelistePaME = new Foyer_Paneliste__c();
        foyerPanelistePaME.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelistePaME.Name = 'FP PaME';
        foyerPanelistePaME.Foyer__c = foyer.Id;
        foyerPanelistePaME.Foyer_equipe__c = true;
        foyerPanelistePaME.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelistePaME.Referentiel_Panel__c = refPanPaME.Id;
        foyerPanelisteToInsert.add(foyerPanelistePaME);
        
        insert foyerPanelisteToInsert;
        
        List<Account> new1FoyerList = [SELECT Id, Types_de_Panel__c FROM Account];
        
        System.assert(new1FoyerList[0].Types_de_Panel__c == 'MMT;AIP;PaME' || new1FoyerList[0].Types_de_Panel__c == 'MMT;AIP;PaME');
        System.Debug('$$$$$$$$$$$$$$$$$$$$$');
        System.Debug('$$$ TEST new1FoyerList[0].Types_de_Panel__c: ' + new1FoyerList[0].Types_de_Panel__c);
        
        Delete foyerPanelisteMMAT;
        
        List<Account> new2FoyerList = [SELECT Id, Types_de_Panel__c FROM Account];
        System.Debug('$$$ TEST new2FoyerList[0].Types_de_Panel__c: ' + new2FoyerList[0].Types_de_Panel__c);
        System.assertEquals('PaME', new2FoyerList[0].Types_de_Panel__c);
        
        foyerPanelisteAIP.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel_Integre;
        Update foyerPanelisteAIP;
        
        List<Account> new3FoyerList = [SELECT Id, Types_de_Panel__c FROM Account];
        
        System.assert(new3FoyerList[0].Types_de_Panel__c == 'PaME;AIP' || new3FoyerList[0].Types_de_Panel__c == 'AIP;PaME');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteMMAT.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteAIP.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelistePaME.id));
        Test.stopTest();
    }
    
    public static testMethod void changementTypesDepanelFoyerInsert() {
        
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
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        
        Foyer_Paneliste__c foyerPanelisteAIP = new Foyer_Paneliste__c();
        foyerPanelisteAIP.recordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPanelisteAIP.Name = 'FP AIP';
        foyerPanelisteAIP.Foyer__c = foyer.Id;
        foyerPanelisteAIP.Foyer_equipe__c = true;
        foyerPanelisteAIP.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel_Chute_temporaire;
        foyerPanelisteAIP.Referentiel_Panel__c = refPanAIP.Id;
        foyerPanelisteToInsert.add(foyerPanelisteAIP);
        
        Foyer_Paneliste__c foyerPanelistePaME = new Foyer_Paneliste__c();
        foyerPanelistePaME.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelistePaME.Name = 'FP PaME';
        foyerPanelistePaME.Foyer__c = foyer.Id;
        foyerPanelistePaME.Foyer_equipe__c = true;
        foyerPanelistePaME.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelistePaME.Referentiel_Panel__c = refPanPaME.Id;
        foyerPanelisteToInsert.add(foyerPanelistePaME);
        
        insert foyerPanelisteToInsert;
        
        List<Account> new1FoyerList = [SELECT Id, Types_de_Panel__c FROM Account];
        System.Debug('$$$ TEST new1FoyerList[0].Types_de_Panel__c: ' + new1FoyerList[0].Types_de_Panel__c);

        System.assert(new1FoyerList[0].Types_de_Panel__c == 'MMT;AIP;PaME' || new1FoyerList[0].Types_de_Panel__c == 'MMT;AIP;PaME');
        System.Debug('$$$$$$$$$$$$$$$$$$$$$');
        System.Debug('$$$ TEST new1FoyerList[0].Types_de_Panel__c: ' + new1FoyerList[0].Types_de_Panel__c);
                
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteMMAT.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteAIP.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelistePaME.id));
        Test.stopTest();
    }
}