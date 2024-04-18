/*
* @author: Maribelle Zarazir
* @date: 
* @ Description :   
* History
* <Date of modification>   <Author>    <Description of modification>
*/

@isTest
public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;
 
    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
        this.requests = requests;
    }
 
    public HTTPResponse respond(HTTPRequest req) {
        HttpCalloutMock mock = requests.get(req.getEndpoint());
        if (mock != null) {
            return mock.respond(req);
        } else {
            //throw new MyCustomException('HTTP callout not supported for test methods');
            return mock.respond(req);
        }
    }
 
    public void addRequestMock(String url, HttpCalloutMock mock) {
        requests.put(url, mock);
    }
}