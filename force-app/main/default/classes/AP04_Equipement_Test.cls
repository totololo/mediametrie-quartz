/** 
* @author: Marleine Abi Khalil
* @date: 16/03/2022 
* @description: Class that test AP04_Equipement . Associated Trigger : equipementAfterUpdate
*/
@isTest
global class AP04_Equipement_Test implements HttpCalloutMock {
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('Successfull');
        response.setStatusCode(200);
        return response; 
    }
    
    @isTest
	static void sendOcomTest(){
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){
        	Account foyerTest = new Account(Name='testPanel');
            insert foyerTest;
        
            Asset equip = new Asset();
            equip.Name='testPanel';
        	equip.AccountId = foyerTest.id;
            insert equip;
            
            equip.Status= Label.Asset_Status_Supprime;
            Test.startTest();
            update equip;
            Test.setMock(HttpCalloutMock.class, new AP04_Equipement_Test());
            Test.stopTest();
        }
    }

}