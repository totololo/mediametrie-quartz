/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-21-2022
* @last modified by  : Anes BOUZOUINA
**/
@isTest
public with sharing class Batch022_CreateAppel_Test {
    
    @isTest
    public static void Batch022_CreateAppel_Test() {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('listviewRessource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        req.setHeader('SOAPAction', 'create');
        
        String b = '<?xml version="1.0" encoding="UTF-8"?>';
        b += '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">';
        b += '<soapenv:Header>';
        b += '<ns1:SessionHeader soapenv:mustUnderstand="0" xmlns:ns1="http://soap.sforce.com/2006/04/metadata">';
        b += '<ns1:sessionId>' + UserInfo.getSessionId() + '</ns1:sessionId>';
        b += '</ns1:SessionHeader>';
        b += '</soapenv:Header>';
        b += '<soapenv:Body>';
        b += '<create xmlns="http://soap.sforce.com/2006/04/metadata">';
        b += '<metadata xsi:type="ns2:ListView" xmlns:ns2="http://soap.sforce.com/2006/04/metadata">';
        //This is the API name of the list view
        b += '<fullName>account.listView2</fullName>';
        b += '<booleanFilter>1</booleanFilter>';
        //Columns you want to display
        b += '<columns>NAME</columns>';
        b += '<columns>CREATED_DATE</columns>';
        //Filterscope should be set to Everything for every one to be able to access this List view
        b += '<filterScope>Everything</filterScope>';
        // Enter the filter that you want to set

        b += '<label>Mercedes View</label>';
        b += '</metadata>';
        b += '</create>';
        b += '</soapenv:Body>';
        b += '</soapenv:Envelope>';
        
        req.setBody(b);
        req.setCompressed(false);
        // Set this to org's endpoint and add it to the remote site settings.
        req.setEndpoint('https://ap1.salesforce.com/services/Soap/m/25.0');
        HTTPResponse resp = h.send(req);
     
        List<listview> listviewLst=[select id, name, DeveloperName ,SobjectType from listview  where sobjecttype != 'report'];
        system.debug('listviewLst '+listviewLst);
        campaign cam= Test_Utils.createCampaign();
        
        for(listview lvitr : listviewlst){
            cam.Ids_des_vues_de_liste__c += string.valueof(listviewLst[0].Id)+ ',';
        }
        insert cam;
        Id batchCreate = Database.executeBatch(new Batch022_CreateAppel(), 20);
        Id batchCancel = Database.executeBatch(new Batch022_CancelAvayaCalls(), 20);

        
    }
}