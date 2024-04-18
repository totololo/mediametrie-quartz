@isTest
global class GetArticlesWrapperMock implements HttpCalloutMock {
    protected List<getArticlesWrapper.GetArticlesWrappers> articles;
    
    public GetArticlesWrapperMock(List<getArticlesWrapper.GetArticlesWrappers> articles) {
        this.articles = articles;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(this.articles));
        res.setStatusCode(200);
        return res;
    }
}