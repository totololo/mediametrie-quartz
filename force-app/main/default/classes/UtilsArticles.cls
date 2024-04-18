/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 12-05-2022
* @last modified by  : Anes BOUZOUINA
**/
public without sharing class UtilsArticles {
    //public UtilsArticles() { }
    @AuraEnabled(cacheable=false)
    public static OnLoadWrapper getAllArticles(Integer offset, Boolean onPageInit){
        System.debug('getAllArticles ');
        Id contactId = [select id, Name,ContactId  from User where Id=:UserInfo.getUserId()].get(0).ContactId;
        System.debug('getAllArticles ' + contactId);
        System.debug('getAllArticles ' + UserInfo.getUserId());
        
        Individu_Paneliste__c uzfzfzid = [
            select id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
            from Individu_Paneliste__c 
            where Composition_du_foyer__c=:contactId];
        System.debug('getAllArticles uzfzfzid ' + uzfzfzid);
        
        String uid = [
            select id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
            from Individu_Paneliste__c 
            where Composition_du_foyer__c=:contactId].get(0).Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
        System.debug('getAllArticles uid ' + uid);
        
        List<getArticlesWrapper.GetArticlesWrappers> Articles = new List<getArticlesWrapper.GetArticlesWrappers> ();
        // DateTime myDateTime = DateTime.now();
        //system.debug(myDateTime.millisecond());
        OnLoadWrapper onLoadWrapper = new OnLoadWrapper();
        
        
        if(! Test.isRunningTest()){
            HttpResponse res = callRequest('articleAllSite?idMedia='+uid+'&idarticle=0&NB_ART=10&typeArt=4&limitDeb='+offset);
            Articles =  getArticlesWrapper.parse(res.getBody());
            // Log the XML content
            //System.debug(res.getBody());
            if(onPageInit){
                onLoadWrapper.pageNumber = GetCountAllarticles();
            }
        }
        
        onLoadWrapper.articlesData = JSON.serialize(Articles);
        return onLoadWrapper;
    }
    
    @AuraEnabled
    public static  string  getInfoArticle(String idArticle){
        String returnString = '';
        Id contactId = [select id, Name,ContactId  from User where Id=:UserInfo.getUserId()].get(0).ContactId;
        
        Individu_Paneliste__c uzfzfzid = [
            select id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
            from Individu_Paneliste__c 
            where Composition_du_foyer__c=:contactId];
        String uid = [
            select id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
            from Individu_Paneliste__c 
            where Composition_du_foyer__c=:contactId].get(0).Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;        
        if(! Test.isRunningTest()){
            HttpResponse res = callRequest('infoArticle?idArt='+idArticle+'&idMedia='+uid);
            string str= string.valueof(res.getBody());
            system.debug('str = '+str);
            String s2 = str.replace('\'', '');
            returnString = JSON.serialize((MyData) JSON.deserialize(s2,MyData.class));
            //returnString = JSON.serialize((MyData) JSON.deserialize(str,MyData.class));
        }        
        return returnString;
    }
    
    @AuraEnabled
    public static  void  makeLike(String idArticle,Integer value ){
        Id contactId = [select id, Name,ContactId  from User where Id=:UserInfo.getUserId()].get(0).ContactId;
        String uid = [
            select id, Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c 
            from Individu_Paneliste__c 
            where Composition_du_foyer__c=:contactId].get(0).Foyer_paneliste__r.Foyer_Paneliste_ExtId_SIPanel__c;
        HttpResponse res = callRequest('setEvent?idArticle='+idArticle+'&idMedia='+uid+'&type=3&value='+value);
        System.debug(res.getBody());
    }
    
    @AuraEnabled
    public static  string   GetCountAllarticles(){
        String returnString = '';
        if(! Test.isRunningTest()){
            HttpResponse res = callRequest('countArticleAllSite?typeArt=4');
            // Log the XML content
            System.debug(res.getBody());
            MyData MyData = (MyData) JSON.deserialize(res.getBody(),MyData.class);
            returnString = JSON.serialize(MyData);
        }
        return returnString;
    }
    
    
    public static HttpResponse callRequest(String endpoint){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.mediametrie.fr/mmoi/index.php/api/'+endpoint);
        req.setMethod('GET');
        //req.setHeader('Accept', 'application/xml');
        req.setHeader('Accept', 'application/json');
        HttpResponse res = http.send(req);
        return res;
    }
    
    
    /*WRAPPERS*/
    public class MyData {
        String id_article;
        String titre;
        String message;
        String date_article;
        String redacteur;
        String image;
        String video;
        String extrait;
        
        String sous_titre;
        String type_article;
        String etat_article;
        List<String> Commentaires;
        Integer NbComm;
        String Tags;
        List<String> Theme = new List<String>();
        List<String> LL_Theme = new List<String>();
        //Integer time;
        String dtDeb;
        String dtFin;
        String typeSplash;
        String libBtn;
        String dtMajArt;
        String accesPanelistes;
        Boolean fl_lu;
        Boolean fl_favoris;
        Boolean fl_like;
        Integer nbLike;
        integer nb; 
    }
    
    public class OnLoadWrapper {
        public OnLoadWrapper(){
            this.articlesData = '';
            this.pageNumber = '';
        }
        @AuraEnabled
        public String articlesData;
        @AuraEnabled
        public String pageNumber;
    }
}