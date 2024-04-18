/*
* @author: Khaled Hammoudeh
* @date: 30/10/2020
* @ Description Class sends a mock response for the send SI Panel  
* History
* <Date of modification>   <Author>    <Description of modification>
* 12/03/2021 				 MZ			Add response
*/

@isTest
public class MembreFoyerCallout_Mock implements HttpCalloutMock{
    
    protected String foyerId;
    
    public MembreFoyerCallout_Mock(String foyerId) {
        this.foyerId = foyerId;
    }
    
    public HttpResponse respond(httpRequest req) {
        httpResponse httpRes = new httpResponse();
        
        String extIdRegex = '^([a-zA-Z0-9]{8}-){1}([a-zA-Z0-9]{4}-){3}([a-zA-Z0-9]{12}){1}$';
        Pattern extIdPattern = Pattern.compile(extIdRegex);
        Matcher extIdMatcher = extIdPattern.matcher(this.foyerId);
        
        String idRegex = '^[a-zA-Z0-9]{18}$';
        Pattern idPattern = Pattern.compile(idRegex);
        Matcher idMatcher = idPattern.matcher(this.foyerId);
        
        if(extIdMatcher.matches() || idMatcher.matches()) {
            httpRes.setStatusCode(200);
            httpRes.setStatus('OK');
            httpRes.setBody(createJSON());
        } else {
            httpRes.setStatusCode(400);
            httpRes.setStatus('Request malformed');
            Map<String,String> errorMap = new Map<String,String>();
            errorMap.put('errorCode', 'HTTP-400');
            errorMap.put('errorReference', 'E8');
            errorMap.put('errorDescription', 'Error - UUID mal formated.');
            Map<String,Object> errorMapReturn = new Map<String,Object>();
            errorMapReturn.put('error', errorMap);
            httpRes.setBody(JSON.serialize(errorMapReturn));
        }
        
        return httpRes;     
    }
    
    public String createJSON() {
        
        String status;
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeStringField('result', 'success');
        gen.writeEndObject();
        
        status = gen.getAsString();
        return status;
    }
}