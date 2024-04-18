/** 
* @author: Marleine Abi Khalil
* @date: 29/03/2022 
* @description: Class that test AP05_Equipement . Associated Trigger : equipementAfterUpdate, equipementAfterInsert
*/
@isTest
public class AP05_Equipement_Test {
	@isTest
	static void dissociateAssetTest(){
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){
        	Account foyerTest = new Account(Name='testPanel');
            insert foyerTest;
        
            Asset equip = new Asset(Name='testPanel');
        	equip.AccountId = foyerTest.id;
            insert equip;
            
            Id recrdCarteSim = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(Label.ASS_RT_CarteSIM).getRecordTypeId();
            Asset carteSim = new Asset(Name='testPanel');
        	carteSim.AccountId = foyerTest.id;
            carteSim.RecordTypeId = recrdCarteSim;
            carteSim.ParentId = equip.Id;
            carteSim.Audimetre__c='lklza';
            insert carteSim;
            
            Asset carteSim2 = new Asset(Name='testPanel');
        	carteSim2.AccountId = foyerTest.id;
            carteSim2.RecordTypeId = recrdCarteSim;
            carteSim2.ParentId = equip.Id;
            carteSim2.Audimetre__c='l22klza';
            insert carteSim2;
            
            Asset equip2 = new Asset(Name='testPanel');
        	equip2.AccountId = foyerTest.id;
            equip2.Audimetre__c='uiplk';
            insert equip2;
            
            carteSim.ParentId = equip2.Id;
            carteSim2.ParentId = equip2.Id;
            List<Asset> listAss = new List<Asset>{carteSim, carteSim2};
            Test.startTest();
            update listAss; 
            Test.stopTest();
        }
    }
}