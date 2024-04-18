/*
* @author:Khaled Hammoudeh
* @date: 07/10/2020
* @ Description:  Class that contains the methods of integration with NP6
* @TestClass:  AP01_SendSMS
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*/
public class SmsNp6_Manager { 
    
    //callout method (Request/Response)
    public static HttpResponse calloutResponseJSON(String EndPoint,String Restmethod,String ContentType, string contentLength, String body)
    { 
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setTimeout(120000);
        req.setEndpoint(EndPoint);
        req.setMethod(Restmethod); 
        req.setHeader('X-Key',Label.NP6_Key);
        if(body!=null)
        {
            req.setBody(body);
        }
        if(ContentType != null)
        {
            req.setHeader('Content-Type',ContentType); 
        }
        if(contentLength != Null){ req.setHeader('Content-Length', contentLength);
        }
         System.debug('req###'+req); 
        HttpResponse res = http.send(req);  
        System.debug('res###'+res); 
        return res;
    } 
    
    //Method to get a map of fields using to send an SMS
    public static map<String,FieldsWrap> GetallFields()
    {
        String fieldMapping = label.FieldMappingNP6;
        Map <String,FieldsWrap> mapIdField = new Map <String,FieldsWrap>();
        List<FieldsWrap> FieldsWrapToReturn = new List<FieldsWrap>();
        String getAllFieldsBodyResponse='';
        HttpResponse allFieldsResponse = calloutResponseJSON(Label.NP6_EndPoint +'fields','GET', null, null, null);
        system.debug('allFieldsResponse.getStatusCode()###'+allFieldsResponse.getStatusCode());
         system.debug('allFieldsResponse###'+allFieldsResponse.getbody());
        IF(allFieldsResponse.getStatusCode()==200 ) 
        {
            getAllFieldsBodyResponse = allFieldsResponse.getbody();
        }
        System.debug('getAllFieldsBodyResponse###'+getAllFieldsBodyResponse); 
        if(getAllFieldsBodyResponse!=null)
        {
            FieldsWrapToReturn = (List<FieldsWrap>) System.JSON.deserialize(getAllFieldsBodyResponse, List<FieldsWrap>.class);
        }
        System.debug('FieldsWrapToReturn###'+FieldsWrapToReturn);
        for(FieldsWrap fieldWrap : FieldsWrapToReturn)
        { 
            System.debug('fieldWrap###'+fieldWrap);
            if(fieldMapping.contains(fieldWrap.name))
            {
                system.debug('mapIdField###'+mapIdField);
                If(!mapIdField.containskey(fieldWrap.Id)){
                    mapIdField.put(fieldWrap.Id, fieldWrap) ;
                } 
            }
        } 
         System.debug('mapIdFieldSize###'+mapIdField.size());
         System.debug('mapIdField###'+mapIdField);
        if(!mapIdField.isEmpty())
        {
            return mapIdField;
        }
        else   {   return null;
        }
    }
    
    //Method to get targetId in NP6
    public static map<string, object> GetTargetId(Map<String,FieldsWrap> mapIdField,String Email,String Phone, date dateRendezVous, string heureRendezVous)
    {
        String targetId='';
        String JsonBodyReq='';
        map<string, object> mapKeyToValue = new map<string, object>();
        map<string, object> mapFieldValue = new map<string, object>(); 
        System.debug('mapIdField.values()###'+mapIdField.values());
        for(FieldsWrap mapfield : mapIdField.values())
        {
            System.debug('mapfield##'+mapfield);
            if(!mapFieldValue.containskey(mapfield.id))
            {
                System.debug('mapfieldName##'+mapfield.name);
                if(mapfield.name=='email')
                {
                      System.debug('mapfieldEmail##' );
                    mapFieldValue.put(mapfield.id, Email);
                }
                else if(mapfield.name=='portable')
                {
                    System.debug('mapfieldportable##');
                    mapFieldValue.put(mapfield.id ,Phone); 
                }
                else if(mapfield.name == 'date')
                {
                    System.debug('mapfieldDate##');
                    mapFieldValue.put(mapfield.id, dateRendezVous);
                }
                else if(mapfield.name == 'heure')
                {
                    System.debug('mapfieldHeure##');
                    mapFieldValue.put(mapfield.id, heureRendezVous);
                }
                
            }
        }
         System.debug('mapFieldValue##'+mapFieldValue);
        if(!mapFieldValue.isEmpty())
        {
            JsonBodyReq = JSON.serialize(mapFieldValue); 
        }
         System.debug('JsonBodyReq##'+JsonBodyReq);
        if(JsonBodyReq!=null)
        {
            httpResponse targetsResponse = calloutResponseJSON(Label.NP6_EndPoint +'targets','PUT','application/json', null, JsonBodyReq);
             System.debug('targetsResponse##'+targetsResponse);
            if( targetsResponse.getStatusCode()==200 )
            {
                mapKeyToValue = (map<string, object>)JSON.deserializeUntyped(targetsResponse.getBody());
            } 
             System.debug('mapKeyToValue##'+mapKeyToValue);
        }
        if(mapKeyToValue!=null)
        {
            return mapKeyToValue;
        }
        else {
            return null;
        }
        
    }
    
