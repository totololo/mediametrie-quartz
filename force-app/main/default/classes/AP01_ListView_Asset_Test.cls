/*
* @Auteur : Nancy Al Kalach
* @date: 20/07/2021
* @Classe: AP01_ListView_Asset
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class AP01_ListView_Asset_Test {
    @isTest
    private static void init(){
        Id recordTypeIdEQTMesureAIP = Schema.SObjectType.Asset.getRecordTypeInfosByName().get(label.ASS_RecordType_DispositifsMesureAudienceAIP).getRecordTypeId();
       
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Asset asset = new Asset();
        asset.Name = 'asset';
        asset.AccountId = acc.Id;
        asset.RecordTypeId =  recordTypeIdEQTMesureAIP;
        insert asset;
	 	List<Asset> assets = new List<Asset>();
        assets.add(asset);
        
        PageReference pageRef = Page.VF_ListViewAsset;
       	Test.setCurrentPageReference(pageRef);
        pageRef.getParameters().put('id',asset.id);
            
        ApexPages.StandardSetController controller = new ApexPages.StandardSetController(assets);
        controller.setSelected(assets);
		AP01_ListView_Asset assetExtension = new AP01_ListView_Asset(controller);
       
		Test.startTest();
		assetExtension.show();
        assetExtension.back();
        delete asset;
        
		Test.stopTest();
    }
}