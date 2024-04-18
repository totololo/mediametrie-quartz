// YH 
// classe pour dupliquer les fichiers de l'inter vers le foyer panéliste

public class AP01_ContentDocLink {
    public static void CloneFile(list<ContentDocumentLink> ListNewFiles){
        list<id> idInter = new list<id>(); // la liste des linkids
        
        //list<account> ListeFoyer = new list<account>(); // liste foyer associé à l'inter
        list<ContentDocumentLink> finalList = new list<ContentDocumentLink>();// liste à insérer
        list<id> foyerPanID = new list<id>();
        
        for ( ContentDocumentLink file : ListNewFiles){
            system.debug('content'+ListNewFiles);
            system.debug('size'+ListNewFiles.size());
            if (Schema.Workorder.SObjectType==file.LinkedEntityId.getSobjectType()){
                idInter.add(File.LinkedEntityId);
            }
            
            system.debug('idlink'+file.LinkedEntityId );
            system.debug('idinter'+idInter);
           
        }
        for (workorder wo: [select id,Foyer_paneliste__c from workorder where id in:idInter]){
            foyerPanID.add(wo.Foyer_paneliste__c);
            system.debug('foyer'+foyerPanID);
        }
        
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        for ( ContentDocumentLink file : ListNewFiles){
            id fileId=file.ContentDocumentId;
            
            for (id foyId: foyerPanID){
                if (cDocLink.LinkedEntityId != foyId){
                    cDocLink.ContentDocumentId = fileId;
                    cDocLink.LinkedEntityId = foyId;
                    finalList.add(cDocLink);    
                }
            }
        }
       
        if (finalList.size()>0){
            system.debug('size'+finalList.size());
            insert finalList;
        }
       
    }
}