/*
* @author: Claire VEHRLE
* @date: 26/01/2022
* @ Description Batch pour la priorisation/repriorisation des requêtes
* @TestClass: Batch017_PrioriteRequete_Test
* @Coverage: -- %
* History
* <Date of modification>   		<Author>    		<Description of modification>
*/
public class Batch017_PrioriteRequete implements Database.Batchable<sObject> {
    
    public List<Case> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        Schema.SobjectType groupSObjectType = Group.SobjectType;
        /*List<Case> caseList = [SELECT Id , OwnerId, createdDate,
                               (SELECT field, createdDate FROM Histories WHERE field='ownerAssignment' ORDER BY createdDate DESC LIMIT 1)
                               FROM Case WHERE Owner.email = null
                               ORDER BY LastModifiedDate DESC];*/
        //test mikael
        List<Case> caseList = [SELECT Id , OwnerId, createdDate,
                               (SELECT field, createdDate FROM Histories WHERE field='ownerAssignment' ORDER BY createdDate DESC LIMIT 1)
                               FROM Case WHERE OwnerId IN (SELECT Id FROM Group WHERE Type = 'Queue')
                               ORDER BY LastModifiedDate DESC];
        
        System.debug('$$$caseList: ' + caseList);
        return caseList;
    }
    
    public void execute(Database.BatchableContext bc, List<Case> records){
        // process each batch of records
        System.debug('$$$ Début');
        for (Case req: records) {
            System.debug('$$$ req: ' + req);
        }
        
        List<Group> GroupList = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName LIKE 'Priorite%'];
        
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
        
        Priorite__c priorite = [SELECT Id, name, Dernier_Jour_de_Modification_du_nombre__c, Priorite_Absolue__c,
                                Priorite_1__c, Priorite_2__c,Priorite_3__c,Priorite_4__c,Priorite_5__c,
                                Priorite_6__c,Priorite_7__c,Priorite_8__c,Priorite_9__c, Priorite_10__c,
                                Priorite_11__c, Priorite_12__c, Priorite_13__c, Priorite_14__c, Priorite_15__c,
                                Priorite_16__c, Priorite_17__c, Priorite_18__c, Priorite_19__c, Priorite_20__c
                                FROM Priorite__c];
        
        system.debug('$$$Avant IF/ELSE');
        //Condition pour vérifier que c'est le premier lancement de la journée
        if(priorite.Dernier_Jour_de_Modification_du_nombre__c != Date.Today()) {
            system.debug('$$$Dans IF');
            for (Case requete:records) {
                if(requete.ownerId == prioriteAbsolueId) {
                    prioriteAbsolueList.add(requete);
                }
                else if(requete.ownerId == priorite1Id) {
                    priorite1List.add(requete);
                }
                else if(requete.ownerId == priorite2Id) {
                    priorite2List.add(requete);
                }
                else if(requete.ownerId == priorite3Id) {
                    priorite3List.add(requete);
                }
                else if(requete.ownerId == priorite4Id) {
                    priorite4List.add(requete);
                }
                else if(requete.ownerId == priorite5Id) {
                    priorite5List.add(requete);
                }
                else if(requete.ownerId == priorite6Id) {
                    priorite6List.add(requete);
                }
                else if(requete.ownerId == priorite7Id) {
                    priorite7List.add(requete);
                }
                else if(requete.ownerId == priorite8Id) {
                    priorite8List.add(requete);
                }
                else if(requete.ownerId == priorite9Id) {
                    priorite9List.add(requete);
                }
                else if(requete.ownerId == priorite10Id) {
                    priorite10List.add(requete);
                }
                else if(requete.ownerId == priorite11Id) {
                    priorite11List.add(requete);
                }
                else if(requete.ownerId == priorite12Id) {
                    priorite12List.add(requete);
                }
                else if(requete.ownerId == priorite13Id) {
                    priorite13List.add(requete);
                }
                else if(requete.ownerId == priorite14Id) {
                    priorite14List.add(requete);
                }
                else if(requete.ownerId == priorite15Id) {
                    priorite15List.add(requete);
                }
                else if(requete.ownerId == priorite16Id) {
                    priorite16List.add(requete);
                }
                else if(requete.ownerId == priorite17Id) {
                    priorite17List.add(requete);
                }
                else if(requete.ownerId == priorite18Id) {
                    priorite18List.add(requete);
                }
                else if(requete.ownerId == priorite19Id) {
                    priorite19List.add(requete);
                }
                else if(requete.ownerId == priorite20Id) {
                    priorite20List.add(requete);
                }
            }
            
            System.debug('$$$ prioriteAbsolueList: ' + prioriteAbsolueList);
            System.debug('$$$ priorite1List: ' + priorite1List);
            System.debug('$$$ priorite2List: ' + priorite2List);
            System.debug('$$$ priorite3List: ' + priorite3List);
            System.debug('$$$ priorite4List: ' + priorite4List);
            System.debug('$$$ priorite5List: ' + priorite5List);
            System.debug('$$$ priorite6List: ' + priorite6List);
            System.debug('$$$ priorite7List: ' + priorite7List);
            System.debug('$$$ priorite8List: ' + priorite8List);
            System.debug('$$$ priorite9List: ' + priorite9List);
            System.debug('$$$ priorite10List: ' + priorite10List);
            System.debug('$$$ priorite11List: ' + priorite11List);
            System.debug('$$$ priorite12List: ' + priorite12List);
            System.debug('$$$ priorite13List: ' + priorite13List);
            System.debug('$$$ priorite14List: ' + priorite14List);
            System.debug('$$$ priorite15List: ' + priorite15List);
            System.debug('$$$ priorite16List: ' + priorite16List);
            System.debug('$$$ priorite17List: ' + priorite17List);
            System.debug('$$$ priorite18List: ' + priorite18List);
            System.debug('$$$ priorite19List: ' + priorite19List);
            System.debug('$$$ priorite20List: ' + priorite20List);
            
            
            priorite.Priorite_Absolue__c = prioriteAbsolueList.size();
            priorite.Priorite_1__c = priorite1List.size();
            priorite.Priorite_2__c = priorite2List.size();
            priorite.Priorite_3__c = priorite3List.size();
            priorite.Priorite_4__c = priorite4List.size();
            priorite.Priorite_5__c = priorite5List.size();
            priorite.Priorite_6__c = priorite6List.size();
            priorite.Priorite_7__c = priorite7List.size();
            priorite.Priorite_8__c = priorite8List.size();
            priorite.Priorite_9__c = priorite9List.size();
            priorite.Priorite_10__c = priorite10List.size();
            priorite.Priorite_11__c = priorite11List.size();
            priorite.Priorite_12__c = priorite12List.size();
            priorite.Priorite_13__c = priorite13List.size();
            priorite.Priorite_14__c = priorite14List.size();
            priorite.Priorite_15__c = priorite15List.size();
            priorite.Priorite_16__c = priorite16List.size();
            priorite.Priorite_17__c = priorite17List.size();
            priorite.Priorite_18__c = priorite18List.size();
            priorite.Priorite_19__c = priorite19List.size();
            priorite.Priorite_20__c = priorite20List.size();
            priorite.Dernier_Jour_de_Modification_du_nombre__c = Date.today();
            
            system.debug('$$$Before UPDATE batch017');
            system.debug('$$$priorite : ' + priorite);
            Update priorite;
            system.debug('$$$After UPDATE batch017');
        }
        else {
            system.debug('$$$Dans ELSE');
            for (Case requete:records) {
                if(requete.ownerId == prioriteAbsolueId) {
                    prioriteAbsolueList.add(requete);
                }
                else if(requete.ownerId == priorite1Id) {
                    priorite1List.add(requete);
                }
                else if(requete.ownerId == priorite2Id) {
                    priorite2List.add(requete);
                }
                else if(requete.ownerId == priorite3Id) {
                    priorite3List.add(requete);
                }
                else if(requete.ownerId == priorite4Id) {
                    priorite4List.add(requete);
                }
                else if(requete.ownerId == priorite5Id) {
                    priorite5List.add(requete);
                }
                else if(requete.ownerId == priorite6Id) {
                    priorite6List.add(requete);
                }
                else if(requete.ownerId == priorite7Id) {
                    priorite7List.add(requete);
                }
                else if(requete.ownerId == priorite8Id) {
                    priorite8List.add(requete);
                }
                else if(requete.ownerId == priorite9Id) {
                    priorite9List.add(requete);
                }
                else if(requete.ownerId == priorite10Id) {
                    priorite10List.add(requete);
                }
                else if(requete.ownerId == priorite11Id) {
                    priorite11List.add(requete);
                }
                else if(requete.ownerId == priorite12Id) {
                    priorite12List.add(requete);
                }
                else if(requete.ownerId == priorite13Id) {
                    priorite13List.add(requete);
                }
                else if(requete.ownerId == priorite14Id) {
                    priorite14List.add(requete);
                }
                else if(requete.ownerId == priorite15Id) {
                    priorite15List.add(requete);
                }
                else if(requete.ownerId == priorite16Id) {
                    priorite16List.add(requete);
                }
                else if(requete.ownerId == priorite17Id) {
                    priorite17List.add(requete);
                }
                else if(requete.ownerId == priorite18Id) {
                    priorite18List.add(requete);
                }
                else if(requete.ownerId == priorite19Id) {
                    priorite19List.add(requete);
                }
                else if(requete.ownerId == priorite20Id) {
                    priorite20List.add(requete);
                }
            }
            
            Integer prioriteAbsolue = prioriteAbsolueList.size();
            Integer priorite1 = priorite1List.size();
            Integer priorite2 = priorite2List.size();
            Integer priorite3 = priorite3List.size();
            Integer priorite4 = priorite4List.size();
            Integer priorite5 = priorite5List.size();
            Integer priorite6 = priorite6List.size();
            Integer priorite7 = priorite7List.size();
            Integer priorite8 = priorite8List.size();
            Integer priorite9 = priorite9List.size();
            Integer priorite10 = priorite10List.size();
            Integer priorite11 = priorite11List.size();
            Integer priorite12 = priorite12List.size();
            Integer priorite13 = priorite13List.size();
            Integer priorite14 = priorite14List.size();
            Integer priorite15 = priorite15List.size();
            Integer priorite16 = priorite16List.size();
            Integer priorite17 = priorite17List.size();
            Integer priorite18 = priorite18List.size();
            Integer priorite19 = priorite19List.size();
            Integer priorite20 = priorite20List.size();
            
            System.debug('$$$ prioriteAbsolue: ' + prioriteAbsolue);
            System.debug('$$$ priorite1:  ' + priorite1);
            System.debug('$$$ priorite2:  ' + priorite2);
            System.debug('$$$ priorite3:  ' + priorite3);
            System.debug('$$$ priorite4:  ' + priorite4);
            System.debug('$$$ priorite5:  ' + priorite5);
            System.debug('$$$ priorite6:  ' + priorite6);
            System.debug('$$$ priorite7:  ' + priorite7);
            System.debug('$$$ priorite8:  ' + priorite8);
            System.debug('$$$ priorite9:  ' + priorite9);
            System.debug('$$$ priorite10:  ' + priorite10);
            System.debug('$$$ priorite11:  ' + priorite11);
            System.debug('$$$ priorite12:  ' + priorite12);
            System.debug('$$$ priorite13:  ' + priorite13);
            System.debug('$$$ priorite14:  ' + priorite14);
            System.debug('$$$ priorite15:  ' + priorite15);
            System.debug('$$$ priorite16:  ' + priorite16);
            System.debug('$$$ priorite17:  ' + priorite17);
            System.debug('$$$ priorite18:  ' + priorite18);
            System.debug('$$$ priorite19:  ' + priorite19);
            System.debug('$$$ priorite20:  ' + priorite20);
            
            Integer rePrio1versAbsolu = Integer.valueof(priorite1 * 0.15 + 1);
            Integer rePrio2vers1 = Integer.valueof(priorite2 * 0.15 + 1);
            Integer rePrio3vers2 = Integer.valueof(priorite3 * 0.15 + 1);
            Integer rePrio4vers3 = Integer.valueof(priorite4 * 0.15 + 1);
            Integer rePrio5vers4 = Integer.valueof(priorite5 * 0.15 + 1);
            Integer rePrio6vers5 = Integer.valueof(priorite6 * 0.15 + 1);
            Integer rePrio7vers6 = Integer.valueof(priorite7 * 0.15 + 1);
            Integer rePrio8vers7 = Integer.valueof(priorite8 * 0.15 + 1);
            Integer rePrio9vers8 = Integer.valueof(priorite9 * 0.15 + 1);
            Integer rePrio10vers9 = Integer.valueof(priorite10 * 0.15 + 1);
            Integer rePrio11vers10 = Integer.valueof(priorite11 * 0.15 + 1);
            Integer rePrio12vers11 = Integer.valueof(priorite12 * 0.15 + 1);
            Integer rePrio13vers12 = Integer.valueof(priorite13 * 0.15 + 1);
            Integer rePrio14vers13 = Integer.valueof(priorite14 * 0.15 + 1);
            Integer rePrio15vers14 = Integer.valueof(priorite15 * 0.15 + 1);
            Integer rePrio16vers15 = Integer.valueof(priorite16 * 0.15 + 1);
            Integer rePrio17vers16 = Integer.valueof(priorite17 * 0.15 + 1);
            Integer rePrio18vers17 = Integer.valueof(priorite18 * 0.15 + 1);
            Integer rePrio19vers18 = Integer.valueof(priorite19 * 0.15 + 1);
            Integer rePrio20vers19 = Integer.valueof(priorite20 * 0.15 + 1);
            
            System.debug('$$$ rePrio1versAbsolu: ' + rePrio1versAbsolu);
            System.debug('$$$ rePrio2vers1: ' + rePrio2vers1);
            System.debug('$$$ rePrio3vers2: ' + rePrio3vers2);
            System.debug('$$$ rePrio4vers3: ' + rePrio4vers3);
            System.debug('$$$ rePrio5vers4: ' + rePrio5vers4);
            System.debug('$$$ rePrio6vers5: ' + rePrio6vers5);
            System.debug('$$$ rePrio7vers6: ' + rePrio7vers6);
            System.debug('$$$ rePrio8vers7: ' + rePrio8vers7);
            System.debug('$$$ rePrio9vers8: ' + rePrio9vers8);
            System.debug('$$$ rePrio10vers9: ' + rePrio10vers9);
            System.debug('$$$ rePrio11vers10: ' + rePrio11vers10);
            System.debug('$$$ rePrio12vers11: ' + rePrio12vers11);
            System.debug('$$$ rePrio13vers12: ' + rePrio13vers12);
            System.debug('$$$ rePrio14vers13: ' + rePrio14vers13);
            System.debug('$$$ rePrio15vers14: ' + rePrio15vers14);
            System.debug('$$$ rePrio16vers15: ' + rePrio16vers15);
            System.debug('$$$ rePrio17vers16: ' + rePrio17vers16);
            System.debug('$$$ rePrio18vers17: ' + rePrio18vers17);
            System.debug('$$$ rePrio19vers18: ' + rePrio19vers18);
            System.debug('$$$ rePrio20vers19: ' + rePrio20vers19);
            
            if (prioriteAbsolue == 0 && priorite1List.size() != 0) {
                for(Integer i = 0; i < rePrio1versAbsolu; i++) {
                    priorite1List[i].ownerId = prioriteAbsolueId;
                }
            }
            if (priorite1 == 0 && priorite2List.size() != 0) {
                for(Integer i = 0; i < rePrio2vers1; i++) {
                    priorite2List[i].ownerId = priorite1Id;
                }
            }
            if (priorite2 == 0 && priorite3List.size() != 0) {
                for(Integer i = 0; i < rePrio3vers2; i++) {
                    priorite3List[i].ownerId = priorite2Id;
                }
            }
            if (priorite3 == 0 && priorite4List.size() != 0) {
                for(Integer i = 0; i < rePrio4vers3; i++) {
                    priorite4List[i].ownerId = priorite3Id;
                }
            }
            if (priorite4 == 0 && priorite5List.size() != 0) {
                for(Integer i = 0; i < rePrio5vers4; i++) {
                    priorite5List[i].ownerId = priorite4Id;
                }
            }
            
            if (priorite5 == 0 && priorite6List.size() != 0) {
                for(Integer i = 0; i < rePrio6vers5; i++) {
                    priorite6List[i].ownerId = priorite5Id;
                }
            }
            if (priorite7List.size() != 0) {
                if (priorite.Priorite_6__c == 0) {
                    for(Integer i = 0; i < rePrio7vers6; i++) {
                        priorite7List[i].ownerId = priorite6Id;
                    }
                }
                else if((Decimal)priorite6/priorite.Priorite_6__c <= 0.7) {
                    for(Integer i = 0; i < rePrio7vers6; i++) {
                        priorite7List[i].ownerId = priorite6Id;
                    }
                }
            }
            if (priorite8List.size() != 0) {
                if(priorite.Priorite_7__c == 0) {
                    for(Integer i = 0; i < rePrio8vers7; i++) {
                        priorite8List[i].ownerId = priorite7Id;
                    }
                }
                else if ((Decimal)priorite7/priorite.Priorite_7__c <= 0.7) {
                    for(Integer i = 0; i < rePrio8vers7; i++) {
                        priorite8List[i].ownerId = priorite7Id;
                    }
                }
            }
            if (priorite9List.size() != 0) {
                if(priorite.Priorite_8__c == 0) {
                    for(Integer i = 0; i < rePrio9vers8; i++) {
                        priorite9List[i].ownerId = priorite8Id;
                    }
                }
                else if((Decimal)priorite8/priorite.Priorite_8__c <= 0.7) {
                    for(Integer i = 0; i < rePrio9vers8; i++) {
                        priorite9List[i].ownerId = priorite8Id;
                    }
                }
            }
            if (priorite10List.size() != 0) {
                if(priorite.Priorite_9__c == 0) {
                    for(Integer i = 0; i < rePrio10vers9; i++) {
                        priorite10List[i].ownerId = priorite9Id;
                    }
                }
                else if ((Decimal)priorite9/priorite.Priorite_9__c <= 0.7) {
                    for(Integer i = 0; i < rePrio10vers9; i++) {
                        priorite10List[i].ownerId = priorite9Id;
                    }
                }
            }
            if (priorite11List.size() != 0) {
                if(priorite.Priorite_10__c == 0) {
                    for(Integer i = 0; i < rePrio11vers10; i++) {
                        priorite11List[i].ownerId = priorite10Id;
                    } 
                }
                else if((Decimal)priorite10/priorite.Priorite_10__c <= 0.5) {
                    for(Integer i = 0; i < rePrio11vers10; i++) {
                        priorite11List[i].ownerId = priorite10Id;
                    }
                }
            }
            if (priorite12List.size() != 0) {
                if(priorite.Priorite_11__c == 0) {
                    for(Integer i = 0; i < rePrio12vers11; i++) {
                        priorite12List[i].ownerId = priorite11Id;
                    }
                }
                else if((Decimal)priorite11/priorite.Priorite_11__c <= 0.3) {
                    for(Integer i = 0; i < rePrio12vers11; i++) {
                        priorite12List[i].ownerId = priorite11Id;
                    }
                }
            }
            if (priorite13List.size() != 0) {
                if(priorite.Priorite_12__c == 0) {
                    for(Integer i = 0; i < rePrio13vers12; i++) {
                        priorite13List[i].ownerId = priorite12Id;
                    }
                }
                else if((Decimal)priorite12/priorite.Priorite_12__c <= 0.3) {
                    for(Integer i = 0; i < rePrio13vers12; i++) {
                        priorite13List[i].ownerId = priorite12Id;
                    }
                }
            }
            if (priorite14List.size() != 0) {
                if(priorite.Priorite_13__c == 0) {
                    for(Integer i = 0; i < rePrio14vers13; i++) {
                        priorite14List[i].ownerId = priorite13Id;
                    }
                }
                else if((Decimal)priorite13/priorite.Priorite_13__c <= 0.3) {
                    for(Integer i = 0; i < rePrio14vers13; i++) {
                        priorite14List[i].ownerId = priorite13Id;
                    }
                }
            }
            if (priorite15List.size() != 0) {
                if(priorite.Priorite_14__c == 0) {
                    for(Integer i = 0; i < rePrio15vers14; i++) {
                        priorite15List[i].ownerId = priorite14Id;
                    }
                }
                else if ((Decimal)priorite14/priorite.Priorite_14__c <= 0.3) {
                    for(Integer i = 0; i < rePrio15vers14; i++) {
                        priorite15List[i].ownerId = priorite14Id;
                    }
                }
            }
            //En attente des infos MM
            if (priorite16List.size() != 0) {
                if(priorite.Priorite_15__c == 0) {
                    for(Integer i = 0; i < rePrio16vers15; i++) {
                        priorite16List[i].ownerId = priorite15Id;
                    } 
                }
                else if((Decimal)priorite15/priorite.Priorite_15__c <= 0.15) {
                    for(Integer i = 0; i < rePrio16vers15; i++) {
                        priorite16List[i].ownerId = priorite15Id;
                    }
                }
            }
            if (priorite17List.size() != 0) {
                if(priorite.Priorite_16__c == 0) {
                    for(Integer i = 0; i < rePrio17vers16; i++) {
                        priorite17List[i].ownerId = priorite16Id;
                    }
                }
                else if((Decimal)priorite16/priorite.Priorite_16__c <= 0.15) {
                    for(Integer i = 0; i < rePrio17vers16; i++) {
                        priorite17List[i].ownerId = priorite16Id;
                    }
                }
                
            }
            if (priorite18List.size() != 0) {
                if(priorite.Priorite_17__c == 0) {
                    for(Integer i = 0; i < rePrio18vers17; i++) {
                        priorite18List[i].ownerId = priorite17Id;
                    }
                }
                else if ((Decimal)priorite17/priorite.Priorite_17__c <= 0.15) {
                    for(Integer i = 0; i < rePrio18vers17; i++) {
                        priorite18List[i].ownerId = priorite17Id;
                    }
                }
                
            }
            if (priorite19List.size() != 0) {
                if (priorite.Priorite_18__c == 0) {
                    for(Integer i = 0; i < rePrio19vers18; i++) {
                        priorite19List[i].ownerId = priorite18Id;
                    }
                }
                else if((Decimal)priorite18/priorite.Priorite_18__c <= 0.15) {
                    for(Integer i = 0; i < rePrio19vers18; i++) {
                        priorite19List[i].ownerId = priorite18Id;
                    }
                }
                
            }
            if (priorite20List.size() != 0) {
                if(priorite.Priorite_19__c == 0) {
                    for(Integer i = 0; i < rePrio20vers19; i++) {
                        priorite20List[i].ownerId = priorite19Id;
                    }
                }
                else if((Decimal)priorite19/priorite.Priorite_19__c <= 0.15) {
                    for(Integer i = 0; i < rePrio20vers19; i++) {
                        priorite20List[i].ownerId = priorite19Id;
                    }
                }
                
            }
            
            System.debug('$$$ prioriteAbsolueList: ' + prioriteAbsolueList);
            System.debug('$$$ priorite1List: ' + priorite1List);
            System.debug('$$$ priorite2List: ' + priorite2List);
            System.debug('$$$ priorite3List: ' + priorite3List);
            System.debug('$$$ priorite4List: ' + priorite4List);
            System.debug('$$$ priorite5List: ' + priorite5List);
            System.debug('$$$ priorite6List: ' + priorite6List);
            System.debug('$$$ priorite7List: ' + priorite7List);
            System.debug('$$$ priorite8List: ' + priorite8List);
            System.debug('$$$ priorite9List: ' + priorite9List);
            System.debug('$$$ priorite10List: ' + priorite10List);
            System.debug('$$$ priorite11List: ' + priorite11List);
            System.debug('$$$ priorite12List: ' + priorite12List);
            System.debug('$$$ priorite13List: ' + priorite13List);
            System.debug('$$$ priorite14List: ' + priorite14List);
            System.debug('$$$ priorite15List: ' + priorite15List);
            System.debug('$$$ priorite16List: ' + priorite16List);
            System.debug('$$$ priorite17List: ' + priorite17List);
            System.debug('$$$ priorite18List: ' + priorite18List);
            System.debug('$$$ priorite19List: ' + priorite19List);
            System.debug('$$$ priorite20List: ' + priorite20List);
            
            List<Case> allPrioriteList = new List<Case>();
            allPrioriteList.addAll(prioriteAbsolueList);
            allPrioriteList.addAll(priorite1List);
            allPrioriteList.addAll(priorite2List);
            allPrioriteList.addAll(priorite3List);
            allPrioriteList.addAll(priorite4List);
            allPrioriteList.addAll(priorite5List);
            allPrioriteList.addAll(priorite6List);
            allPrioriteList.addAll(priorite7List);
            allPrioriteList.addAll(priorite8List);
            allPrioriteList.addAll(priorite9List);
            allPrioriteList.addAll(priorite10List);
            allPrioriteList.addAll(priorite11List);
            allPrioriteList.addAll(priorite12List);
            allPrioriteList.addAll(priorite13List);
            allPrioriteList.addAll(priorite14List);
            allPrioriteList.addAll(priorite15List);
            allPrioriteList.addAll(priorite16List);
            allPrioriteList.addAll(priorite17List);
            allPrioriteList.addAll(priorite18List);
            allPrioriteList.addAll(priorite19List);
            allPrioriteList.addAll(priorite20List);
            
            for (Case requete: allPrioriteList) {
                System.debug('$$$ allPrioriteList requete: ' + requete);
            }
            update allPrioriteList;
            
        }
        
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
    
    /*public List<Case> sortPrioriteList (List<Case> listToSort) {
        List<Case> sortedList = new List<Case>();
        Boolean firstLoop = true;
        for (Case requete: listToSort) {
            if (firstLoop) {
                sortedList.add(requete);
                firstLoop = false;
            }
            else {
                Boolean addRequeteAtTheEnd = true;
                for (Integer i = 0; i < sortedList.size(); i++) {
                    if (requete.histories[0].createdDate < sortedList[i].histories[0].createdDate) {
                        sortedList.add(i, requete);
                        addRequeteAtTheEnd = false;
                    }
                }
                if (addRequeteAtTheEnd) {
                    sortedList.add(requete);
                }
            }
        }
        return sortedList;
    }*/
}