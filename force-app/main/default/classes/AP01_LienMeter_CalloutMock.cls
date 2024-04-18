/*
* @Auteur : Ayoub Ghammaz EIT
* @date: 24/02/2022
* @Classe: AP01_LienMeter
* @Coverage: 100%
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
global class AP01_LienMeter_CalloutMock implements HttpCalloutMock {
    protected String indivId;
    
    public AP01_LienMeter_CalloutMock(String indivId) {
        this.indivId = indivId;
    }
     global HttpResponse respond(HttpRequest req) {
      httpResponse httpRes = new httpResponse();
        
        String extIdRegex = '^([a-zA-Z0-9]{8}-){1}([a-zA-Z0-9]{4}-){3}([a-zA-Z0-9]{12}){1}$';
        Pattern extIdPattern = Pattern.compile(extIdRegex);
        Matcher extIdMatcher = extIdPattern.matcher(this.indivId);
        
        String idRegex = '^[a-zA-Z0-9]{18}$';
        Pattern idPattern = Pattern.compile(idRegex);
        Matcher idMatcher = idPattern.matcher(this.indivId);
        
        if(extIdMatcher.matches() || idMatcher.matches()) {
            httpRes.setStatusCode(200);
            httpRes.setStatus('OK');
            httpRes.setBody('responseBody');
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

}