/*
* @author: Khaled Hammoudeh
* @date: 30/10/2020
* @ Description Class sends a mock response for the send SMS integration  
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
@istest
public class SendSMSCallout_Mock implements HttpCalloutMock {
    
    public HttpResponse respond(httpRequest req)
    {
        httpResponse httpRes = new httpResponse();
        //Fake response for the fields
        if(req.getEndpoint() == (Label.NP6_EndPoint + 'fields'))
        {
            list<SmsNp6_Manager.FieldsWrap> listFieldWrapResp = new list<SmsNp6_Manager.FieldsWrap>();
            
            SmsNp6_Manager.FieldsWrap fieldWrapResp1 = new SmsNp6_Manager.FieldsWrap();
            fieldWrapResp1.type = 'phone';
            fieldWrapResp1.Name = 'portable';
            fieldWrapResp1.Id = '1111';
            listFieldWrapResp.add(fieldWrapResp1);
            
            SmsNp6_Manager.FieldsWrap fieldWrapResp2 = new SmsNp6_Manager.FieldsWrap();
            fieldWrapResp2.type = 'email';
            fieldWrapResp2.Name = 'EMAIL';
            fieldWrapResp2.Id = '2222';
            listFieldWrapResp.add(fieldWrapResp2);
            
            SmsNp6_Manager.FieldsWrap fieldWrapResp3 = new SmsNp6_Manager.FieldsWrap();
            fieldWrapResp3.type = 'date';
            fieldWrapResp3.Name = 'date';
            fieldWrapResp3.Id = '3333';
            listFieldWrapResp.add(fieldWrapResp3);
            
            SmsNp6_Manager.FieldsWrap fieldWrapResp4 = new SmsNp6_Manager.FieldsWrap();
            fieldWrapResp4.type = 'textArea';
            fieldWrapResp4.Name = 'heure';
            fieldWrapResp4.Id = '4444';
            listFieldWrapResp.add(fieldWrapResp4);
            
            httpRes.setHeader('Content-Type', 'application/json');
            httpRes.setBody(json.serialize(listFieldWrapResp));
            httpRes.setStatusCode(200);
            
        }else if(req.getEndpoint() == (Label.NP6_EndPoint + 'actions'))
        {
            list<targetObj> listTargetObjResp = new list<targetObj>();
            targetObj tagetResp1 = new targetObj();
            tagetResp1.id = '1234';
            tagetResp1.name = Label.NP6_SMSConfirmationRendezVous;
            listTargetObjResp.add(tagetResp1);
            
            httpRes.setHeader('Content-Type', 'application/json');
            httpRes.setBody(json.serialize(listTargetObjResp));
            httpRes.setStatusCode(200);
        }
        return httpRes;
    }
    
    public class targetObj {
        public string id {get;set;}
        public string name {get;set;}
    }
}