/*
* @Auteur : Mikael Chaaya
* @date: 30/03/2023
* @Classe: Batch025_ClotureAuto_CaseInactifMeter
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class Batch025_ClotureAuto_Test {
    @isTest 
    static void testBatch() {
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdRequeteControle = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();

        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_validation_rules__c = true;
        update u;

        System.runAs(u)
        {    
            //Create foyer
            list<Account> listFoyersToInsert = new list<Account>();
            account testAccount = new Account();
            testAccount.Name = 'foyerTest';
            listFoyersToInsert.add(testAccount);
            
            account testAccount3 = new Account();
            testAccount3.Name = 'foyerTest3';
            listFoyersToInsert.add(testAccount3); 

            account testAccount2 = new Account();
            testAccount2.Name = 'foyerTest2';
            listFoyersToInsert.add(testAccount2); 

            account testAccount4 = new Account();
            testAccount4.Name = 'foyerTest4';
            listFoyersToInsert.add(testAccount4); 
            insert listFoyersToInsert;
            
            
            List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
            refPanMMAT.Type_de_panel__c 	= Label.RFP_TypePanel_PaME;
            refPanMMAT.Name					= Label.RFP_Nom_PaME;
            referentielPanelToInsert.add(refPanMMAT);
            
            Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
            refPanAIP.Name = 'AIP';
            refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
            referentielPanelToInsert.add(refPanAIP);
            
            insert referentielPanelToInsert;
            
            List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
            Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
            foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteMMAT.Name = 'FP MMAT';
            foyerPanelisteMMAT.Foyer__c = testAccount.Id;
            foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
            foyerPanelisteToInsert.add(foyerPanelisteMMAT);

            Foyer_Paneliste__c foyerPanelisteMMAT2 = new Foyer_Paneliste__c();
            foyerPanelisteMMAT2.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteMMAT2.Name = 'FP MMAT2';
            foyerPanelisteMMAT2.Foyer__c = testAccount3.Id;
            foyerPanelisteMMAT2.Referentiel_Panel__c = refPanMMAT.Id;
            foyerPanelisteToInsert.add(foyerPanelisteMMAT2);
            
            Foyer_Paneliste__c foyerPanelisteAIP = new Foyer_Paneliste__c();
            foyerPanelisteAIP.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteAIP.Name = 'FP AIP';
            foyerPanelisteAIP.Foyer__c = testAccount2.Id;
            foyerPanelisteAIP.Referentiel_Panel__c = refPanMMAT.Id;
            foyerPanelisteToInsert.add(foyerPanelisteAIP);

            Foyer_Paneliste__c foyerPanelisteMMAT3 = new Foyer_Paneliste__c();
            foyerPanelisteMMAT3.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
            foyerPanelisteMMAT3.Name = 'FP MMAT3';
            foyerPanelisteMMAT3.Foyer__c = testAccount4.Id;
            foyerPanelisteMMAT3.Referentiel_Panel__c = refPanMMAT.Id;
            foyerPanelisteToInsert.add(foyerPanelisteMMAT3);
            
            
            insert foyerPanelisteToInsert;


            //insert contact
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = new Contact();
            Cont.AccountId = testAccount.id;
            Cont.Lastname = 'compoFoyerLastName1';
            Cont.FirstName='cc';
            Cont.Lien_parente__c='1';
            Cont.Type__c='1';
            Cont.CSP42__c='ttt';
            Cont.CSP4__c='ddd';
            Cont.Birthdate = date.today().addDays(- 10000);
            Cont.CON_ExtId_SIPanel__c = '122221111';
            Cont.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
            Cont.Lettre__c='A'; 
                listMembreFoyerToInsert.add(Cont);

            Contact Cont2 = new Contact();
            Cont2.AccountId = testAccount3.id;
            Cont2.Lastname = 'compoFoyerLastName2';
            Cont2.FirstName='cc';
            Cont2.Lien_parente__c='1';
            Cont2.Type__c='1';
            Cont2.CSP42__c='ttt';
            Cont2.CSP4__c='ddd';
            Cont2.Birthdate = date.today().addDays(- 10000);
            Cont2.CON_ExtId_SIPanel__c = '122222222';
            Cont2.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent;
            Cont2.Lettre__c='A';  
                listMembreFoyerToInsert.add(Cont2);
                
            Contact Cont2Plus = new Contact();
            Cont2Plus.AccountId = testAccount4.id;
            Cont2Plus.Lastname = 'compoFoyerLastName3';
            Cont2Plus.FirstName='cc';
            Cont2Plus.Lien_parente__c='1';
            Cont2Plus.Type__c='1';
            Cont2Plus.CSP42__c='ttt';
            Cont2Plus.CSP4__c='ddd';
            Cont2Plus.Birthdate = date.today().addDays(- 10000);
            Cont2Plus.CON_ExtId_SIPanel__c = '122223333';
            Cont2Plus.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent; 
            Cont2Plus.Lettre__c='A'; 
                listMembreFoyerToInsert.add(Cont2Plus); 
                
            Contact Cont3 = new Contact();
            Cont3.AccountId = testAccount2.id;
            Cont3.Lastname = 'compoFoyerLastName4';
            Cont3.FirstName='cc';
            Cont3.Lien_parente__c='1';
            Cont3.Type__c='1';
            Cont3.CSP42__c='ttt';
            Cont3.CSP4__c='ddd';
            Cont3.Birthdate = date.today().addDays(- 10000);
            Cont3.CON_ExtId_SIPanel__c = '122224444';
            Cont3.Lien_de_parente_stat__c=Label.CON_LienParenteStat_Parent; 
            Cont3.Lettre__c='A'; 

                listMembreFoyerToInsert.add(Cont3);

            insert listMembreFoyerToInsert; 
            

            //insert individu paneliste
            list<Individu_Paneliste__c> listIndividuPanelisteToInsert = new list<Individu_Paneliste__c>();
            Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
                indPanTest.name = 'indPanTest1';
                indPanTest.Lettre__c = 'B';
                indPanTest.Foyer_paneliste__c = foyerPanelisteMMAT.id;
                indPanTest.Composition_du_foyer__c = cont.id;
                indPanTest.Date_de_chute_de_l_individu__c = null;
                indPanTest.Date_de_derniere_activite_mobile__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPanTest);

            Individu_Paneliste__c indPantest2 = new Individu_Paneliste__c();
                indPanTest2.name = 'indPanTest2';
                indPanTest2.Lettre__c = 'B';
                indPanTest2.Foyer_paneliste__c = foyerPanelisteMMAT2.id;
                indPanTest2.Composition_du_foyer__c = cont2.id;
                indPanTest2.Date_de_chute_de_l_individu__c = null;
                indPanTest2.Date_de_derniere_activite_mobile__c=Date.today().addDays(-1);
                indPanTest2.Date_de_derniere_activite_browser__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPanTest2);

            Individu_Paneliste__c indPantest2Plus = new Individu_Paneliste__c();
                indPantest2Plus.name = 'indPanTest2Plus';
                indPantest2Plus.Lettre__c = 'B';
                indPantest2Plus.Foyer_paneliste__c = foyerPanelisteMMAT3.id;
                indPantest2Plus.Composition_du_foyer__c = Cont2Plus.id;
                indPantest2Plus.Date_de_chute_de_l_individu__c = null;
                listIndividuPanelisteToInsert.add(indPantest2Plus);
                
            Individu_Paneliste__c indPantest3 = new Individu_Paneliste__c();
                indPantest3.name = 'indPanTest3';
                indPantest3.Lettre__c = 'B';
                indPantest3.Foyer_paneliste__c = foyerPanelisteAIP.id;
                indPantest3.Composition_du_foyer__c = cont3.id;
                indPantest3.Date_de_chute_de_l_individu__c = null;
                indPantest3.Date_de_derniere_activite_browser__c=Date.today().addDays(-1);
                listIndividuPanelisteToInsert.add(indPantest3);

                insert listIndividuPanelisteToInsert;
            
        //Create Case
            list<Case> listCaseToInsert = new list<Case>();
            Case testCase = Test_Utils.createCase(testAccount2.id);
            testCase.foyer_paneliste__c = foyerPanelisteMMAT.Id;
            testCase.ContactId=Cont.Id;
            testCase.Type = 'Inactif Meter J+1';
            testCase.AccountId= testAccount.id;
            testCase.RecordTypeId= recordTypeIdRequeteControle;
            listCaseToInsert.add(testCase);
            
            Case testCase2 = Test_Utils.createCase(testAccount2.id);
            testCase2.foyer_paneliste__c = foyerPanelisteMMAT2.Id;
            testCase2.ContactId=Cont2.Id;
            testCase2.Type = 'Inactif Meter J+1';
            testCase2.AccountId		  = testAccount3.id;
            testCase2.RecordTypeId		  = recordTypeIdRequeteControle;
            listCaseToInsert.add(testCase2); 

            Case testCase3 = Test_Utils.createCase(testAccount2.id);
            testCase3.foyer_paneliste__c = foyerPanelisteMMAT2.Id;
            testCase3.ContactId=Cont3.Id;
            testCase3.Type = 'Inactif Meter J+1';
            testCase3.AccountId		  = testAccount3.id;
            testCase3.RecordTypeId		  = recordTypeIdRequeteControle;
            listCaseToInsert.add(testCase3); 

            Case testCase4 = Test_Utils.createCase(testAccount2.id);
            testCase4.foyer_paneliste__c = foyerPanelisteAIP.Id;
            testCase4.ContactId=Cont3.Id;
            testCase4.Type = 'Inactif Meter J+1';
            testCase4.AccountId		  = testAccount2.id;
            testCase4.RecordTypeId		  = recordTypeIdRequeteControle;
            listCaseToInsert.add(testCase4); 

            Case testCase5 = Test_Utils.createCase(testAccount2.id);
            testCase5.foyer_paneliste__c = foyerPanelisteAIP.Id;
            testCase5.Type = 'Inactif Meter J+1';
            testCase5.AccountId		  = testAccount2.id;
            testCase5.RecordTypeId		  = recordTypeIdRequeteControle;
            listCaseToInsert.add(testCase5);

            insert listCaseToInsert;


            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount2.id)); 
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount3.id));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont.CON_ExtId_SIPanel__c));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont2.CON_ExtId_SIPanel__c));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont2Plus.CON_ExtId_SIPanel__c));
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont3.CON_ExtId_SIPanel__c)); 
            Batch025_ClotureAuto_CaseInactifMeter btch = new Batch025_ClotureAuto_CaseInactifMeter();
            database.executeBatch(btch);
            Test.stopTest();

            List<Case> queriedList=[Select id, Sous_type__c,Status from Case];
            System.debug('queriedList');
            System.debug(queriedList);
        }
    }
}