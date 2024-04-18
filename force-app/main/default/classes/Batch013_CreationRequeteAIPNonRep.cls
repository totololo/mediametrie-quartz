/*
* @date: 02/11/2021
* @ Description : Creation des requêtes Controle AIP de type non répondant à partir de controle précodé arrivé à terme.
* @version 1.00   
* @Auteur Claire VEHRLE
* @TestClass: Batch013_CreationRequeteAIPNonRep_Test
* @Coverage: --%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/
global class Batch013_CreationRequeteAIPNonRep implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global List<Controle__c> start(Database.BatchableContext bc) {
        
        Id recordTypeIdControleAIPControle = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        List<Controle__c> controleList = [SELECT Id, Foyer__r.Id, requete__c, Foyer_paneliste__c, Type_de_controle__c, sous_type_de_controle__c FROM Controle__c WHERE Statut__c = :Label.CTRL_Statut_Precode AND Requete__c = null
                        AND RecordType.Id = :recordTypeIdControleAIPControle ];
        
        return controleList;
    }
    
    global void execute(Database.BatchableContext bc, List<Controle__c> scope) {
        
        Id recordTypeIdControleAIPRequte = Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        List<Case> caseToInsert = new List<Case>();
        List<controle__c> controleToUpdate = new List<controle__c>();
        Date today = Date.today();
        List<Id> foyerId = new List<Id>();
        for (Controle__c controle: scope) {
            System.debug('@@@controle: ' + controle);
            foyerId.add(controle.Foyer__r.Id);
        }
        
        List<Etiquette__c> etiquetteList = [SELECT Id, Date_de_fin__c, Foyer__r.Id, Foyer_Paneliste__r.Id FROM Etiquette__c WHERE Foyer__r.Id IN :foyerId];
        
       
        
        for (Controle__c controle: scope) {
            for (Etiquette__c etiquette :etiquetteList) {
                System.debug('@@@etiquette: ' + etiquette);
                if(etiquette.Date_de_fin__c <= today && controle.foyer__c == etiquette.Foyer__c) {
                    System.debug('@@@Création requête');
                    Case requete = new Case();
                    requete.AccountId = controle.Foyer__r.Id;
                    requete.Foyer_paneliste__c = controle.Foyer_paneliste__c;
                    requete.RecordTypeId = recordTypeIdControleAIPRequte;
                    requete.Process_Post_Etiquette_Motif__c = true;
                    requete.Type_de_controle__c = controle.Type_de_controle__c;
                    requete.Sous_type_de_controle__c = controle.Sous_type_de_controle__c;
                    requete.type = Label.CAS_Type_Non_repondant;
                    caseToInsert.add(requete);
                    System.debug('@@@requete: ' + requete);
                }
            }
        }
        
        System.debug('@@@caseToInsert: ' + caseToInsert);
        try{
            insert caseToInsert;
        } catch(Exception e) {
            System.debug('@@@Erreur durant l\'insertion des requêtes : ' + e.getMessage() + '\n');
        }
        
        for (Controle__c controle: scope) {
            for (Case requete: caseToInsert) {
                if(controle.foyer__r.Id == requete.AccountId) {
                    controle.requete__c = requete.Id;
                }
            }
            controleToUpdate.add(controle);
        }
        
        try{
            database.update(controleToUpdate, false);
        } catch(Exception e) {
            System.debug('@@@Erreur durant la mise à jour des contrôles : ' + e.getMessage() + '\n');
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }

}