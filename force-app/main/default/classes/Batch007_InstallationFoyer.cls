/*
* @author: Joyce Saidy 
* @date: 30/09/2020
* @ Description Batch pour la création de requete et intervention quand le foyer créé a le statut recruté 
* @TestClass: Batch007_InstallationFoyer_Test
* @Coverage: 94 %
* History
* <Date of modification>   <Author>    <Description of modification>
*/
global class Batch007_InstallationFoyer implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String statutFoyerRecrute = System.Label.ACC_Statut_du_foyer_Recrute;
        String query = 'Select id,Personne_de_reference__c from account where createddate =today and Statut_du_foyer__c  =: statutFoyerRecrute';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<account> scope){
         Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        List<Case> listCaseToInsert = new List<Case>();   
        Id recordTypeIdRequeteDemandePaneliste =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePaneliste).getRecordTypeId();
        for(account acc :scope)
        {
            //Create Case
            Case cs=new Case();
            cs.description=Label.CASE_Description_InstallationNouveauFoyer;
            cs.RecordTypeId=recordTypeIdRequeteDemandePaneliste;
            cs.Origin=Label.CAS_Origine_NouveauFoyer;
            cs.AccountId=acc.Id;
            cs.ContactId=Acc.Personne_de_reference__c; 
            cs.setOptions(dmo);
            listCaseToInsert.add(cs); 
        }
        
        
        if(listCaseToInsert!=null && listCaseToInsert.size()>0)
        {
            try{ 
                database.insert(listCaseToInsert);
            }Catch(exception ex){
                system.debug('Insert Case Nouveau Foyer Exception Error:'+ex.getmessage());
            }
        }
        
    }
    global void finish(Database.BatchableContext bc){
        List<Case> listCaseToCreated = new List<Case>(); 
        List<workOrder> listWOToInsert = new List<workOrder>();
        listCaseToCreated=[select id,accountId from Case
                           Where createddate=today
                           And Origin =: Label.CAS_Origine_NouveauFoyer];
        for(Case CAS:listCaseToCreated)
        {
            workOrder WO = new workOrder();
            WO.AccountId=CAS.AccountId;
            WO.CaseId=CAS.id;
            WO.Type_de_l_intervention__c=Label.WOR_Type_d_intervention_Installation;
            WO.Sous_type_d_intervention__c=Label.WOR_Sous_type_d_intervention_Nouveau_foyer;  
            listWOToInsert.add(WO);
        }
        if(listWOToInsert!=null && listWOToInsert.size()>0)
        {
            try{ 
                database.insert(listWOToInsert);
            }Catch(exception ex){
                system.debug('Insert WO Nouveau Foyer Exception Error:'+ex.getmessage());
            }
        }
    }
}