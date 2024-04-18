/*
* @Auteur Claire VEHRLE
* @date: 21/12/2022
* @Classe: BatchRDD12_FichierFoyer
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD12_FichierFoyer_Test {
    
    @isTest
    static void RDD_Fichier () {
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id foyerPanelisteId;
        
        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        foyer1.Numero_de_portable__c = '0611111121';
        foyer1.Tech_RDD_fichier_OK__c=false;
        foyerList.add(foyer1);
        
        insert foyerList;
        system.debug('foy '+foyer1.id);
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste1);
        
        insert foyerPanelisteList;
        
        ContentVersion note = new ContentVersion();
        note.title = 'note';      
        note.VersionData =Blob.valueOf('Test Content'); 
        note.PathOnClient= 'note.snote';  
        insert note;
        ContentVersion cvIns = [SELECT Id, OwnerId,ContentDocumentId,ContentDocument.FileType from ContentVersion where Id=:note.Id];
        system.debug('type '+cvIns.ContentDocument.FileType);
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        cDocLink.LinkedEntityId=foyer1.id;
		cDocLink.ContentDocumentId=cvIns.ContentDocumentId;
        cDocLink.ShareType='V';
        insert cDocLink;
        
        id idNote = cvIns.ContentDocumentId;
        id newLink;
        system.debug('note '+idNote);
        system.debug('foy pan '+foyerPaneliste1.id);
        test.startTest();
        BatchRDD12_FichierFoyer obj = new BatchRDD12_FichierFoyer();
        DataBase.executeBatch(obj);  
        test.stopTest();
        
        list<ContentDocumentLink> alllink = [select id,LinkedEntityId from ContentDocumentLink where ContentDocumentId =: idNote ];
        system.debug('size '+alllink.size());
        for (ContentDocumentLink link:alllink ){
            system.debug('link '+link.LinkedEntityId);
            if (link.LinkedEntityId==foyerPaneliste1.id){
                 newLink = link.LinkedEntityId;
            }
        }
        system.assertEquals(newlink, foyerPaneliste1.id);
        /*
        List<ContentDocumentLink> LinkList = new List<ContentDocumentLink>();
        ContentDocumentLink cDocLink = new ContentDocumentLink();
        ContentVersion file = new ContentVersion();
        file.Title='image';
        file.PathOnClient = 'Pic.jpg';
        file.VersionData = Blob.valueOf('Test Content');
        insert file;
       
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        id img = documents[0].id;
		cDocLink.ContentDocumentId = img;
        cDocLink.LinkedEntityId = foyer1.Id;
        insert cDoclink;
        
        
        BatchRDD12_FichierFoyer obj = new BatchRDD12_FichierFoyer();
        DataBase.executeBatch(obj);  
        
        System.debug('$$$$$$$$$$$$$$$$$');
        
		LinkList = [select id,LinkedEntityId from ContentDocumentLink WHERE ContentDocumentId =: img];
        /*for (ContentDocumentLink cl: LinkList){
            System.debug('$$$cl:' + cl);
            System.debug('$$$Schema.Foyer_Paneliste__c.SObjectType:' + Schema.Foyer_Paneliste__c.SObjectType);
            System.debug('$$$cl.LinkedEntityId:' + cl.LinkedEntityId);
            System.debug('$$$cl.LinkedEntityId.getSobjectType():' + cl.LinkedEntityId.getSobjectType());
            if (Schema.Foyer_Paneliste__c.SObjectType == cl.LinkedEntityId.getSobjectType()){
                System.debug('$$$ IF');
                foyerPanelisteId = cl.LinkedEntityId;
            }
        }
        System.debug('$$$foyerPaneliste1.Id: ' + foyerPaneliste1.Id);
        System.debug('$$$foyer1.Id: ' + foyer1.Id);
        System.debug('$$$foyerPanelisteId: ' + LinkList[0].LinkedEntityId);
        system.assertEquals(foyerPaneliste1.Id, LinkList[0].LinkedEntityId);*/
    }

}