public with sharing class ContactFormulaire {
    
    // Cache for UI API calls
    private final static Map<String, PicklistEntries> uiApiCache = new Map<String, PicklistEntries>();
    
    public static String demandePenalisteId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_Paneliste').getRecordTypeId();
    public static String demandePenalisteAIPId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_Paneliste_AIP').getRecordTypeId();
    
    @AuraEnabled
    public static onLoadWrapper onPageInit(String currentPage){
        onLoadWrapper onLoadWrapper = new onLoadWrapper();
        onLoadWrapper.contactType = contactType();
        String recordTypeId = onLoadWrapper.contactType == 'AIP' ? demandePenalisteAIPId : demandePenalisteId;
        PicklistUtils.PicklistEntries entries = PicklistUtils.getPicklistValues(
            'Case',
            recordTypeId,
            'Type'
        );
        list<Formulaire__mdt> mdtLst = new list<Formulaire__mdt>();
        set<String> typeList = new set<String>();
        if(currentPage == 'Commander'){
            //Mettre les metadatatype
            mdtLst = onLoadWrapper.contactType == 'AIP' ?
                [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Commander'   and user_type__c='AIP' order by Type_portail__c ]
                :
            [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Commander'   and user_type__c!='AIP' order by Type_portail__c];  
                
                } else if(currentPage == 'Absence'){
                    mdtLst = onLoadWrapper.contactType == 'AIP' ?
                        [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Absence'   and user_type__c='AIP' order by Type_portail__c]
                        :
                    [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Absence'   and user_type__c!='AIP' order by Type_portail__c];  
                        } else if(currentPage == 'NousContacter'){
                            mdtLst = onLoadWrapper.contactType == 'AIP' ?
                                [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Nous Contacter'   and user_type__c='AIP'order by Type_portail__c ]
                                :
                            [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Nous Contacter'   and user_type__c!='AIP' order by Type_portail__c];    
                                } else if(currentPage == 'Planifier un RDV'){
                                    mdtLst = onLoadWrapper.contactType == 'AIP' ?
                                        [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Planifier un RDV' and user_type__c='AIP' order by Type_portail__c]
                                        :
                                    [SELECT Type_portail__c, user_type__c from Formulaire__mdt where Formulaire__c='Planifier un RDV'  and user_type__c!='AIP' order by Type_portail__c];    
                                        
                                        
                                        if(onLoadWrapper.contactType == 'AIP'){
                                            onLoadWrapper.appointmentStartTime = 11;
                                            onLoadWrapper.appointmentEndTime = 21;
                                        }else {
                                            onLoadWrapper.appointmentStartTime = 9;
                                            onLoadWrapper.appointmentEndTime = 20;
                                        }
                                }
        for(Formulaire__mdt mdtItr :mdtLst ){
            typeList.add( String.valueOf(mdtItr.Type_portail__c));
        }
        onLoadWrapper.typeList.addAll(typeList);
        
        
        onLoadWrapper.fieldDependenciesMap = getFieldDependencies('Case', 'Type', 'Sous_type__c');
        System.debug('bastien typeList : ' + onLoadWrapper.typeList);
        return onLoadWrapper;
    }
    
     @AuraEnabled
    public static String MentionsLegales(){                
        return [
            Select Id, Name, Content__c, Content_formatted__c 
            from Portal_long_text__c 
            where Name=:label.POR_Name_ML
        ].get(0).Content_formatted__c;
    }
    
    @AuraEnabled
    public static InitWhrapper ContactCgu(){
        InitWhrapper Whrapper = new InitWhrapper();
        
        Whrapper.cgu = [
            Select Id, Name, Content__c, Content_formatted__c 
            from Portal_long_text__c 
            where Name=:label.POR_Name_CGU
        ].get(0).Content_formatted__c;
        
        return Whrapper;
    }
    
      @AuraEnabled
    public static InitWhrapper ContactCguPopUp(){
        InitWhrapper Whrapper = new InitWhrapper();
        
        Whrapper.result = [Select Id, ContactId, contact.CGU__c
                           FROM User
                           WHERE Id = :UserInfo.getUserId() ].get(0).contact.CGU__c;
        
        Whrapper.cgu = [
            Select Id, Name, Content__c, Content_formatted__c 
            from Portal_long_text__c 
            where Name=:label.POR_Name_CGUPopUp
        ].get(0).Content_formatted__c;
        
        return Whrapper;
    }
    
    @AuraEnabled
    public static void updateContactCgu(){
        Id contactId = [SELECT Id, ContactId  
                        FROM User 
                        WHERE Id = :UserInfo.getUserId() ].get(0).ContactId;
        List<Contact> contactList=[SELECT Id, CGU__c FROM Contact Where id = : contactId ];
        if(contactList.size() == 1){
            for(Contact c : contactList){
                if(c.CGU__c==false){
                    c.CGU__c=true; 
                    update c; 
                }  
                
            }
            
        }
        
    } 
    @AuraEnabled
    public static String contactType() {
        String individuPenaliste; 
        Id contactId = [SELECT Id, ContactId  
                        FROM User 
                        WHERE Id = :UserInfo.getUserId() ].get(0).ContactId;
        
        for(Individu_Paneliste__c ind :[SELECT Id, Foyer_paneliste__r.RecordType.DeveloperName, 
                                        Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c
                                        FROM Individu_Paneliste__c 
                                        WHERE Composition_du_foyer__c = :contactId
                                        LIMIT 1])
        {
            individuPenaliste = ind.Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c;
            System.debug('Type de panel' + ind.Foyer_paneliste__r.Referentiel_Panel__r.Type_de_panel__c);
        }
        return individuPenaliste;
    }
    
    public static List<wrapperType> getPicklistValues(Schema.sObjectField field) {
        // Get all picklist values
        List<Schema.PicklistEntry> entries = field.getDescribe().getPickListValues();
        // Only return active picklist values
        List<wrapperType> pickListValuesList= new List<wrapperType>();
        for (Schema.PicklistEntry entry : entries) {
            if (entry.isActive()) {
                wrapperType wr = new wrapperType();
                wr.label = entry.getLabel();
                wr.value = entry.getValue();
                pickListValuesList.add(wr);
            }
        }
        return pickListValuesList;
    }
    @AuraEnabled
    public static List<string> getsousType( String motif, String Formulaire ) {
        system.debug( 'motif' + motif);
        system.debug( 'Formulaire' + Formulaire);
        String typeContact = contactType(); 
        list<Formulaire__mdt> soustypeLst = new   list<Formulaire__mdt>();
        if(typeContact== 'AIP'){
            soustypeLst = [SELECT Sous_type_portail__c, Formulaire__c, user_type__c, Type_portail__c
                           from Formulaire__mdt 
                           where  Type_portail__c=:motif 
                           and user_type__c = 'AIP'
                           and Formulaire__c=: Formulaire 
                           order by Sous_type_portail__c];
        }
        else
        {
            soustypeLst = [SELECT Sous_type_portail__c, Formulaire__c, user_type__c, Type_portail__c
                           from Formulaire__mdt 
                           where  Type_portail__c=: motif 
                           and user_type__c != 'AIP'
                           and Formulaire__c =: Formulaire
                           order by Sous_type_portail__c];
        }
        system.debug('motif '+ motif);
        system.debug('Formulaire '+ Formulaire);
        system.debug('soustypeLst '+ soustypeLst);
        List<string> soustypeLstToReturn = new List<string>();
        for(Formulaire__mdt frmItr: soustypeLst){
            soustypeLstToReturn.add(frmItr.Sous_type_portail__c);
        }
        return soustypeLstToReturn;
    }
    
    @AuraEnabled
    public static Boolean createNousContactezCase(String type, String sousType, String motif, String description, Date startDate, Date endDate, String documentId){ 
        return AddFileToCase.addAttachment(documentId, type, sousType, description, null, null, null, null, 'Nous Contacter', null, null);
    }
    
    @AuraEnabled
    public static Boolean createCommandeCase(String type, String sousType, String motif, String description, Date startDate, Date endDate, String documentId){ 
        return AddFileToCase.addAttachment(documentId, type, sousType, description, null, null, null, null, 'Commander', null, null);
    }
    
    @AuraEnabled
    public static Boolean createRendezVousCase(String type, String sousType, String description, String startDate, String appointmentTime){ 
        return AddFileToCase.addAttachment(null, type, sousType, description, null, startDate, null, null, 'Planifier un RDV', appointmentTime, null);
    }
    
    @AuraEnabled
    public static Boolean createAbsenceCase(String type, String sousType, String motif, String description, String startDate, 
                                            String endDate, String documentId){ 
                                                return AddFileToCase.addAttachment(documentId, type, sousType, description, null, startDate, endDate, null, 'Absence', null, motif);
                                            }
    
    @AuraEnabled
    public static List<wrapperType> typeValues(){ 
        List<wrapperType> pickListValuesList= new List<wrapperType>();
        Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            wrapperType wr = new wrapperType();
            wr.label = pickListVal.getLabel();
            wr.value = pickListVal.getValue();
            pickListValuesList.add(wr);
            
        }     
        return pickListValuesList;
    }
    
    @AuraEnabled
    public static List<wrapperType> statusValues(){
        List<wrapperType> pickListValuesList= new List<wrapperType>();
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            wrapperType wr = new wrapperType();
            wr.label = pickListVal.getLabel();
            wr.value = pickListVal.getValue();
            pickListValuesList.add(wr);
            
        }     
        return pickListValuesList;
    }
    
    
    @AuraEnabled
    public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField){
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
        List<PicklistEntry> entriesValues = new List<PicklistEntry>();
        for(Schema.PicklistEntry currControllingValue : controllingValues) {
            controllingInfo.put(currControllingValue.getValue(), new List<String>());
        }
        String contactType = contactType();
        String recordTypeId = contactType == 'AIP' ? demandePenalisteAIPId : demandePenalisteId;
        PicklistUtils.PicklistEntries entries = PicklistUtils.getPicklistValues(
            objectName,
            recordTypeId,
            dependentField
        );
        Set<String> allValues = new Set<String>();
        
        for(PicklistUtils.PicklistEntry pickListVal : entries.values){
            allValues.add(pickListVal.value.unescapeHtml4());
        }
        
        for(Schema.PicklistEntry currDependentValue : dependentValues) {
            if(allValues.contains(currDependentValue.getValue())){
                String jsonString = JSON.serialize(currDependentValue);
                MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
                String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
                Integer baseCount = 0;
                //toLowerCase can be changed to uppercase and getLabel() can be changed to getValue() based on requirement.
                for(Integer curr : hexString.getChars()) {
                    Integer val = (curr >= 65)?(curr - 65 + 10) : (curr - 48);
                        if((val & 8) == 8) {
                            controllingInfo.get(controllingValues[baseCount + 0].getValue()).add(currDependentValue.getLabel());
                        }
                    if((val & 4) == 4) {
                        controllingInfo.get(controllingValues[baseCount + 1].getValue()).add(currDependentValue.getLabel());
                    }
                    if((val & 2) == 2) {
                        controllingInfo.get(controllingValues[baseCount + 2].getValue()).add(currDependentValue.getLabel());
                    }
                    if((val & 1) == 1) {
                        controllingInfo.get(controllingValues[baseCount + 3].getValue()).add(currDependentValue.getLabel());
                    }
                    baseCount += 4;
                }
            }
        }
        return controllingInfo;
    }
    
    class MyPickListInfo {
        public String validFor;
    }
    
    /*WRAPPERS*/
    public class wrapperType {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }
    
    public class onLoadWrapper {
        public onLoadWrapper(){
            this.typeList = new List<String>();
            this.statusList = new List<wrapperType>();
            this.sousTypeList = new List<String>();
            this.contactType = '';
            this.fieldDependenciesMap = new Map<String, List<String>>();
        }
        
        @AuraEnabled
        public List<String> typeList;
        @AuraEnabled
        public List<wrapperType> statusList;
        @AuraEnabled
        public List<String> sousTypeList;
        @AuraEnabled
        public Integer appointmentStartTime;
        @AuraEnabled
        public Integer appointmentEndTime;
        @AuraEnabled
        public String contactType;
        @AuraEnabled
        public Map<String, List<String>> fieldDependenciesMap;
    }
    
    public class PicklistEntries {
        public PicklistEntry defaultValue;
        public List<PicklistEntry> values;
    }
    
    public class PicklistEntry {
        public String label;
        public String value;
    }
    
    public class InitWhrapper {
		@AuraEnabled
        public String cgu;
        @AuraEnabled
        public Boolean result;
    }
}