public with sharing class getDerniereCommande {
    @AuraEnabled
    public static wrapperType getInfo(Integer pageNumber, Integer recordsPerPage) {
        Integer requestOffset = 0;
        pageNumber = pageNumber -1;
        if(pageNumber == 0) {
            requestOffset = 0;
        } else {
            requestOffset = recordsPerPage * pageNumber;
        }
Id userId = UserInfo.getUserId();
System.debug('bastien userId : '+ userId);

Id contactId = [Select id,contactId, Contact.Contact_principal__c  from user where id = :userId].get(0).contactId;
System.debug('bastien contactId : '+ contactId);

Id foyerId = [select id,Foyer_paneliste__r.Id from Individu_Paneliste__c where Composition_du_foyer__c = :contactId].size()>0 ?[select id,Foyer_paneliste__r.Id from Individu_Paneliste__c where Composition_du_foyer__c = :contactId].get(0).Foyer_paneliste__r.Id : null;
System.debug('bastien foyerId : '+ foyerId);


// //get all membre foyer
List<Individu_Paneliste__c> listIdUsers = [select Composition_du_foyer__c from Individu_Paneliste__c where Foyer_paneliste__c =:foyerId];
System.debug('bastien listIdUsers : '+ listIdUsers);

// Set<Id> resultIds = (new Map<Id,SObject>(listIdUsers)).keySet();
// System.debug('bastien resultIds : '+ resultIds);

Map<Id, Individu_Paneliste__c> mapIndividu = new Map<Id, Individu_Paneliste__c>();
for (Individu_Paneliste__c i : listIdUsers) {
    mapIndividu.put(i.Composition_du_foyer__c, i);
}
System.debug('bastien mapIndividu : '+ mapIndividu);

Set<Id> resultIds =mapIndividu.keySet();
System.debug('bastien resultIds : '+ resultIds);

wrapperType wr = new wrapperType();
// List<Contact> listDerniereCommande = [SELECT Id, (SELECT Id, Name , CreatedDate, Date_de_traitement__c, Points_debites__c FROM Fidelisations__r WHERE RecordType.Name='Débit' ORDER BY CreatedDate desc LIMIT 1) FROM Contact WHERE Id IN :resultIds ORDER BY Name ASC NULLS LAST LIMIT :recordsPerPage OFFSET :requestOffset];
List<Contact> listDerniereCommande = [SELECT Id, (SELECT Id, Name , CreatedDate, Date_de_traitement__c, Points_debites__c FROM Fidelisations__r  WHERE RecordType.Name='Débit' ORDER BY CreatedDate desc LIMIT 1) FROM Contact  WHERE id IN (SELECT Composition_du_foyer__c  FROM Fidelisation__c WHERE Name!=null AND RecordType.Name='Débit') AND Id IN :resultIds ORDER BY Name ASC NULLS LAST LIMIT :recordsPerPage OFFSET :requestOffset];
System.debug('bastien listDerniereCommande : '+ listDerniereCommande);


Integer totalCommande = [SELECT COUNT() FROM Contact  WHERE id IN (SELECT Composition_du_foyer__c  FROM Fidelisation__c WHERE Name!=null AND RecordType.Name='Débit') AND Id IN :resultIds ];
wr.totalCommande=totalCommande;
System.debug('bastien totalCommande : '+ totalCommande);

List<Fidelisation__c> listFid = new List<Fidelisation__c>(); 
for(Contact e : listDerniereCommande){
    if(e.Fidelisations__r!=null && e.Fidelisations__r.size() > 0){
        listFid.add(e.Fidelisations__r);
    }
}

wr.listCommande=listFid;
        return wr;
    }

    public class wrapperType {
        @AuraEnabled
        public List<Fidelisation__c> listCommande;
        @AuraEnabled
        public Integer totalCommande;
        }
}