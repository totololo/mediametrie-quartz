({      
    doInit : function(component, event, helper) {
        const urlParams = new URLSearchParams(window.location.search);
        const page_type = urlParams.get('article');
        /*var myEvent = $A.get("e.c:InfoArticleEvent");
        myEvent.setParams({"data": "test2"});
        myEvent.fire();*/
        if(page_type){
            component.set("v.articleId", page_type);
        }
            
            var action = component.get("c.getInfoArticle");
            action.setParams({
                idArticle : page_type
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    var article = JSON.parse(result);
                    var maDate = new Date(article.date_article);
                    console.log('article.date_article '+article.date_article);
                    console.log('year '+maDate.getYear());
                    article.date_article = maDate.getDate()+'/'+parseInt(maDate.getMonth()+1)+'/'+maDate.getUTCFullYear()+' à '+maDate.getHours()+':'+maDate.getMinutes();
                    component.set('v.articleInfo', article);
                    document.getElementById("messageArticle").innerHTML =article.message;
                    /*if(article.message) {
                    let pattern = "<br>";
                    let replacement = "<br/>";
                    
                    let articleBody = article.message.replace(pattern, replacement);
                    
                    var myEvent = $A.get("e.c:InfoArticleEvent");
                    myEvent.setParams({
                       "messaggeBody": articleBody,
                        "wainting": false,
                        "articleId": page_type,
                    });
                    myEvent.fire();
                    component.set('v.wainting', false);
                }*/
                    let pattern = "<br>";
                    let replacement = "<br/>";
                    let articleBody = ' ';
                    if(article.message){
                        articleBody = article.message.replace(pattern, replacement);
                    }
                    component.set('v.articleBody', articleBody);
                    //helper.fireeventHelper(component, event, helper);
                }else{
                    var error = response.getError();
                }
                component.set("v.onLoad",false);            
            });
            $A.enqueueAction(action); 
    },
    
    fireevent: function(component, event, helper) {
        helper.fireeventHelper(component, event, helper);
    },
    handleToggle : function (component,event,helper) {
        var articleId = event.currentTarget.getAttribute("data-Id")
        var liked ; 
        console.log(articleId);
        var article = component.get('v.articleInfo');
        console.log('article.fl_like'+article.fl_like);
        var deleteValue ; 
        article.fl_like=!article.fl_like;
        if(article.fl_like ==true){
            deleteValue=1 ;
            article.nbLike=article.nbLike+1;
        }
        else{
            deleteValue=0;
            article.nbLike=article.nbLike-1;
        }
        
        
        component.set('v.articleInfo',article);
        
        var action = component.get("c.makeLike");
        action.setParams({ idArticle : event.currentTarget.getAttribute("data-Id"),value : deleteValue });
        
        action.setCallback(this, function(response){
            console.log(response)
        });
        $A.enqueueAction(action);       
    },
    afterScriptsLoaded : function (component,event,helper) {
        component.set("v.myBoolean",true);            
        
        
        
    }
    
    
    
    
    
})