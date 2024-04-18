/*
* @Auteur Claire VEHRLE
* @date: 28/01/2022
* @Classe: Batch017_PrioriteRequete
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@IsTest(seeAllData=false)
public class Batch017_PrioriteRequete_Test {
    
    @testSetup
    public static void batch017_SetUp() {
        User utilUser = new User(Id=UserInfo.getUserId());
        
        
        List<Group> GroupList = [SELECT Id,name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Priorite%'];
        
        Id prioriteAbsolueId;
        Id priorite1Id;
        Id priorite2Id;
        Id priorite3Id;
        Id priorite4Id;
        Id priorite5Id;
        Id priorite6Id;
        Id priorite7Id;
        Id priorite8Id;
        Id priorite9Id;
        Id priorite10Id;
        Id priorite11Id;
        Id priorite12Id;
        Id priorite13Id;
        Id priorite14Id;
        Id priorite15Id;
        Id priorite16Id;
        Id priorite17Id;
        Id priorite18Id;
        Id priorite19Id;
        Id priorite20Id;
        
        for (Group proprietaire:GroupList) {
            System.debug('$$$proprietaire.name: ' + proprietaire.name);
            System.debug('$$$proprietaire.DeveloperName: ' + proprietaire.DeveloperName);
            if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_Absolue) {
                prioriteAbsolueId = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_1) {
                priorite1Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_2) {
                priorite2Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_3) {
                priorite3Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_4) {
                priorite4Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_5) {
                priorite5Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_6) {
                priorite6Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_7) {
                priorite7Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_8) {
                priorite8Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_9) {
                priorite9Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_10) {
                priorite10Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_11) {
                priorite11Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_12) {
                priorite12Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_13) {
                priorite13Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_14) {
                priorite14Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_15) {
                priorite15Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_16) {
                priorite16Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_17) {
                priorite17Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_18) {
                priorite18Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_19) {
                priorite19Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_20) {
                priorite20Id = proprietaire.Id;
            }
        }
        
        //Check to see if all of the groups are in SF, if no then we create a new group
        List<Group> groupsToCreate = new List<Group>();
            if(prioriteAbsolueId == null) {
                groupsToCreate.add(new Group(Name='PrioriteAbsolue', DeveloperName = Label.GRP_Nom_Priorite_Absolue, Type = 'Queue'));
            }
            if(priorite1Id == null) {
                groupsToCreate.add(new Group(Name='Priorite1', DeveloperName = Label.GRP_Nom_Priorite_1, Type = 'Queue'));
            }
            if(priorite2Id == null) {
                groupsToCreate.add(new Group(Name='Priorite2', DeveloperName = Label.GRP_Nom_Priorite_2, Type = 'Queue'));
            }
            if(priorite3Id == null) {
                groupsToCreate.add(new Group(Name='Priorite3', DeveloperName = Label.GRP_Nom_Priorite_3, Type = 'Queue'));
            }
            if(priorite4Id == null) {
                groupsToCreate.add(new Group(Name='Priorite4', DeveloperName = Label.GRP_Nom_Priorite_4, Type = 'Queue'));
            }
            if(priorite5Id == null) {
                groupsToCreate.add(new Group(Name='Priorite5', DeveloperName = Label.GRP_Nom_Priorite_5, Type = 'Queue'));
            }
            if(priorite6Id == null) {
                groupsToCreate.add(new Group(Name='Priorite6', DeveloperName = Label.GRP_Nom_Priorite_6, Type = 'Queue'));
            }
            if(priorite7Id == null) {
                groupsToCreate.add(new Group(Name='Priorite7', DeveloperName = Label.GRP_Nom_Priorite_7, Type = 'Queue'));
            }
            if(priorite8Id == null) {
                groupsToCreate.add(new Group(Name='Priorite8', DeveloperName = Label.GRP_Nom_Priorite_8, Type = 'Queue'));
            }
            if(priorite9Id == null) {
                groupsToCreate.add(new Group(Name='Priorite9', DeveloperName = Label.GRP_Nom_Priorite_9, Type = 'Queue'));
            }
            if(priorite10Id == null) {
                groupsToCreate.add(new Group(Name='Priorite10', DeveloperName = Label.GRP_Nom_Priorite_10, Type = 'Queue'));
            }
            if(priorite11Id == null) {
                groupsToCreate.add(new Group(Name='Priorite11', DeveloperName = Label.GRP_Nom_Priorite_11, Type = 'Queue'));
            }
            if(priorite12Id == null) {
                groupsToCreate.add(new Group(Name='Priorite12', DeveloperName = Label.GRP_Nom_Priorite_12, Type = 'Queue'));
            }
            if(priorite13Id == null) {
                groupsToCreate.add(new Group(Name='Priorite13', DeveloperName = Label.GRP_Nom_Priorite_13, Type = 'Queue'));
            }
            if(priorite14Id == null) {
                groupsToCreate.add(new Group(Name='Priorite14', DeveloperName = Label.GRP_Nom_Priorite_14, Type = 'Queue'));
            }
            if(priorite15Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite15', DeveloperName = Label.GRP_Nom_Priorite_15, Type = 'Queue'));
                }
            if(priorite16Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite16', DeveloperName = Label.GRP_Nom_Priorite_16, Type = 'Queue'));
                }
            if(priorite17Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite17', DeveloperName = Label.GRP_Nom_Priorite_17, Type = 'Queue'));
                }
            if(priorite18Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite18', DeveloperName = Label.GRP_Nom_Priorite_18, Type = 'Queue'));
                }
            if(priorite19Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite19', DeveloperName = Label.GRP_Nom_Priorite_19, Type = 'Queue'));
                }
        	if(priorite20Id == null) {
                    groupsToCreate.add(new Group(Name='Priorite20', DeveloperName = Label.GRP_Nom_Priorite_20, Type = 'Queue'));
                }
            if(!groupsToCreate.isEmpty()) {
                System.debug('$groupsToCreate: ' +groupsToCreate);
           		 insert groupsToCreate;
        	}
        
        GroupList = [SELECT Id,name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Priorite%'];
        if(prioriteAbsolueId==null || priorite1Id==null || priorite2Id==null || priorite3Id==null || priorite4Id==null || priorite5Id==null || priorite5Id==null || priorite6Id==null || priorite7Id==null ||
           priorite8Id==null || priorite9Id==null || priorite10Id==null || priorite11Id==null || priorite12Id==null || priorite13Id==null || priorite14Id==null || priorite15Id==null || priorite16Id==null 
          || priorite17Id==null || priorite18Id==null || priorite19Id==null || priorite20Id==null ){
                for (Group proprietaire:GroupList) {
                if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_Absolue && prioriteAbsolueId==null ) {
                    prioriteAbsolueId = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_1 && priorite1Id==null ) {
                    priorite1Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_2 && priorite2Id==null ) {
                    priorite2Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_3 &&  priorite3Id==null ) {
                    priorite3Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_4 && priorite4Id==null ) {
                    priorite4Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_5 && priorite5Id==null ) {
                    priorite5Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_6 && priorite6Id==null ) {
                    priorite6Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_7 && priorite7Id==null ) {
                    priorite7Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_8 &&  priorite8Id==null ) {
                    priorite8Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_9 &&  priorite9Id==null ) {
                    priorite9Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_10 && priorite10Id==null ) {
                    priorite10Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_11 && priorite11Id==null ) {
                    priorite11Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_12 && priorite12Id==null ) {
                    priorite12Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_13 && priorite13Id==null ) {
                    priorite13Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_14 && priorite14Id==null ) {
                    priorite14Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_15 && priorite15Id==null ) {
                    priorite15Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_16 && priorite16Id==null ) {
                    priorite16Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_17 && priorite17Id==null ) {
                    priorite17Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_18 && priorite18Id==null ) {
                    priorite18Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_19 && priorite19Id==null ) {
                    priorite19Id = proprietaire.Id;
                }
                else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_20 && priorite20Id==null ) {
                    priorite20Id = proprietaire.Id;
                }
            }
        }
        
        
        System.runAs(utilUser) {
            
            List<QueuesObject> listQueueToInsert = new List<QueuesObject>();
            
            QueuesObject prioriteAbsolueQueue = new QueueSObject();
                prioriteAbsolueQueue.QueueId = prioriteAbsolueId;
            prioriteAbsolueQueue.sObjectType = 'Case';
            listQueueToInsert.add(prioriteAbsolueQueue);
            
            QueuesObject priorite1Queue = new QueueSObject();
            priorite1Queue.QueueId = priorite1Id;
            priorite1Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite1Queue);
            
            QueuesObject priorite2Queue = new QueueSObject();
            priorite2Queue.QueueId = priorite2Id;
            priorite2Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite2Queue);
            
            QueuesObject priorite3Queue = new QueueSObject();
            priorite3Queue.QueueId = priorite3Id;
            priorite3Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite3Queue);
            
            QueuesObject priorite4Queue = new QueueSObject();
            priorite4Queue.QueueId = priorite4Id;
            priorite4Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite4Queue);
            
            QueuesObject priorite5Queue = new QueueSObject();
            priorite5Queue.QueueId = priorite5Id;
            priorite5Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite5Queue);
            
            QueuesObject priorite6Queue = new QueueSObject();
            priorite6Queue.QueueId = priorite6Id;
            priorite6Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite6Queue);
            
            QueuesObject priorite7Queue = new QueueSObject();
            priorite7Queue.QueueId = priorite7Id;
            priorite7Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite7Queue);
            
            QueuesObject priorite8Queue = new QueueSObject();
            priorite8Queue.QueueId = priorite8Id;
            priorite8Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite8Queue);
            
            QueuesObject priorite9Queue = new QueueSObject();
            priorite9Queue.QueueId = priorite9Id;
            priorite9Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite9Queue);
            
            QueuesObject priorite10Queue = new QueueSObject();
            priorite10Queue.QueueId = priorite10Id;
            priorite10Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite10Queue);
            
            QueuesObject priorite11Queue = new QueueSObject();
            priorite11Queue.QueueId = priorite11Id;
            priorite11Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite11Queue);
            
            QueuesObject priorite12Queue = new QueueSObject();
            priorite12Queue.QueueId = priorite12Id;
            priorite12Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite12Queue);
            
            QueuesObject priorite13Queue = new QueueSObject();
            priorite13Queue.QueueId = priorite13Id;
            priorite13Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite13Queue);
            
            QueuesObject priorite14Queue = new QueueSObject();
            priorite14Queue.QueueId = priorite14Id;
            priorite14Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite14Queue);
            
            QueuesObject priorite15Queue = new QueueSObject();
            priorite15Queue.QueueId = priorite15Id;
            priorite15Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite15Queue);
            
            QueuesObject priorite16Queue = new QueueSObject();
            priorite16Queue.QueueId = priorite16Id;
            priorite16Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite16Queue);
            
            QueuesObject priorite17Queue = new QueueSObject();
            priorite17Queue.QueueId = priorite17Id;
            priorite17Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite17Queue);
            
            QueuesObject priorite18Queue = new QueueSObject();
            priorite18Queue.QueueId = priorite18Id;
            priorite18Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite18Queue);
            
            QueuesObject priorite19Queue = new QueueSObject();
            priorite19Queue.QueueId = priorite19Id;
            priorite19Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite19Queue);
            
            QueuesObject priorite20Queue = new QueueSObject();
            priorite20Queue.QueueId = priorite20Id;
            priorite20Queue.sObjectType = 'Case';
            listQueueToInsert.add(priorite20Queue);
            
            insert listQueueToInsert;
            
            System.debug('$$$prioriteAbsolueId: ' + prioriteAbsolueQueue.QueueId);
            System.debug('$$$priorite1Id: ' + priorite1Queue.QueueId);
            System.debug('$$$priorite2Id: ' + priorite2Queue.QueueId);
            System.debug('$$$priorite3Id: ' + priorite3Queue.QueueId);
            System.debug('$$$priorite4Id: ' + priorite4Queue.QueueId);
            System.debug('$$$priorite5Id: ' + priorite5Queue.QueueId);
            System.debug('$$$priorite6Id: ' + priorite6Queue.QueueId);
            System.debug('$$$priorite7Id: ' + priorite7Queue.QueueId);
            System.debug('$$$priorite8Id: ' + priorite8Queue.QueueId);
            System.debug('$$$priorite9Id: ' + priorite9Queue.QueueId);
            System.debug('$$$priorite10Id: ' + priorite10Queue.QueueId);
            System.debug('$$$priorite11Id: ' + priorite11Queue.QueueId);
            System.debug('$$$priorite12Id: ' + priorite12Queue.QueueId);
            System.debug('$$$priorite13Id: ' + priorite13Queue.QueueId);
            System.debug('$$$priorite14Id: ' + priorite14Queue.QueueId);
            System.debug('$$$priorite15Id: ' + priorite15Queue.QueueId);
            System.debug('$$$priorite16Id: ' + priorite16Queue.QueueId);
            System.debug('$$$priorite17Id: ' + priorite17Queue.QueueId);
            System.debug('$$$priorite18Id: ' + priorite18Queue.QueueId);
            System.debug('$$$priorite19Id: ' + priorite19Queue.QueueId);
            System.debug('$$$priorite20Id: ' + priorite20Queue.QueueId);
        }
        
        
        
        
        list<Account> listFoyersToInsert = new list<Account>();
        account foyerMMATPaME = Test_Utils.createFoyer();
        foyerMMATPaME.Date_d_installation__c=system.today()-2;
        foyerMMATPaME.Date_d_integration__c=null;
        foyerMMATPaME.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyerMMATPaME);
        
        account foyerAIP = Test_Utils.createFoyer();
        foyerAIP.Date_d_installation__c=system.today()-2;
        foyerAIP.Date_d_integration__c=null;
        foyerAIP.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(foyerAIP);
        
        insert listFoyersToInsert;
        
        list<Contact> listCompoFoyerToInsert = new list<Contact>();
        Contact contactMMATPaME = Test_Utils.createMembreFoyer(foyerMMATPaME.id); 
        contactMMATPaME.Birthdate=system.today().addyears(-5);
        contactMMATPaME.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        contactMMATPaME.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contactMMATPaME.Classification__c = Label.CON_Classification_Employe;
        contactMMATPaME.CSP4__c = '1234';
        contactMMATPaME.Code_profession__c = 1;
        listCompoFoyerToInsert.add(contactMMATPaME);
        
        Contact contactAIP = Test_Utils.createMembreFoyer(foyerAIP.id); 
        contactAIP.Birthdate=system.today().addyears(-5);
        contactAIP.Lien_de_parente_stat__c = Label.CON_LienParenteStat_Parent;
        contactAIP.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        contactAIP.Classification__c = Label.CON_Classification_Employe;
        contactAIP.CSP4__c = '1234';
        contactAIP.Code_profession__c = 1;
        listCompoFoyerToInsert.add(contactAIP);  
        
        insert listCompoFoyerToInsert;
        
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(contactMMATPaME.id));
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(contactAIP.id));
        
        List<Foyer_Paneliste__c> listFoyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanMMATPaME = Test_Utils.createFoyerPaneliste();
        foyerPanMMATPaME.Foyer__c = foyerMMATPaME.Id;
        listFoyerPanelisteToInsert.add(foyerPanMMATPaME);
        
        Foyer_Paneliste__c foyerPanAIP = Test_Utils.createFoyerPaneliste();
        foyerPanAIP.Foyer__c = foyerAIP.Id;
        listFoyerPanelisteToInsert.add(foyerPanAIP);
        
        insert listFoyerPanelisteToInsert;
        
        Priorite__c valeurPriorite = new  Priorite__c();
        valeurPriorite.name = 'Valeur priorité';
        valeurPriorite.Dernier_Jour_de_Modification_du_nombre__c = system.today() - 1;//system.today() - 1
        valeurPriorite.Priorite_Absolue__c = 0;
        valeurPriorite.Priorite_1__c = 0;
        valeurPriorite.Priorite_2__c = 0;
        valeurPriorite.Priorite_3__c = 0;
        valeurPriorite.Priorite_4__c = 0;
        valeurPriorite.Priorite_5__c = 0;
        valeurPriorite.Priorite_6__c = 0;
        valeurPriorite.Priorite_7__c = 0;
        valeurPriorite.Priorite_8__c = 0;
        valeurPriorite.Priorite_9__c = 0;
        valeurPriorite.Priorite_10__c = 0;
        valeurPriorite.Priorite_11__c = 0;
        valeurPriorite.Priorite_12__c = 0;
        valeurPriorite.Priorite_13__c = 0;
        valeurPriorite.Priorite_14__c = 0;
        valeurPriorite.Priorite_15__c = 0;
        valeurPriorite.Priorite_16__c = 0;
        valeurPriorite.Priorite_17__c = 0;
        valeurPriorite.Priorite_18__c = 0;
        valeurPriorite.Priorite_19__c = 0;
        valeurPriorite.Priorite_20__c = 0;
        
        insert valeurPriorite;
        
        Id requeteControleMMPaMEId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_Controle).getRecordTypeId();
        Id requeteControleAIPId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        
        List<Case> requeteToInsert = new List<Case>();
        Case requetePrioAbsolue = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrioAbsolue.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrioAbsolue.recordTypeId = requeteControleMMPaMEId;
        requetePrioAbsolue.OwnerId = prioriteAbsolueId;
        requeteToInsert.add(requetePrioAbsolue);
        
        Case requetePrio1 = test_Utils.createCase(foyerAIP.Id);
        requetePrio1.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio1.recordTypeId = requeteControleAIPId;
        requetePrio1.OwnerId = priorite1Id;
        requeteToInsert.add(requetePrio1);
        
        Case requetePrio2 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio2.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio2.recordTypeId = requeteControleMMPaMEId;
        requetePrio2.OwnerId = priorite2Id;
        requeteToInsert.add(requetePrio2);
        
        Case requetePrio3 = test_Utils.createCase(foyerAIP.Id);
        requetePrio3.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio3.recordTypeId = requeteControleAIPId;
        requetePrio3.OwnerId = priorite3Id;
        requeteToInsert.add(requetePrio3);        
        
        Case requetePrio4 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio4.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio4.recordTypeId = requeteControleMMPaMEId;
        requetePrio4.OwnerId = priorite4Id;
        requeteToInsert.add(requetePrio4);
        
        Case requetePrio5 = test_Utils.createCase(foyerAIP.Id);
        requetePrio5.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio5.recordTypeId = requeteControleAIPId;
        requetePrio5.OwnerId = priorite5Id;
        requeteToInsert.add(requetePrio5);        
        
        Case requetePrio6 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio6.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio6.recordTypeId = requeteControleMMPaMEId;
        requetePrio6.OwnerId = priorite6Id;
        requeteToInsert.add(requetePrio6);
        
        Case requetePrio7 = test_Utils.createCase(foyerAIP.Id);
        requetePrio7.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio7.recordTypeId = requeteControleAIPId;
        requetePrio7.OwnerId = priorite7Id;
        requeteToInsert.add(requetePrio7);        
        
        Case requetePrio8 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio8.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio8.recordTypeId = requeteControleMMPaMEId;
        requetePrio8.OwnerId = priorite8Id;
        requeteToInsert.add(requetePrio8);
        
        Case requetePrio9 = test_Utils.createCase(foyerAIP.Id);
        requetePrio9.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio9.recordTypeId = requeteControleAIPId;
        requetePrio9.OwnerId = priorite9Id;
        requeteToInsert.add(requetePrio9);        
        
        Case requetePrio10 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio10.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio10.recordTypeId = requeteControleMMPaMEId;
        requetePrio10.OwnerId = priorite10Id;
        requeteToInsert.add(requetePrio10);
        
        Case requetePrio11 = test_Utils.createCase(foyerAIP.Id);
        requetePrio11.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio11.recordTypeId = requeteControleAIPId;
        requetePrio11.OwnerId = priorite11Id;
        requeteToInsert.add(requetePrio11);        
        
        Case requetePrio12 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio12.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio12.recordTypeId = requeteControleMMPaMEId;
        requetePrio12.OwnerId = priorite12Id;
        requeteToInsert.add(requetePrio12);
        
        Case requetePrio13 = test_Utils.createCase(foyerAIP.Id);
        requetePrio13.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio13.recordTypeId = requeteControleAIPId;
        requetePrio13.OwnerId = priorite13Id;
        requeteToInsert.add(requetePrio13);        
        
        Case requetePrio14 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio14.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio14.recordTypeId = requeteControleMMPaMEId;
        requetePrio14.OwnerId = priorite14Id;
        requeteToInsert.add(requetePrio14);
        
        Case requetePrio15 = test_Utils.createCase(foyerAIP.Id);
        requetePrio15.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio15.recordTypeId = requeteControleAIPId;
        requetePrio15.OwnerId = priorite15Id;
        requeteToInsert.add(requetePrio15);        
        
        Case requetePrio16 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio16.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio16.recordTypeId = requeteControleMMPaMEId;
        requetePrio16.OwnerId = priorite16Id;
        requeteToInsert.add(requetePrio16);
        
        Case requetePrio17 = test_Utils.createCase(foyerAIP.Id);
        requetePrio17.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio17.recordTypeId = requeteControleAIPId;
        requetePrio17.OwnerId = priorite17Id;
        requeteToInsert.add(requetePrio17);        
        
        Case requetePrio18 = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio18.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio18.recordTypeId = requeteControleMMPaMEId;
        requetePrio18.OwnerId = priorite18Id;
        requeteToInsert.add(requetePrio18);
        
        Case requetePrio19 = test_Utils.createCase(foyerAIP.Id);
        requetePrio19.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio19.recordTypeId = requeteControleAIPId;
        requetePrio19.OwnerId = priorite19Id;
        requeteToInsert.add(requetePrio19);        
        
        Case requetePrio20a = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio20a.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio20a.recordTypeId = requeteControleMMPaMEId;
        requetePrio20a.OwnerId = priorite20Id;
        requeteToInsert.add(requetePrio20a);
        
        Case requetePrio20b = test_Utils.createCase(foyerAIP.Id);
        requetePrio20b.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio20b.recordTypeId = requeteControleAIPId;
        requetePrio20b.OwnerId = priorite20Id;
        requeteToInsert.add(requetePrio20b);        
        
        Case requetePrio20c = test_Utils.createCase(foyerMMATPaME.Id);
        requetePrio20c.Foyer_paneliste__c = foyerPanMMATPaME.Id;
        requetePrio20c.recordTypeId = requeteControleMMPaMEId;
        requetePrio20c.OwnerId = priorite20Id;
        requeteToInsert.add(requetePrio20c);
        
        Case requetePrio20d = test_Utils.createCase(foyerAIP.Id);
        requetePrio20d.Foyer_paneliste__c = foyerPanAIP.Id;
        requetePrio20d.recordTypeId = requeteControleAIPId;
        requetePrio20d.OwnerId = priorite20Id;
        requeteToInsert.add(requetePrio20d);
        
        insert requeteToInsert;
        
        List<Case> caseListTest = [SELECT Id , OwnerId, Owner.Name, Owner.email
                                         FROM Case 
                                         ORDER BY LastModifiedDate DESC];
        
        for(Case req:caseListTest) {
            System.debug('$$$req: ' + req);
        }
        
        
       
        
        List<CaseHistory> listCaseHistoryToInsert = new List<CaseHistory>();
        CaseHistory CaseHistory20a = new CaseHistory();
        CaseHistory20a.field = 'ownerAssignment';
        CaseHistory20a.CaseId = requetePrio20a.Id;
        listCaseHistoryToInsert.add(CaseHistory20a);
        
        CaseHistory CaseHistory20b = new CaseHistory();
        CaseHistory20b.field = 'ownerAssignment';
        CaseHistory20b.CaseId = requetePrio20b.Id;
        listCaseHistoryToInsert.add(CaseHistory20b);
        
        CaseHistory CaseHistory20c = new CaseHistory();
        CaseHistory20c.field = 'ownerAssignment';
        CaseHistory20c.CaseId = requetePrio20c.Id;
        listCaseHistoryToInsert.add(CaseHistory20c);
        
        CaseHistory CaseHistory20d = new CaseHistory();
        CaseHistory20d.field = 'ownerAssignment';
        CaseHistory20d.CaseId = requetePrio20d.Id;
        listCaseHistoryToInsert.add(CaseHistory20d);
        
        insert listCaseHistoryToInsert;
    }
    
    public static testMethod void calculJournalieNombreRequeteParPriorite() {
        
        Test.startTest();
        Batch017_PrioriteRequete execution1 = new Batch017_PrioriteRequete();
        database.executeBatch(execution1);
        Test.stopTest();
        
        
        
        Priorite__c todayPriorite = [SELECT Id, name, Dernier_Jour_de_Modification_du_nombre__c, Priorite_Absolue__c,
                                     Priorite_1__c, Priorite_2__c,Priorite_3__c,Priorite_4__c,Priorite_5__c,
                                     Priorite_6__c,Priorite_7__c,Priorite_8__c,Priorite_9__c, Priorite_10__c,
                                     Priorite_11__c, Priorite_12__c, Priorite_13__c, Priorite_14__c, Priorite_15__c,
                                     Priorite_16__c, Priorite_17__c, Priorite_18__c, Priorite_19__c, Priorite_20__c
                                     FROM Priorite__c];
        
        System.debug('$$$todayPriorite: ' + todayPriorite);
        /*System.assertEquals(Date.today(), todayPriorite.Dernier_Jour_de_Modification_du_nombre__c);
        System.assertEquals(1, todayPriorite.Priorite_Absolue__c);
        System.assertEquals(1, todayPriorite.Priorite_1__c);
        System.assertEquals(1, todayPriorite.Priorite_2__c);
        System.assertEquals(1, todayPriorite.Priorite_3__c);
        System.assertEquals(1, todayPriorite.Priorite_4__c);
        System.assertEquals(1, todayPriorite.Priorite_5__c);
        System.assertEquals(1, todayPriorite.Priorite_6__c);
        System.assertEquals(1, todayPriorite.Priorite_7__c);
        System.assertEquals(1, todayPriorite.Priorite_8__c);
        System.assertEquals(1, todayPriorite.Priorite_9__c);
        System.assertEquals(1, todayPriorite.Priorite_10__c);
        System.assertEquals(1, todayPriorite.Priorite_11__c);
        System.assertEquals(1, todayPriorite.Priorite_12__c);
        System.assertEquals(1, todayPriorite.Priorite_13__c);
        System.assertEquals(1, todayPriorite.Priorite_14__c);
        System.assertEquals(1, todayPriorite.Priorite_15__c);
        System.assertEquals(1, todayPriorite.Priorite_16__c);
        System.assertEquals(1, todayPriorite.Priorite_17__c);
        System.assertEquals(1, todayPriorite.Priorite_18__c);
        System.assertEquals(1, todayPriorite.Priorite_19__c);
        System.assertEquals(4, todayPriorite.Priorite_20__c);*/
        
        
    }
    
 
    public static testMethod void rePriorisationRequete() {
        
        User utilUser = new User(Id=UserInfo.getUserId());
        
        //mikael
        List<Group> GroupList = [SELECT Id,name, DeveloperName FROM Group WHERE DeveloperName LIKE 'Priorite%'];
        
        Id prioriteAbsolueId;
        Id priorite1Id;
        Id priorite2Id;
        Id priorite3Id;
        Id priorite4Id;
        Id priorite5Id;
        Id priorite6Id;
        Id priorite7Id;
        Id priorite8Id;
        Id priorite9Id;
        Id priorite10Id;
        Id priorite11Id;
        Id priorite12Id;
        Id priorite13Id;
        Id priorite14Id;
        Id priorite15Id;
        Id priorite16Id;
        Id priorite17Id;
        Id priorite18Id;
        Id priorite19Id;
        Id priorite20Id;
        
        for (Group proprietaire:GroupList) {
            System.debug('$$$proprietaire.name: ' + proprietaire.name);
            if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_Absolue) {
                prioriteAbsolueId = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_1) {
                priorite1Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_2) {
                priorite2Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_3) {
                priorite3Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_4) {
                priorite4Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_5) {
                priorite5Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_6) {
                priorite6Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_7) {
                priorite7Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_8) {
                priorite8Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_9) {
                priorite9Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_10) {
                priorite10Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_11) {
                priorite11Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_12) {
                priorite12Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_13) {
                priorite13Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_14) {
                priorite14Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_15) {
                priorite15Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_16) {
                priorite16Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_17) {
                priorite17Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_18) {
                priorite18Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_19) {
                priorite19Id = proprietaire.Id;
            }
            else if(proprietaire.DeveloperName == Label.GRP_Nom_Priorite_20) {
                priorite20Id = proprietaire.Id;
            }
        }
        //Mikael
        
        
        /*List<Group> groupList = [SELECT Id, Name FROM Group
                                 WHERE (Name = :Label.GRP_Nom_Priorite_4 
                                        OR Name = :Label.GRP_Nom_Priorite_9
                                        OR Name = :Label.GRP_Nom_Priorite_19)
                                 AND CreatedDate = TODAY];
        
        Group requetePrio4;
        Group requetePrio9;
        Group requetePrio19;
        for (Group grp: groupList) {
            if(grp.Name == Label.GRP_Nom_Priorite_4) {
                requetePrio4 = grp;
            }
            else if(grp.Name == Label.GRP_Nom_Priorite_9) {
                requetePrio9 = grp;
            }
            else if(grp.Name == Label.GRP_Nom_Priorite_19) {
                requetePrio19 = grp;
            }
        }*/
        
        //Mikael
        List<Case> caseList = [SELECT Id,  AccountId, Foyer_paneliste__c, OwnerId, Owner.name
                               FROM Case 
                               WHERE OwnerId = :priorite4Id 
                               OR OwnerId = :priorite9Id
                               OR OwnerId = :priorite19Id];
        
        system.debug('***caseList.size(): ' + caseList.size());
        for(Case requete:caseList) {
            if(requete.OwnerId == priorite4Id ) {
                requete.ownerId = utilUser.Id;
            }
            else if(requete.OwnerId == priorite9Id) {
                requete.ownerId = utilUser.Id;
            }
            else if(requete.OwnerId == priorite19Id) {
                requete.ownerId = utilUser.Id;
            }
        }   
        
        Update caseList;
        
        Priorite__c prioriteToUpdate = [SELECT Id, Dernier_Jour_de_Modification_du_nombre__c FROM Priorite__c];
        prioriteToUpdate.Dernier_Jour_de_Modification_du_nombre__c = Date.today();
        update prioriteToUpdate;
        
        Test.startTest();
        Batch017_PrioriteRequete execution1 = new Batch017_PrioriteRequete();
        database.executeBatch(execution1);
        Test.stopTest();
        
        List<Case> prioriteAbsolueList = new List<Case>();
        List<Case> priorite1List = new List<Case>();
        List<Case> priorite2List = new List<Case>();
        List<Case> priorite3List = new List<Case>();
        List<Case> priorite4List = new List<Case>();
        List<Case> priorite5List = new List<Case>();
        List<Case> priorite6List = new List<Case>();
        List<Case> priorite7List = new List<Case>();
        List<Case> priorite8List = new List<Case>();
        List<Case> priorite9List = new List<Case>();
        List<Case> priorite10List = new List<Case>();
        List<Case> priorite11List = new List<Case>();
        List<Case> priorite12List = new List<Case>();
        List<Case> priorite13List = new List<Case>();
        List<Case> priorite14List = new List<Case>();
        List<Case> priorite15List = new List<Case>();
        List<Case> priorite16List = new List<Case>();
        List<Case> priorite17List = new List<Case>();
        List<Case> priorite18List = new List<Case>();
        List<Case> priorite19List = new List<Case>();
        List<Case> priorite20List = new List<Case>();

        List<Case> caseListToValidate = [SELECT Id , OwnerId, createdDate,
                                           (SELECT field, createdDate FROM Histories WHERE field='ownerAssignment' ORDER BY createdDate DESC LIMIT 1)
                                           FROM Case WHERE OwnerId IN (SELECT Id FROM Group WHERE Type = 'Queue')
                                           ORDER BY LastModifiedDate DESC];

        for (Case requete:caseListToValidate) {
            System.debug('***caseToValidate: ' + requete);
                if(requete.OwnerId == prioriteAbsolueId) {
                    prioriteAbsolueList.add(requete);
                }
                else if(requete.OwnerId == priorite1Id) {
                    priorite1List.add(requete);
                }
                else if(requete.OwnerId == priorite2Id) {
                    priorite2List.add(requete);
                }
                else if(requete.OwnerId == priorite3Id) {
                    priorite3List.add(requete);
                }
                else if(requete.OwnerId == priorite4Id) {
                    priorite4List.add(requete);
                }
                else if(requete.OwnerId == priorite5Id) {
                    priorite5List.add(requete);
                }
                else if(requete.OwnerId == priorite6Id) {
                    priorite6List.add(requete);
                }
                else if(requete.OwnerId == priorite7Id) {
                    priorite7List.add(requete);
                }
                else if(requete.OwnerId == priorite8Id) {
                    priorite8List.add(requete);
                }
                else if(requete.OwnerId == priorite9Id) {
                    priorite9List.add(requete);
                }
                else if(requete.OwnerId == priorite10Id) {
                    priorite10List.add(requete);
                }
                else if(requete.OwnerId == priorite11Id) {
                    priorite11List.add(requete);
                }
                else if(requete.OwnerId ==priorite12Id) {
                    priorite12List.add(requete);
                }
                else if(requete.OwnerId == priorite13Id) {
                    priorite13List.add(requete);
                }
                else if(requete.OwnerId == priorite14Id) {
                    priorite14List.add(requete);
                }
                else if(requete.OwnerId == priorite15Id) {
                    priorite15List.add(requete);
                }
                else if(requete.OwnerId ==priorite16Id) {
                    priorite16List.add(requete);
                }
                else if(requete.OwnerId == priorite17Id) {
                    priorite17List.add(requete);
                }
                else if(requete.OwnerId == priorite18Id) {
                    priorite18List.add(requete);
                }
                else if(requete.OwnerId == priorite19Id) {
                    priorite19List.add(requete);
                }
                else if(requete.OwnerId == priorite20Id) {
                    priorite20List.add(requete);
                }
            }
        
        /*System.assertEquals(1, prioriteAbsolueList.size());
        System.assertEquals(1, priorite1List.size());
        System.assertEquals(1, priorite2List.size());
        System.assertEquals(1, priorite3List.size());
        System.assertEquals(1, priorite4List.size());
        System.assertEquals(0, priorite5List.size());
        System.assertEquals(2, priorite6List.size());
        System.assertEquals(1, priorite7List.size());
        System.assertEquals(0, priorite8List.size());
        System.assertEquals(1, priorite9List.size());
        System.assertEquals(1, priorite10List.size());
        System.assertEquals(1, priorite11List.size());
        System.assertEquals(1, priorite12List.size());
        System.assertEquals(1, priorite13List.size());
        System.assertEquals(1, priorite14List.size());
        System.assertEquals(1, priorite15List.size());
        System.assertEquals(1, priorite16List.size());
        System.assertEquals(1, priorite17List.size());
        System.assertEquals(0, priorite18List.size());
        System.assertEquals(1, priorite19List.size());
        System.assertEquals(3, priorite20List.size());*/  
    }
    
    
}