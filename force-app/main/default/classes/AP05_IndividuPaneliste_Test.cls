/*
* @author: Téoman Sertçelik
* @date: 30/03/2022
* @ Description: Classe qui test AP05_IndividuPaneliste qui évoque le flux mulesoft pour récupérer l'activité audimétrique de l'ind pan de Google
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */


@isTest
public with sharing class AP05_IndividuPaneliste_Test /*implements HttpCalloutMock*/ {

   /*  global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('Successfull');
        response.setStatusCode(200);
        return response; 
    }  */

    @isTest
    static void AP02_GETActivityAudi_Success(){
        
        String individuPanelisteId = '25c135fb-8a34-4db7-8ca3-70bc810b0635';
        
        List <String> listIndividuPanelisteIds = new List <String>();
        listIndividuPanelisteIds.add(individuPanelisteId);
        
        IndividuPanelisteCallout_Mock fakeGetIndividuPanel = new IndividuPanelisteCallout_Mock(individuPanelisteId);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeGetIndividuPanel); 
        //Test.setMock(HttpCalloutMock.class, new AP05_IndividuPaneliste());
        List<AP05_IndividuPaneliste.CalloutResponse> resp = AP05_IndividuPaneliste.getIndPanActivityAudiFromGoogle(listIndividuPanelisteIds);
        Test.stopTest();
    }

}