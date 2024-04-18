/*
* @author: Claire VEHRLE
* @date: 15/12/2022
* @ Description Batch pour la RDD d
* @TestClass: BatchRDD12_FichierFoyer_Test
* @Coverage: -- %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD12_FichierFoyer  implements Database.Batchable<sObject>{

    public Database.Querylocator start(Database.BatchableContext bc) {
        System.debug('$$$Hello');
       return Database.getQueryLocator([SELECT Id,ContentDocument.FileType, ContentDocument.Title, LinkedEntityId
                               FROM ContentDocumentLink 
                               WHERE LinkedEntityId IN 
                               (SELECT id FROM Account 
                                WHERE (Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat 
                                    OR Type_de_foyer__c = :Label.ACC_Type_de_panel_Pame)) 
                               AND (ContentDocument.FileType = 'JPG'
                               OR ContentDocument.FileType = 'SNOTE'
                                  OR ContentDocument.FileType = 'PNG' )
                               ORDER BY ContentDocument.FileType]);
        
    }
    
    public void execute(Database.BatchableContext bc, List<ContentDocumentLink> scope) {
        System.debug('$$$scope: ' + scope);
        
        List<Account> foyerEtPanelisteList = new List<Account>();
        List<Id> foyerIdList = new List<Id>();
        Map<Id,Id> foyerIdFoyerPanelisteIdMap = new Map<Id, Id>();
        List<ContentDocumentLink> ContentDocumentToInsert = new List<ContentDocumentLink>();
        
        for (ContentDocumentLink contDocLink :scope) {
            foyerIdList.add(contDocLink.LinkedEntityId);
        }
        
        foyerEtPanelisteList = [SELECT Id, (SELECT Id FROM Panelistes__r) FROM Account WHERE Id IN :FoyerIdList];
        
        for (Account foyer: foyerEtPanelisteList) {
            foyerIdFoyerPanelisteIdMap.put(foyer.Id, foyer.Panelistes__r[0].Id);
        }
        

        for (ContentDocumentLink file : scope){
            ContentDocumentLink cDocLink = new ContentDocumentLink(); 
            id fileId = file.ContentDocumentId;
            System.debug('$$$cDocLink.LinkedEntityId: ' + cDocLink.LinkedEntityId);
            
            cDocLink.ContentDocumentId = fileId;
            cDocLink.LinkedEntityId = foyerIdFoyerPanelisteIdMap.get(file.LinkedEntityId);
            System.debug('$$$cDocLink.LinkedEntityId.getSobjectType(): ' + cDocLink.LinkedEntityId.getSobjectType());
            ContentDocumentToInsert.add(cDocLink);    
        }
        system.debug('foyer '+foyerEtPanelisteList);
        system.debug('doc insert '+ContentDocumentToInsert);
        Insert ContentDocumentToInsert;
        
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
}