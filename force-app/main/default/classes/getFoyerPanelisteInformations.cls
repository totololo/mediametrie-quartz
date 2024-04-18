public with sharing class getFoyerPanelisteInformations {
    
    @AuraEnabled
    public static wrapperType getInformations(Integer pageNumber, Boolean fromSolde) {
        wrapperType tableData = new wrapperType();
        Integer recordsPerPage = Integer.valueOf(Label.SoldeDesPointRecords);
        tableData.recordsPerPage = recordsPerPage;
        
        //tableData.recordsPerPage = 1;
        pageNumber = pageNumber - 1;
        Integer requestOffset = recordsPerPage * pageNumber;
        
        User connectedUser = [SELECT id, contactId, Contact.Contact_principal__c , Contact.Account.Personne_de_reference__c 
                              FROM user 
                              WHERE id = :UserInfo.getUserId()];
        
        Id contactId = connectedUser.contactId;
        if(String.isNotBlank(contactId)){
            Id foyerId = [SELECT id, Foyer_paneliste__r.Id 
                          FROM Individu_Paneliste__c 
                          WHERE Composition_du_foyer__c = :contactId].get(0).Foyer_paneliste__r.Id;
            
            if(String.isNotBlank(foyerId)){
                tableData.tableRows = [SELECT COUNT() 
                                        FROM Individu_Paneliste__c 
                                        WHERE Foyer_paneliste__c=:foyerId];
	
                List<userWrapperType> newList = new List<userWrapperType>();
                List<String> CompositionDuFoyerIds = new List<String>();
                
                if(tableData.tableRows > 0){
                    String individuPenalisteQuery = 'SELECT Composition_du_foyer__c, Composition_du_foyer__r.Name, Composition_du_foyer__r.Solde_de_points__c ' +
                        							'FROM Individu_Paneliste__c ' +
                        							'WHERE Foyer_paneliste__c = :foyerId ';
                    if(fromSolde && (connectedUser.Contact.Account.Personne_de_reference__c != contactId)){
                        individuPenalisteQuery += 'AND Composition_du_foyer__c = :contactId ';
                    }
                    individuPenalisteQuery += fromSolde ? 'ORDER BY Name ASC NULLS LAST LIMIT :recordsPerPage OFFSET :requestOffset ' : '';
                    System.debug('individuPenalisteQuery ' + individuPenalisteQuery);
                    for (Individu_Paneliste__c individuPenaliste : Database.query(individuPenalisteQuery)) {
                        if(fromSolde){
                            userWrapperType utilisateur = new userWrapperType();
                            utilisateur.Name = individuPenaliste.Composition_du_foyer__r.Name;
                            utilisateur.Solde = String.valueOf(individuPenaliste.Composition_du_foyer__r.Solde_de_points__c);
                            newList.add(utilisateur);
                        }else{
                            CompositionDuFoyerIds.add(individuPenaliste.Composition_du_foyer__c);
                        }
                    }
                    
                    Id debitRecordTypeId = Schema.SObjectType.Fidelisation__c.getRecordTypeInfosByDeveloperName().get('Debit').getRecordTypeId();
                    if(!fromSolde){
                        WRP_Commande wrapperCommande = new WRP_Commande();
                        for(Fidelisation__c fidelisation : [SELECT  Name , CreatedDate, Date_de_traitement__c, Points_debites__c  
                                                            FROM Fidelisation__c 
                                                            WHERE Composition_du_foyer__c IN: CompositionDuFoyerIds AND RecordTypeId = :debitRecordTypeId
                                                            ORDER BY Points_debites__c ASC NULLS LAST 
                                                            LIMIT :recordsPerPage OFFSET :requestOffset]){
                            wrapperCommande = new WRP_Commande(fidelisation.Name, String.valueOf(fidelisation.Points_debites__c/10) + ' €', fidelisation.Date_de_traitement__c,
                                                               fidelisation.CreatedDate.date());
                            tableData.listCommande.add(wrapperCommande);
                        }
                        tableData.tableRows = [SELECT COUNT() 
                                               FROM Fidelisation__c 
                                               WHERE Composition_du_foyer__c IN: CompositionDuFoyerIds AND RecordTypeId = :debitRecordTypeId];
                    }                    
                }
                
                tableData.listUsers = newList;
            }
        }
        return tableData;
    }
    
    public class wrapperType {
        public wrapperType(){
            this.listUsers = new List<userWrapperType>();
            this.tableRows = 0;
            this.listCommande = new List<WRP_Commande>();
        }
        @AuraEnabled
        public List<userWrapperType> listUsers;
        @AuraEnabled
        public Integer tableRows;
        @AuraEnabled
        public Integer recordsPerPage;
        @AuraEnabled
        public List<WRP_Commande> listCommande;
    }
    
    public class userWrapperType {
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Solde;
    }
    
    public class WRP_Commande {
        public WRP_Commande(){
            this.numeroOperation = '-';
            this.pointsDebites = '-';
        }
        public WRP_Commande(String numeroOperation, String pointsDebites, Date dateDeTraitement, Date createdDate){
            this.numeroOperation = numeroOperation;
            this.pointsDebites = pointsDebites;
            this.dateDeTraitement = dateDeTraitement;
            this.createdDate = createdDate;
        }
        @AuraEnabled
        public String numeroOperation;
        @AuraEnabled
        public Date createdDate;
        @AuraEnabled
        public Date dateDeTraitement;
        @AuraEnabled
        public String pointsDebites;
    }
}