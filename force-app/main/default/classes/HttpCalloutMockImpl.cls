public class HttpCalloutMockImpl implements HttpCalloutMock {
        Integer statusCode;
        String status;
        String responseBody;

        public HttpCalloutMockImpl(Integer statusCode, String status, String responseBody) {
            this.statusCode = statusCode;
            this.status = status;
            this.responseBody = responseBody;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setStatus(status);
            res.setBody(responseBody);
            return res;
        }
    }