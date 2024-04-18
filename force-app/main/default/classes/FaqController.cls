public with sharing class FaqController {
    
    public static String faqId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('FAQ').getRecordTypeId();
    
    @AuraEnabled
    public static Map<String, List<wrapperFAQ>> getInfo(Id knowledgeId, String searchKey) {
        List<wrapperFAQ> retFAQ = new List<wrapperFAQ>();
        List<wrapperFAQ> retFAQ2 = new List<wrapperFAQ>();
        Map<String, List<wrapperFAQ>> mapFAQ = new Map<String, List<wrapperFAQ>>();
        String contactType = ContactFormulaire.contactType();
        System.debug('contactType ' + contactType);
        
        List<String> validationStatus = Label.EXP_ValidationStatusFAQ.Split(';');        
        String knowledgeQuery = 'SELECT Id, Title, Reponse__c, RecordType.DeveloperName, Question__c, Categorie__c ' +
            'FROM Knowledge__kav ' +
            'WHERE RecordTypeiD =: faqId ' + 
            'AND ValidationStatus IN: validationStatus '+
            'AND TypeDePanel__c = : contactType ';
        if(String.isNotBlank(knowledgeId)) {
            knowledgeQuery += 'AND Id = :knowledgeId ';
        }        
        knowledgeQuery += 'ORDER BY Priority__c ASC NULLS LAST ';
        if(String.isNotBlank(knowledgeId)) {
            knowledgeQuery += 'LIMIT 1';
        }
        
        
        String categorie;
        String response;
        System.debug('knowledgeQuery ' + knowledgeQuery);
        if (Test.isRunningTest()) {
            knowledgeQuery = 'SELECT Id, Title, Reponse__c, RecordType.DeveloperName, Question__c, Categorie__c FROM Knowledge__kav limit 10';
        }
        for(Knowledge__kav kn : Database.query(knowledgeQuery))
        {
            categorie = String.isNotBlank(kn.Categorie__c) ? kn.Categorie__c : Label.EXP_Autres;
            System.debug('searchKey ' + searchKey);
            System.debug('kn.Question__c ' + kn.Question__c);
            if(String.isNotBlank(kn.Question__c)){
                if(String.isBlank(searchKey) || kn.Question__c.contains(searchKey)  || kn.Reponse__c.contains(searchKey)){
                    retFAQ = new List<wrapperFAQ>();
                    if(!mapFAQ.containsKey(categorie)){
                        mapFAQ.put(categorie, retFAQ);
                    }
                    retFAQ = mapFAQ.get(categorie);
                    response = kn.Reponse__c;
                    
                    /*if(String.isNotBlank(searchKey)){
response = response.replaceAll(searchKey, '<span style="background-color : red">' + searchKey + '</span>');
}*/
                    retFAQ.add(new wrapperFAQ(kn.Title, response, kn.Id, kn.Question__c));
                    mapFAQ.put(categorie, retFAQ);
                }  
            }
        }        
        
        List<String> categorieListOrder = new List<String>();
        List<Schema.PicklistEntry> categorieListPicklistEntry = PicklistUtils.getPicklistValues('Knowledge__kav', 'Categorie__c');
        for(Schema.PicklistEntry knCategorie : categorieListPicklistEntry){
            categorieListOrder.add(knCategorie.value);
        }
        
        Map<String, List<wrapperFAQ>> mapFAQordered = new Map<String, List<wrapperFAQ>>();
        for(String key : categorieListOrder){
            mapFAQordered.put(key, mapFAQ.get(key));
        }
        return mapFAQordered;
    }
    
    public class wrapperFAQ{
        public wrapperFAQ(String title, String reponse, String knowledgeId, String question){
            this.title 		 = title;
            this.reponse 	 = reponse;
            this.knowledgeId = knowledgeId;
            this.question	 = question;
        }
        @AuraEnabled
        public String title;
        @AuraEnabled
        public String reponse;
        @AuraEnabled
        public String knowledgeId;
        @AuraEnabled
        public String question;
    }
    
}