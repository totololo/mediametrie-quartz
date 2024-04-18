public with sharing class AddFileToCase {
    @AuraEnabled
    public static Boolean addAttachment(String fileContentVersionId, String typeValue, String sousTypeValue, String descriptionValue, 
                                        String statusValue, String dateDebut ,String dateFin, String pointDebit, String functionName, 
                                        String appointmentTime, String motif) {    
                                            system.debug('fileContentVersionId'+fileContentVersionId);
                                                                      system.debug('fileContentVersionId'+String.isNotBlank(fileContentVersionId));
                  
                                            
                                            Boolean caseCreated = false;
                                            Id contactId = [SELECT Id, ContactId  
                                                            FROM User 
                                                            WHERE Id = :UserInfo.getUserId() ].get(0).ContactId;
                                            
                                            //Case RecordType Id
                                            String demandePenalisteId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_Paneliste').getRecordTypeId();
                                            String demandePenalisteAIPId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Demande_Paneliste_AIP').getRecordTypeId();
                                            String caseRecordId;
                                            String FoyerPanId;
                                            for(Individu_Paneliste__c ind :[SELECT Id, Foyer_paneliste__r.RecordType.DeveloperName, Foyer_paneliste__c 
                                                                            FROM Individu_Paneliste__c 
                                                                            WHERE Composition_du_foyer__c = :contactId]){
                                                                                caseRecordId = ind.Foyer_paneliste__r.RecordType.DeveloperName == 'AIP' ? demandePenalisteAIPId : demandePenalisteId;
                                                                                FoyerPanId = ind.Foyer_paneliste__c;
                                                                            }
                                            System.debug('caseRecordId ' + caseRecordId);
                                            
                                            //recuperer la picklist value en fonction de metadata type on prenant en compte les sous types
                                            List<Formulaire__mdt> frmlList = ContactFormulaire.contactType() ==  'AIP' ?
                                                [SELECT Sous_type_SF__c, Type_SF__c ,formulaire__c
                                                 from Formulaire__mdt 
                                                 where Type_portail__c =: typeValue
                                                 and Sous_Type_portail__c =: sousTypeValue
                                                 and Formulaire__c =: functionName   
                                                 and user_type__c='AIP'
                                                 limit 1]
                                                :
                                     [SELECT Sous_type_SF__c, Type_SF__c,formulaire__c 
                                                 from Formulaire__mdt 
                                                 where Type_portail__c =: typeValue
                                                 and Sous_Type_portail__c =: sousTypeValue
                                                 and Formulaire__c =: functionName   
                                                 and user_type__c!='AIP'
                                                 limit 1];
 											system.debug('anes typeValue '+typeValue+'anes sousTypeValue ' +sousTypeValue+'anes frmlList '+functionName+'anes contactType '+ ContactFormulaire.contactType()  );
                                            
                                            System.debug('frmlList ' +frmlList);
                                            if (frmlList.size()>0){
                                            Case newCase = new Case(
                                                RecordTypeId = caseRecordId,
                                                Type = frmlList[0].Type_SF__c,
                                                Sous_type__c = frmlList[0].Sous_type_SF__c,
                                                Description = descriptionValue,
                                                Origin = 'Web',
                                                Foyer_paneliste__c=FoyerPanId
                                            );
                                            System.debug('newCase ' + newCase);
                                            
                                            if(functionName == 'commander'){
                                                //newCase.Nombre_De_Point_a_Debiter__c =integer.valueof(pointDebit);
                                            }else if(functionName == 'Absence'){
                                                newCase.Date_Debut__c = Date.valueOf(dateDebut);
                                                newCase.Date_Fin__c = Date.valueOf(dateFin);
                                                newCase.Motif_de_la_requete__c = motif;
                                               newCase.Subject = 'Du ' + Date.valueOf(dateDebut).day()+ '-' + Date.valueOf(dateDebut).month()+ '-'+ Date.valueOf(dateDebut).year() + ' Au ' + Date.valueOf(dateFin).day()+ '-'+ Date.valueOf(dateFin).month()+ '-' + Date.valueOf(dateFin).year();
                                            } else if(functionName == 'Planifier un RDV'){
                                                Date startDate =  Date.valueOf(dateDebut); 
                                                newCase.Subject = 'Le '+ Date.valueOf(dateDebut).day()+ '-' + Date.valueOf(dateDebut).month()+ '-'+ Date.valueOf(dateDebut).year() +', '+ appointmentTime ;
                                                List<String> appointmentTimeList = appointmentTime.split('-');
                                                if(appointmentTimeList.size() > 1){    
                                                    List<String> timeList = appointmentTimeList[0].split(':');
                                                    if(timeList.size() == 2){
                                                        System.debug('Integer.valueOf(timeList[1]) ' + Integer.valueOf(timeList[1]));
                                                        System.debug('Integer.valueOf(timeList[0]) ' + Integer.valueOf(timeList[0]));
                                                        newCase.Date_Debut__c = Datetime.newInstanceGmt(Integer.valueOf(startDate.year()), Integer.valueOf(startDate.month()),
                                                                                                        Integer.valueOf(startDate.day()), Integer.valueOf(timeList[0]),
                                                                                                        Integer.valueOf(timeList[1]), 0);
                                                        System.debug('newCase.Date_Debut__c ' + newCase.Date_Debut__c);
                                                    }
                                                    timeList = appointmentTimeList[1].split(':');
                                                    if(timeList.size() == 2){
                                                        System.debug('Integer.valueOf(timeList[1]) ' + Integer.valueOf(timeList[1]));
                                                        System.debug('Integer.valueOf(timeList[0]) ' + Integer.valueOf(timeList[0]));
                                                        newCase.Date_Fin__c = Datetime.newInstanceGmt(Integer.valueOf(startDate.year()), Integer.valueOf(startDate.month()),
                                                                                                      Integer.valueOf(startDate.day()), Integer.valueOf(timeList[0]),
                                                                                                      Integer.valueOf(timeList[1]), 0);
                                                        System.debug('newCase.Date_Fin__c ' + newCase.Date_Fin__c);
                                                    }
                                                }else{
                                                    newCase.date_en_cours__c = startDate;
                                                } 
                                            }     
                                            try {
                                                insert newCase;
                                                if(String.isNotBlank(fileContentVersionId)){
                                                    insertAttachment(fileContentVersionId, Id.valueOf(newCase.Id));
                                                }
                                                caseCreated = true;
                                            } catch(DMLException e) {
                                                System.debug('An unexpected error has occurred Case: ' + e.getMessage());
                                            }
                                            }
                                            return caseCreated;
                                        
                                            }
    
    private static void insertAttachment(String fileContentVersionId, String newCase){
        System.debug('fileContentVersionId ' + fileContentVersionId);
        list<contentVersion> acc = [SELECT contentDocumentid FROM contentVersion WHERE Id=:fileContentVersionId];
        system.debug('acc = '+acc );
        if (acc.size()>0){
        string Versid = [SELECT contentDocumentid 
                         FROM contentVersion
                         WHERE Id=:fileContentVersionId].ContentDocumentid;
        
        ContentDocumentLink DocLink = new ContentDocumentLink(
            ContentDocumentId = Versid,
            LinkedEntityId = newCase,
            ShareType = 'I',
            Visibility = 'AllUsers'
        );
        
        System.debug('DocLink ' + DocLink);
        try {
            insert doclink; 
        } catch(DMLException e) {
            System.debug('An unexpected error has occurred ContentDocumentLink : ' + e.getMessage());
        }
        }
    }
}