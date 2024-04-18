({
    doInit : function(component, event, helper) {
        // console.log('we are in the Accueil controler ✅');
        component.set('v.onLoad', true);
        helper.getArticles(component, 0); 
    },
       
    showArticle : function(component, event, helper) {
         var URL =  window.location.href+'MetVOUS?article='+event.currentTarget.getAttribute('data-Id');
         window.location.href=URL;
        
    },
    
    handleToggle : function (component,event,helper) {
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
                    articles[i].nbLike=articles[i].nbLike-1;
                }
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
        var currentPage =  component.get('v.currentPage');
        helper.getArticles(component,currentPage*10); 
        component.set("v.currentPage",currentPage +1);
        var numberOfPages = component.get("v.numberOfPages")
        var pageNumbers = helper.paginate(numberOfPages, currentPage, 5);
        component.set("v.pageNumbers", pageNumbers);
    },
    
    handlePrevPage: function(component, event, helper) { 
        var currentPage =  component.get('v.currentPage');
        component.set("v.currentPage",currentPage -1);
        var numberOfPages = component.get("v.numberOfPages")
        var pageNumbers = helper.paginate(numberOfPages, currentPage, 5);
        component.set("v.pageNumbers", pageNumbers);
        helper.getArticles(component,(currentPage-2)*10); 
        },
    
    goToPage : function(component, event, helper) {
        // Get the page number from the button label
    
        component.set("v.pageNumbers", null);

        var currentPage =event.currentTarget.getAttribute('data-Id')
        component.set("v.currentPage",parseInt(currentPage));
        var numberOfPages = component.get("v.numberOfPages")
        var pageNumbers = helper.paginate(numberOfPages, currentPage, 5);
        component.set("v.pageNumbers", pageNumbers);
        helper.getArticles(component,(currentPage-1)*10);  
        console.log('pageNumbers'+pageNumbers);
        },
})