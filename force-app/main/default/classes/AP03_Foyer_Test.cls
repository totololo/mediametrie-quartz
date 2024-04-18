/*
* @author: Maribelle Zarazir
* @date: 12/03/2021
* @ Description Class that test AP03_Foyer
* History
* <Date of modification>   <Author>    <Description of modification>		
*/

@istest
public class AP03_Foyer_Test {
    
    @isTest
    static void AP03_GETAssets_Success(){
        
        String accExtId = '042f0722-5ea4-4211-8319-329320ac82ff';
        
        List <String> ListAccExternalIds = new List <String>();
        ListAccExternalIds.add(accExtId);
        
        MembreFoyerCallout_Mock fakeGETAssets = new MembreFoyerCallout_Mock(accExtId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGETAssets); 
        List<AP03_Foyer.CalloutResponse> resp = AP03_Foyer.getAssetsFromSipanel(ListAccExternalIds);
        Test.stopTest();
    }
    
     @isTest
    static void AP03_GETAssets_Error(){
        
        String accExtId = '04722-5ea4';
        
        List <String> ListAccExternalIds = new List <String>();
        ListAccExternalIds.add(accExtId);
        
        MembreFoyerCallout_Mock fakeGETAssets = new MembreFoyerCallout_Mock(accExtId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGETAssets); 
        List<AP03_Foyer.CalloutResponse> resp = AP03_Foyer.getAssetsFromSipanel(ListAccExternalIds);
        Test.stopTest();
    }
}