    //Method to get all actions in order to get the id of the SMS to send
   /* public static list<object> getActionsInfo()
    {
        list<object> listActionsInfo = new list<object>();
        HttpResponse allActionsResponse = calloutResponseJSON(Label.NP6_EndPoint +'actions','GET', null, null, null);
         system.debug('allActionsResponse###'+allActionsResponse.getBody());
        if(allActionsResponse.getStatusCode() == 200)
        {
            listActionsInfo = (list<object>)JSON.deserializeUntyped(allActionsResponse.getBody());
        }
        system.debug('listActionsInfo###'+listActionsInfo);
        system.debug('listActionsInfoSize###'+listActionsInfo.size());
        if(!listActionsInfo.isEmpty())
        {
            return listActionsInfo;
        }
        else
        {
            return null;
        }
    }*/
    
    //Method to send message 
    public static HttpResponse SendMessage(String actionId,String targetId,String httpMethod)
    {
        system.debug('SendMsg###'+actionId);
        system.debug('targetId###'+targetId);
        system.debug('httpMethod###'+httpMethod);
        httpResponse SMShHttpResponse = new httpResponse();
        if(actionId!=null && targetId!=null & httpMethod != null)
        {
            SMShHttpResponse = calloutResponseJSON(Label.NP6_EndPoint+'actions/'+ actionId +'/targets/'+targetId,httpMethod, null, '0', '');
            
        }
        system.debug('SMShHttpResponse###'+SMShHttpResponse.getBody());
        system.debug('SMShHttpResponse1###'+SMShHttpResponse);
        return SMShHttpResponse;
    }
    
    //wrapper Class for fields
    public class FieldsWrap { 
        public String type {get; set;}
        public String Id {get; set;}
        public String Name {get; set;} 
    }  
    
    //wrapper class to send SMS (to be used in buld SMS later)
    public class SMSInfo {
        public SMSInfoPart1 SMSInforPart1Param {get;set;}
        public SMSInfoPart2 SMSInfoPart2Param {get;set;}
    }
    
    public class SMSInfoPart1 {
        public recipient recipientParam {get;set;}
        public list<copies> listCopiesParam {get;set;}
        public headers headersParam {get;set;}
        public string subjectParam {get;set;}
        public list<attachments> attachmentsParam {get;set;}
        public content contentParam {get;set;}
    }
    
    public class SMSInfoPart2 {
        public recipientStr recipientStrParam {get;set;}
        public dataStr dataStrParam {get;set;}
    }
    
    //wrapper classes for each element of the SMSInfo
    public class recipient {
        public string id {get;set;}
        public string value {get;set;}
    }
    
    public class copies {
        public string id {get;set;}
        public string value {get;set;}
        public boolean blind {get;set;}
    }
    
    public class headers {
        public fromStr fromStr {get; set;}
        public string reply {get;set;}
    }
    
    public class fromStr {
        public string label {get;set;}public string prefix {get;set;}
    }
    
    public class attachments {
        public string name {get;set;}
        public string mime {get;set;}
        public data data {get;set;}
    }
    
    public class data {
        public string type {get;set;}  public string value {get;set;}
    }
    
    public class content {
        public string type {get;set;}
        public string html {get;set;}
        public string text {get;set;}
        public string amp {get;set;}
        public dataStr dataStrParam {get;set;}
    }
    
    public class dataStr {
        public string myvar {get;set;}  public string myproduct {get;set;}
    }
    
    public class recipientStr {
        public string type {get;set;} public list<string> value {get;set;}
    }
    
}