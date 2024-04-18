@isTest
public class BatchRDD08_Fidelisation_Test {
    
    @isTest
    Static void fidelisation(){

        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
         System.runAs(u){
            Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            Id recordTypeIdFidelisationCredit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Credit).getRecordTypeId();


            List<Account> foyerList = new List<Account>();
            Account foyer1 = Test_Utils.createFoyer();
            foyer1.Name = 'Foyer 1';
            foyer1.Numero_de_portable__c = '0611111121';
            foyerList.add(foyer1);
            
            Account foyer2 = Test_Utils.createFoyer();
            foyer2.Name = 'Foyer 2';
            foyer2.Numero_de_portable__c = '0622222222';
            foyerList.add(foyer2);
            
            List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanelPaME = new Referentiel_Panel__c();
            refPanelPaME.Name = Label.RFP_Nom_PaME;
            refPanelPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
            listReferentielPanelToInsert.add(refPanelPaME);
            
            insert listReferentielPanelToInsert;
            
            insert foyerList;
            
            List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();        
            Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
            foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
            foyerPaneliste2.Name = 'Foyer Paneliste 2';
            foyerPaneliste2.Foyer__c = foyer2.Id;
            foyerPaneliste2.Referentiel_Panel__c = refPanelPaME.Id;
            foyerPanelisteList.add(foyerPaneliste2);
            
            insert foyerPanelisteList;
            
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = Test_Utils.createMembreFoyer(foyer2.id); 
            Cont.Lien_parente__c = 'Conjoint';
            Cont.Activite_actuelle__c = 'Congé maternité';
            Cont.CSP42__c = '132';
            Cont.CON_ExtId_SIPanel__c = '122223456';
            listMembreFoyerToInsert.add(Cont);
            
            insert listMembreFoyerToInsert; 
            
            foyer2.contact_principal__c = cont.Id;
            update foyer2;
            
            List<Individu_paneliste__c> individuPanelisteToInsert = new List<Individu_paneliste__c>();
            Individu_paneliste__c indPan = new Individu_Paneliste__c();
            indPan.Foyer_paneliste__c = foyerPaneliste2.Id;
            indPan.Composition_du_foyer__c = cont.Id;
            indPan.Lettre__c = 'D';
            individuPanelisteToInsert.add(indPan);
            
            insert individuPanelisteToInsert;
            
            Fidelisation__c fd = new Fidelisation__c();
            fd.Foyer__c = foyer2.id;
            fd.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd.recordTypeId = recordTypeIdFidelisationCredit;
            fd.Composition_du_foyer__c=Cont.Id;
            fd.Individu_paneliste__c=indPan.Id;
            fd.Motif_de_credit__c='1';
            fd.Type_de_mouvement__c = '6';
            insert fd;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont.id));
            BatchRDD08_Fidelisation btch = new BatchRDD08_Fidelisation();
            database.executeBatch(btch);
            Test.stopTest();
            
            List<Fidelisation__c> etiBatch = [SELECT Id, Foyer_Paneliste__c FROM Fidelisation__c WHERE foyer__c = :foyer2.Id];
            
            //System.assertEquals(foyerPaneliste2.Id, etiBatch[0].Foyer_Paneliste__c);
         }
    }

}