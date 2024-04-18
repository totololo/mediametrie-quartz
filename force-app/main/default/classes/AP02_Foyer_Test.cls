/*
* @author: Joyce Saidy
* @date: 17/02/2020
* @ Description Class that test AP02_Foyer . Associated Trigger : foyerAfterUpdate
* History
* <Date of modification>   <Author>    <Description of modification>
* 12/03/2021				  MZ			
*/

@istest
public class AP02_Foyer_Test {
    
    @isTest
    static void AP02_GETFoyer_Success(){
        
        String accExtId = '042f0722-5ea4-4211-8319-329320ac82ff';
        
        List <String> ListAccExternalIds = new List <String>();
        ListAccExternalIds.add(accExtId);
        
        MembreFoyerCallout_Mock fakeGetAcc = new MembreFoyerCallout_Mock(accExtId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetAcc); 
        List<AP02_Foyer.CalloutResponse> resp = AP02_Foyer.getAccountFromSipanel(ListAccExternalIds);
        Test.stopTest();
    }
    
    @isTest
    static void AP02_GETFoyer_Error(){
        
        String accExtId = '04722-5ea4';
        
        List <String> ListAccExternalIds = new List <String>();
        ListAccExternalIds.add(accExtId);
        
        MembreFoyerCallout_Mock fakeGetAcc = new MembreFoyerCallout_Mock(accExtId);
         Account acc = Test_Utils.createFoyer();
        insert acc;
        Test.startTest();
        acc.name = 'test1234';
        update acc; 
        Test.setMock(HttpCalloutMock.class, fakeGetAcc); 
       // List<AP02_Foyer.CalloutResponse> resp = AP02_Foyer.getAccountFromSipanel(ListAccExternalIds); 
        Test.stopTest();
    }
    
    @isTest
    static void AP02_SendFoyer(){
        

        Account acc = Test_Utils.createFoyer();
        insert acc;
        
        List <String> ListAccExternalIds = new List <String>();
        ListAccExternalIds.add(acc.Id);
        
        MembreFoyerCallout_Mock fakeSendAcc = new MembreFoyerCallout_Mock(acc.Id);
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, fakeSendAcc);
        List<AP02_Foyer.CalloutResponse> resp = AP02_Foyer.getAccountFromSipanel(ListAccExternalIds); 
        
        AP02_Foyer.sendAccountToSiPanel(ListAccExternalIds);
        Test.stopTest();
    }
}