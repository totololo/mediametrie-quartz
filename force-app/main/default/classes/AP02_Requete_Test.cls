/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 09/03/2022
* @Classe: AP02_Requete
* @Coverage: 93%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@IsTest
public class AP02_Requete_Test {
    @IsTest
    public static void testCloturerRequetePrincipale(){// cloturer la requete principale => dettacher toutes les requetes du foyer paneliste de cette requete + attacher les a la nouvelle requete principale
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste11);
        
        Foyer_paneliste__c foyerPaneliste21 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste21.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste21.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste21);
        
        insert foyerPanelisteList;
        
        //insert cases non rep
        List<case> reqNonrep = new List<Case>();
        Case newCase1 = new Case();// creer une nouvlle requete
        newCase1.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase1.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase1.AccountId=foyer1.id;
        newCase1.type=Label.CAS_Type_VieDuFoyer;
        insert newCase1;
        
        Case newCase2 = new Case();// creer une nouvlle requete
        newCase2.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase2.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase2.AccountId=foyer1.id;
        newCase2.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase2);
        
        Case newCase3 = new Case();// creer une nouvlle requete
        newCase3.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase3.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase3.AccountId=foyer1.id;
        newCase3.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase3);
        
        insert reqNonrep;
        newCase1.Status = Label.CAS_Statut_Cloture;
        newCase1.Motif_de_statut__c = Label.CAS_MotifStatut_Injoignable;
        update newCase1;
        
        Case testCAse1 =[select id , parentId,Status from case where id=:newCase1.id];
        System.assertEquals(Label.CAS_Statut_Cloture, testCAse1.Status);
        
        Case testCAse2 =[select id , parentId from case where id=:newCase2.id];
        System.assertEquals(null, testCAse2.parentId);
        
        Case testCAse3 =[select id , parentId from case where id=:newCase3.id];
        System.assertEquals(newCase2.id, testCAse3.parentId);
        
    }
    @IsTest
    public static void testCloturerRequeteEnfant(){// dettacher la requete enfant de la requete principale
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste11);
        
        Foyer_paneliste__c foyerPaneliste21 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste21.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste21.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste21);
        
        insert foyerPanelisteList;
        
        //insert cases non rep
        List<case> reqNonrep = new List<Case>();
        Case newCase1 = new Case();// creer une nouvlle requete
        newCase1.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase1.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase1.AccountId=foyer1.id;
        newCase1.type=Label.CAS_Type_VieDuFoyer;
        insert newCase1;
        
        Case newCase2 = new Case();// creer une nouvlle requete
        newCase2.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase2.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase2.AccountId=foyer1.id;
        newCase2.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase2);
        
        Case newCase3 = new Case();// creer une nouvlle requete
        newCase3.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase3.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase3.AccountId=foyer1.id;
        newCase3.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase3);
        
        insert reqNonrep;
        newCase3.Status=Label.CAS_Statut_Cloture;        
        newCase3.Motif_de_statut__c = Label.CAS_MotifStatut_Injoignable;
        update newCase3;
        
        Case testCAse1 =[select id , parentId from case where id=:newCase1.id];
        System.assertEquals(null, testCAse1.parentId);
        
        Case testCAse2 =[select id , parentId from case where id=:newCase2.id];
        System.assertEquals(newCase1.id, testCAse2.parentId);
        
        Case testCAse3 =[select id , parentId from case where id=:newCase3.id];
        System.assertEquals(null, testCAse3.parentId);
        
    }
    @IsTest
    public static void testInsertNCase(){// ajout d'une N ieme  requete , la premiere requete inseree sera la requete principale
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Id recordTypeIdRequeteDemandePanelisteAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List<Account> foyerList = new List<Account>();
        
        Account foyer1 = new Account();
        foyer1.Name = 'Foyer1';
        foyerList.add(foyer1);
        
        Account foyer2 = new Account();
        foyer2.Name = 'Foyer2';
        foyerList.add(foyer2);
        
        Account foyer3 = new Account();
        foyer3.Name = 'foyer3';
        foyerList.add(foyer3);
        
        insert foyerList;
        
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        Foyer_paneliste__c foyerPaneliste11 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste11.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste11.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste11);
        
        Foyer_paneliste__c foyerPaneliste21 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste21.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste21.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste21);
        
        Foyer_paneliste__c foyerPaneliste31 = Test_Utils.createFoyerPaneliste();
        foyerPaneliste31.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        foyerPaneliste31.Foyer__c = foyer3.Id;
        foyerPanelisteList.add(foyerPaneliste31);
        
        insert foyerPanelisteList;
        //insert cases non rep
        List<case> reqNonrep = new List<Case>();
        Case newCase1 = new Case();// creer une nouvlle requete
        newCase1.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase1.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase1.AccountId=foyer1.id;
        newCase1.type=Label.CAS_Type_VieDuFoyer;
        insert newCase1;
        
        Case newCase2 = new Case();// creer une nouvlle requete
        newCase2.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase2.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase2.AccountId=foyer1.id;
        newCase2.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase2);
        
        Case newCase3 = new Case();// creer une nouvlle requete
        newCase3.RecordTypeId= recordTypeIdRequeteDemandePanelisteAIP;
        newCase3.Foyer_paneliste__c=foyerPaneliste11.id;
        newCase3.AccountId=foyer1.id;
        newCase3.type=Label.CAS_Type_VieDuFoyer;
        reqNonrep.add(newCase3);
        
        insert reqNonrep;
        
        Case testCAse1 =[select id , parentId from case where id=:newCase1.id];
        System.assertEquals(null, testCAse1.parentId);
        
        Case testCAse2 =[select id , parentId from case where id=:newCase2.id];
        System.assertEquals(newCase1.id, testCAse2.parentId);
        
        Case testCAse3 =[select id , parentId from case where id=:newCase3.id];
        System.assertEquals(newCase1.id, testCAse3.parentId);
    }
    
}