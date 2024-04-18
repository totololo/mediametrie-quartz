@istest
public class AP01_ContentDocLink_Test {
    public static testmethod void AP01_ContentDocLinkTest(){
        
     List<ContentDocumentLink> LinkList = new List<ContentDocumentLink>();
	  id Accid ;
        
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        //u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer;AP08_FoyerPaneliste;AP03_Individu_paneliste';
        u.Bypass_flows__c = true;
        update u;
        
        system.runAs(u){
            
        //create foyer
        Foyer_paneliste__c testAccount = Test_Utils.createFoyerPaneliste();
        testAccount.Statut_Foyer_paneliste__c='0';
        insert  testAccount; 
        
        //create inter
        WorkOrder WO1 =new WorkOrder(); 
        WO1.Foyer_paneliste__c=testAccount.id; 
        WO1.Tech_TestClass__c = true;
        insert WO1;
        
        workorder wo = [select id from workorder where Foyer_paneliste__c=:testAccount.Id];
        ContentDocumentLink cDocLink = new ContentDocumentLink();

        ContentVersion file = new ContentVersion();
        file.Title='image';
        file.PathOnClient   = 'Pic.jpg';
        file.VersionData    = Blob.valueOf('Test Content');
        insert file;
       
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        id img=documents[0].id;
		cDocLink.ContentDocumentId = img;
        cDocLink.LinkedEntityId = wo.Id;
        //cDocLink.ShareType='C';
        insert cDoclink;
            test.startTest();
		LinkList = [select id,LinkedEntityId from ContentDocumentLink where ContentDocumentId =: img  ];
        for (ContentDocumentLink cl: LinkList){
            if (Schema.Foyer_paneliste__c.SObjectType==cl.LinkedEntityId.getSobjectType()){
                Accid=cl.LinkedEntityId;
            }
        }
        
        system.assertEquals(testAccount.Id,Accid);
       Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id));
             Test.stopTest();
        }
        u.Bypass_flows__c=false;
        update u;
    }
}