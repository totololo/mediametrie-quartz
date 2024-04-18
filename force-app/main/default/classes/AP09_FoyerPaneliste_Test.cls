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

public class AP09_FoyerPaneliste_Test {
    @isTest static void testUpdateFoyer() {
        User u = [SELECT id, Bypass_flows__c, Bypass_validation_rules__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        update u;
        
        System.runAs(u){
            
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
            //foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteMMAT.Name = 'FP MMAT';
            foyerPanelisteMMAT.Foyer__c = foyer.Id;
            foyerPanelisteMMAT.Foyer_equipe__c = true;
            //foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
            foyerPanelisteMMAT.Type_d_intervention__c = '1';
            foyerPanelisteMMAT.Date_d_installation__c = date.today();
            foyerPanelisteMMAT.RecordTypeId=recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteToInsert.add(foyerPanelisteMMAT);
            
            Foyer_Paneliste__c foyerPanelistePAME = new Foyer_Paneliste__c();
            //foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelistePAME.Name = 'FP MMAT';
            foyerPanelistePAME.Foyer__c = foyer.Id;
            //foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            foyerPanelistePAME.Referentiel_Panel__c = refPanPaME.Id;
            foyerPanelistePAME.Type_d_intervention__c = '1';
            foyerPanelistePAME.Date_d_installation__c = date.today();
            foyerPanelistePAME.RecordTypeId=recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteToInsert.add(foyerPanelistePAME);  
            
            insert foyerPanelisteToInsert; 
           
            Set<Id> IdList = new Set<Id>();
            system.debug('rt '+foyerPanelisteMMAT.RecordTypeId);
            system.debug('rt mm'+ recordTypeIdFoyerPanelisteMMATPame);
            List<Foyer_Paneliste__c> foyerPanToUpdate = new List<Foyer_Paneliste__c>();
            for(Foyer_Paneliste__c pan : foyerPanelisteToInsert){
                pan.Statut_Foyer_paneliste__c = label.PAN_Statut_Panel_Installe;
                foyerPanToUpdate.add(pan);
                IdList.add(pan.Id);
            }
            
            
            Test.startTest();
            update foyerPanToUpdate;
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyer.id));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerPanelisteMMAT.id));
            Test.stopTest();
            
            list<Foyer_Paneliste__c> foyerPanelisteToUpdate = [SELECT Id,Name, Lettre_operateur__c, Numero_foyer__c, Identifiant_foyer_pame__c
                                                               FROM Foyer_Paneliste__c
                                                               WHERE Id IN :IdList
                                                              ];
            
            System.assertNotEquals(null, foyerPanelisteToUpdate[0].Lettre_operateur__c);
            System.assertNotEquals(null, foyerPanelisteToUpdate[0].Numero_foyer__c);
            System.assertEquals(null, foyerPanelisteToUpdate[0].Identifiant_foyer_pame__c);
            
            System.assertNotEquals(null, foyerPanelisteToUpdate[1].Lettre_operateur__c);
            System.assertNotEquals(null, foyerPanelisteToUpdate[1].Numero_foyer__c);
            System.assertNotEquals(null, foyerPanelisteToUpdate[1].Identifiant_foyer_pame__c);
        }
    }
}