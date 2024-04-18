({
    doInit : function(component, event, helper) {
        // console.log('we are in the Accueil controler ✅');
        helper.getArticles(component,0); 
        //helper.GetCountAllarticles(component); 
    },
    
    onClick : function(component, event, helper) {
        alert('hello Anes :) ')
    },
    
    showArticle : function(component, event, helper) {
        // console.log('Hey Anes we are in the showTitle function')
        // console.log('Hey Anes we are in the showTitle function titre = '+event.currentTarget.getAttribute("data-Id"))
        var URL =  window.location.href+'detailArticle?article='+event.currentTarget.getAttribute('data-Id');
        
        window.location.href=URL;
        // console.log('Anes pageReference + URL '+ URL);
        
    },
    handleToggle : function (component,event,helper) {
        // var liked = cmp.get("v.liked");
        // cmp.set("v.liked", !liked);
        // console.log('Hello Anes ✅ ')
        //console.log("Check"+event.getSource().get("v.tabindex"));
        //var options = cmp.find("option");
        var articleId = event.currentTarget.getAttribute("data-Id")
      	var liked ; 
        console.log(articleId);
        var articles = component.get('v.articles');
           var deleteValue ; 
        for (let i = 0; i < articles.length; i++) {
            if(articles[i]["id_article"]==articleId){
                articles[i].fl_like=!articles[i].fl_like;
                if(articles[i].fl_like ==true){
                    deleteValue=1 ;
                    articles[i].nbLike=articles[i].nbLike+1;
                }
                else{
                    deleteValue=0;
                    articles[i].nbLike=articles[i].nbLike+-1;
                }
                //liked=articles[i].fl_like;
                break;
            }
        }
        component.set('v.articles',articles);
        
        var action = component.get("c.makeLike");
        action.setParams({ idArticle : event.currentTarget.getAttribute("data-Id"),value : deleteValue });
        
        action.setCallback(this, function(response){
            console.log(response)
        });
        $A.enqueueAction(action);       
    },
    handleNextPage: function(component, event, helper) { 
        if(component.get('v.pageNumber') < component.get('v.numberOfPages')){
        var pageNumber =  component.get('v.pageNumber');
        component.set('v.onLoad', true);
        component.set("v.pageNumber",pageNumber +1);
        helper.getArticles(component,pageNumber*10); 
        }
    },
    handlePrevPage: function(component, event, helper) { 
        if(component.get('v.pageNumber') > 1){
        var pageNumber =  component.get('v.pageNumber');
        component.set('v.onLoad', true);
        component.set("v.pageNumber",pageNumber -1);
        helper.getArticles(component,(pageNumber-2)*10); 
        }
    },
    search: function (component, event, helper) {
        var selectedLimit = component.find('searchField').get('v.value');
        
        
        component.set('v.searchKeyword', selectedLimit);
        helper.SearchHelper(component, event);
    }
})