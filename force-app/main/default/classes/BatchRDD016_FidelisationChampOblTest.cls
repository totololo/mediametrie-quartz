/*
* @author: Mikael Chaaya
* @date: 31/05/2023
* @TestedClass: BatchRDD016_FidelisationChampObligatoire
* @Coverage: 96%
* Note : This Batch and test Class should be run before setting the Fidelisation__c.Composition_du_foyer__c and Fidelisation__c.Individu_paneliste__c to required fields and should be used only to correct 
*        previously created fidelisations that had Fidelisation__c.Composition_du_foyer__c=null AND/OR Fidelisation__c.Individu_paneliste__c=null
*/
@isTest
public class BatchRDD016_FidelisationChampOblTest {
@isTest
    Static void fidelisation(){

        User u = [SELECT id, Bypass_triggers__c, Bypass_flows__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        u.Bypass_validation_rules__c=true;
        update u;
        
         System.runAs(u){
            Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
            Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
            Id recordTypeIdFidelisationCredit = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByName().get(Label.FID_Type_d_enregistrement_Credit).getRecordTypeId();


            List<Account> foyerList = new List<Account>();
            Account foyer1 = Test_Utils.createFoyer();
            foyer1.Name = 'Foyer 1';
            foyer1.Numero_de_portable__c = '0611111121';
            foyerList.add(foyer1);

            Account foyer2 = Test_Utils.createFoyer();
            foyer2.Name = 'Foyer AIP';
            foyer2.Numero_de_portable__c = '0611145121';
            foyerList.add(foyer2);
            
            
            List<Referentiel_Panel__c> listReferentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanelPaME = new Referentiel_Panel__c();
            refPanelPaME.Name = Label.RFP_Nom_PaME;
            refPanelPaME.Type_de_panel__c = Label.RFP_TypePanel_PaME;
            listReferentielPanelToInsert.add(refPanelPaME);

            Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
            refPanAIP.Name = 'AIP';
            refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
            listReferentielPanelToInsert.add(refPanAIP);
            
            insert listReferentielPanelToInsert;
            
            insert foyerList;
            
            List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();        
            Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
            foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
            foyerPaneliste2.Name = 'Foyer Paneliste 2';
            foyerPaneliste2.Foyer__c = foyer1.Id;
            foyerPaneliste2.Referentiel_Panel__c = refPanelPaME.Id;
            foyerPanelisteList.add(foyerPaneliste2);

            Foyer_paneliste__c foyerPaneliste1 = Test_Utils.createFoyerPaneliste();
            foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
            foyerPaneliste1.Foyer__c = foyer2.Id;
            foyerPaneliste1.Referentiel_Panel__c = refPanAIP.Id;
            foyerPanelisteList.add(foyerPaneliste1);

            
            insert foyerPanelisteList;
            
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = Test_Utils.createMembreFoyer(foyer1.id); 
            Cont.Lien_parente__c = 'Conjoint';
            Cont.Activite_actuelle__c = 'Congé maternité';
            Cont.CSP42__c = '132';
            Cont.CON_ExtId_SIPanel__c = '122223456';
            Cont.AccountId=foyer1.id;
            listMembreFoyerToInsert.add(Cont);

            Contact Cont2 = Test_Utils.createMembreFoyer(foyer2.id); 
            Cont2.Lien_parente__c = 'Conjoint';
            Cont2.Activite_actuelle__c = 'Congé maternité';
            Cont2.CSP42__c = '137';
            Cont2.CON_ExtId_SIPanel__c = '122783456';
            Cont2.AccountId=foyer2.id;
            listMembreFoyerToInsert.add(Cont2);
            
            insert listMembreFoyerToInsert; 
            
            foyer1.Personne_de_reference__c = cont.Id;
            foyer1.contact_principal__c = cont.Id;

            foyer2.Personne_de_reference__c = cont2.Id;
            foyer2.contact_principal__c = cont2.Id;
            update foyer1;
            update foyer2;
            
            List<Individu_paneliste__c> individuPanelisteToInsert = new List<Individu_paneliste__c>();
            Individu_paneliste__c indPan = new Individu_Paneliste__c();
            indPan.Foyer_paneliste__c = foyerPaneliste2.Id;
            indPan.Composition_du_foyer__c = Cont.Id;
            indPan.Lettre__c = 'D';
            indPan.Date_de_chute_de_l_individu__c=null;
            individuPanelisteToInsert.add(indPan);

            Individu_paneliste__c indPan2 = new Individu_Paneliste__c();
            indPan2.Foyer_paneliste__c = foyerPaneliste1.Id;
            indPan2.Composition_du_foyer__c = Cont2.Id;
            indPan2.Lettre__c = 'D';
            indPan2.Date_de_chute_de_l_individu__c=null;
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
            FidelisationToInsert.add(fd);
             
            Fidelisation__c fd1 = new Fidelisation__c();
            fd1.Foyer__c = foyer1.id;
             
            fd1.Foyer_Paneliste__c= foyerPaneliste2.id;
             fd1.Individu_paneliste__c=indPan.Id;
            fd1.recordTypeId = recordTypeIdFidelisationCredit;
            fd1.Motif_de_credit__c='1';
            fd1.Type_de_mouvement__c = '6';
            FidelisationToInsert.add(fd1);
             
             Fidelisation__c fd2 = new Fidelisation__c();
            fd2.Foyer__c = foyer1.id;
            fd2.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd2.recordTypeId = recordTypeIdFidelisationCredit;
            fd2.Composition_du_foyer__c=Cont.Id;
            fd2.Motif_de_credit__c='1';
            fd2.Type_de_mouvement__c = '6';
            FidelisationToInsert.add(fd2);
             
            Fidelisation__c fd3 = new Fidelisation__c();
            fd3.Foyer__c = foyer1.id;
            fd3.Foyer_Paneliste__c= foyerPaneliste2.id;
            fd3.recordTypeId = recordTypeIdFidelisationCredit;
            
            fd3.Motif_de_credit__c='1';
            fd3.Type_de_mouvement__c = '6';
            FidelisationToInsert.add(fd3);

            Fidelisation__c fd4 = new Fidelisation__c();
            fd4.Foyer__c = foyer2.id;
            fd4.Foyer_Paneliste__c= foyerPaneliste1.id;
            fd4.recordTypeId = recordTypeIdFidelisationCredit;
            fd4.Motif_de_credit__c='1';
            fd4.Type_de_mouvement__c = '6';
            FidelisationToInsert.add(fd4);
             
            insert FidelisationToInsert;
            
             List<Fidelisation__c> fidBeforeBatchList = [SELECT Id, Foyer_Paneliste__c 
                                                  FROM Fidelisation__c
                                                  WHERE (Composition_du_foyer__c=null
                                                        AND 
                                                        Individu_paneliste__c<>null
                                                        )
                                                    OR(Composition_du_foyer__c<>null
                                                        AND 
                                                        Individu_paneliste__c=null
                                                      )
                                                    OR(Composition_du_foyer__c=null
                                                      AND Individu_paneliste__c=null
                                                       AND Foyer__r.Personne_de_reference__c<> null
                                                      )
                                                 ];
            System.debug(fidBeforeBatchList);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont.id));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(cont2.id));
            BatchRDD016_FidelisationChampObligatoire btch = new BatchRDD016_FidelisationChampObligatoire();
            database.executeBatch(btch);
            Test.stopTest();
            
            List<Fidelisation__c> fidBatchList = [SELECT Id, Foyer_Paneliste__c 
                                                  FROM Fidelisation__c
                                                  WHERE (Composition_du_foyer__c=null
                                                        AND 
                                                        Individu_paneliste__c<>null
                                                        )
                                                    OR(Composition_du_foyer__c<>null
                                                        AND 
                                                        Individu_paneliste__c=null
                                                      )
                                                    OR(Composition_du_foyer__c=null
                                                      AND Individu_paneliste__c=null
                                                       AND Foyer__r.Personne_de_reference__c<> null
                                                      )
                                                 ];
            
            System.assertEquals(0, fidBatchList.size());
         }
    }

}