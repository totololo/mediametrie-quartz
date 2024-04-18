/*
* @author: Téoman Sertçelik
* @date: 30/03/2022
* @ Description: Classe qui test AP01_BandeUsine les méthodes : getBandeUsine // sendBandeUsineToOCOM // createHttpRequest
* @TestClass: 
* @Coverage:
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */

@isTest
public with sharing class AP01_BandeUsine_Test {

    @isTest
    static void AP01_SendBandeUsine_Success(){
        
        Bande_Usine__c bandeUsine = new Bande_Usine__c();
        bandeUsine.name = 'BUTest';
        
        insert bandeUsine;
        
        List <String> listBandeUsineIds = new List <String>();
        listBandeUsineIds.add(bandeUsine.Id);
        
        IndividuPanelisteCallout_Mock fakeGetBandeUsine = new IndividuPanelisteCallout_Mock(bandeUsine.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetBandeUsine); 
        List<AP01_BandeUsine.CalloutResponse> resp = AP01_BandeUsine.getBandeUsine(listBandeUsineIds);
        Test.stopTest();
    }
    
}