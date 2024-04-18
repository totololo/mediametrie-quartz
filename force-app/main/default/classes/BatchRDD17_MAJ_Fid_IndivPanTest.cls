/*
* @author: Mikael Chaaya
* @date: 17/07/2023
* @TestedClass: BatchRDD17_MAJ_Fid_IndivPan
* @Coverage: 95%
*/
@isTest
public class BatchRDD17_MAJ_Fid_IndivPanTest {
    @isTest
    Static void fidelisation(){
        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        u.Bypass_validation_rules__c=true;
        update u;
        
         System.runAs(u){
            Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            Id recordTypeIdFidelisationCredit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Credit).getRecordTypeId();
            Id recordTypeIdFidelisationDebit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Debit).getRecordTypeId();


            List<Account> foyerList = new List<Account>();
            Account foyer1 = Test_Utils.createFoyer();
            foyer1.Name = 'Foyer 1';
            foyer1.Numero_de_portable__c = '0611111121';
            foyerList.add(foyer1);
            
            
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
            foyerPaneliste2.Foyer__c = foyer1.Id;
            foyerPaneliste2.Referentiel_Panel__c = refPanelPaME.Id;
            foyerPanelisteList.add(foyerPaneliste2);
            
            insert foyerPanelisteList;
            
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = Test_Utils.createMembreFoyer(foyer1.id); 
            Cont.Lien_parente__c = 'Conjoint';
            Cont.Activite_actuelle__c = 'Congé maternité';
            Cont.CSP42__c = '132';
            Cont.CON_ExtId_SIPanel__c = '122223456';
            listMembreFoyerToInsert.add(Cont);
            
            insert listMembreFoyerToInsert; 
            
            foyer1.Personne_de_reference__c = cont.Id;
            foyer1.contact_principal__c = cont.Id;
            update foyer1;
            
            List<Individu_paneliste__c> individuPanelisteToInsert = new List<Individu_paneliste__c>();
            Individu_paneliste__c indPan = new Individu_Paneliste__c();
            indPan.Foyer_paneliste__c = foyerPaneliste2.Id;
            indPan.Composition_du_foyer__c = cont.Id;
            indPan.Lettre__c = 'D';
            individuPanelisteToInsert.add(indPan);

            Individu_paneliste__c indPan2 = new Individu_Paneliste__c();
            indPan2.Foyer_paneliste__c = foyerPaneliste2.Id;
            indPan2.Composition_du_foyer__c = cont.Id;
            indPan2.Lettre__c = 'F';
            individuPanelisteToInsert.add(indPan2);
            
            insert individuPanelisteToInsert;
            
            List<Fidelisation__c> FidelisationToInsert = new List<Fidelisation__c>();
            Fidelisation__c fd = new Fidelisation__c();
            fd.Foyer__c = foyer1.id;
            fd.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd.recordTypeId = recordTypeIdFidelisationCredit;
            fd.Composition_du_foyer__c=Cont.Id;
            fd.Individu_paneliste__c=indPan.Id;
            fd.Motif_de_credit__c='1';
            fd.Type_de_mouvement__c = '6';
            fd.Points_credites__c=100;
            FidelisationToInsert.add(fd);
             
            Fidelisation__c fd1 = new Fidelisation__c();
            fd1.Foyer__c = foyer1.id;
            fd1.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd1.Individu_paneliste__c=indPan.Id;
            fd1.Composition_du_foyer__c=Cont.Id;
            fd1.recordTypeId = recordTypeIdFidelisationCredit;
            fd1.Motif_de_credit__c='1';
            fd1.Type_de_mouvement__c = '6';
            fd1.Points_credites__c=250;
            FidelisationToInsert.add(fd1);
             
             Fidelisation__c fd2 = new Fidelisation__c();
            fd2.Foyer__c = foyer1.id;
            fd2.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd2.recordTypeId = recordTypeIdFidelisationDebit;
            fd2.Composition_du_foyer__c=Cont.Id;
            fd2.Individu_paneliste__c=indPan.Id;
            fd2.Type_de_mouvement__c = '4';
            fd2.Points_debites__c=100;
            FidelisationToInsert.add(fd2);
             
            Fidelisation__c fd3 = new Fidelisation__c();
            fd3.Foyer__c = foyer1.id;
            fd3.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd3.recordTypeId = recordTypeIdFidelisationDebit;
            fd3.Composition_du_foyer__c=Cont.Id;
            fd3.Individu_paneliste__c=indPan.Id;
            fd3.Type_de_mouvement__c = '4';
            fd3.Points_debites__c=50;
            FidelisationToInsert.add(fd3);

            Fidelisation__c fd4 = new Fidelisation__c();
            fd4.Foyer__c = foyer1.id;
            fd4.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd4.recordTypeId = recordTypeIdFidelisationCredit;
            fd4.Composition_du_foyer__c=Cont.Id;
            fd4.Individu_paneliste__c=indPan2.Id;
            fd4.Motif_de_credit__c='1';
            fd4.Type_de_mouvement__c = '6';
            fd4.Points_credites__c=650;
            FidelisationToInsert.add(fd4);

            Fidelisation__c fd5 = new Fidelisation__c();
            fd5.Foyer__c = foyer1.id;
            fd5.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd5.recordTypeId = recordTypeIdFidelisationCredit;
            fd5.Composition_du_foyer__c=Cont.Id;
            fd5.Individu_paneliste__c=indPan2.Id;
            fd5.Motif_de_credit__c='1';
            fd5.Type_de_mouvement__c = '6';
            fd5.Points_credites__c=250;
            FidelisationToInsert.add(fd5);

            Fidelisation__c fd6 = new Fidelisation__c();
            fd6.Foyer__c = foyer1.id;
            fd6.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd6.recordTypeId = recordTypeIdFidelisationDebit;
            fd6.Composition_du_foyer__c=Cont.Id;
            fd6.Individu_paneliste__c=indPan2.Id;
            fd6.Type_de_mouvement__c = '4';
            fd6.Points_debites__c=100;
            FidelisationToInsert.add(fd6);

            Fidelisation__c fd7 = new Fidelisation__c();
            fd7.Foyer__c = foyer1.id;
            fd7.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd7.recordTypeId = recordTypeIdFidelisationDebit;
            fd7.Composition_du_foyer__c=Cont.Id;
            fd7.Individu_paneliste__c=indPan2.Id;
            fd7.Type_de_mouvement__c = '4';
            fd7.Points_debites__c=50;
            FidelisationToInsert.add(fd7);

            insert FidelisationToInsert;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont.id));
            BatchRDD17_MAJ_Fid_IndivPan btch = new BatchRDD17_MAJ_Fid_IndivPan();
            database.executeBatch(btch);
            Test.stopTest();

            List<Individu_Paneliste__c> indivApresBatch=[Select id,Solde_de_points_idvpan__c from individu_Paneliste__c where Solde_de_points_idvpan__c<>0];

            System.assertNotEquals(0, indivApresBatch.size());
        }

    }
}