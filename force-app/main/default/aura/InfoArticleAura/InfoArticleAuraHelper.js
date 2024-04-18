({
    fireeventHelper: function(component, event, helper) {
        const articleId = component.get("v.articleId");
        if(articleId){
            var myEvent = $A.get("e.c:InfoArticleEvent");
            console.log('articleId ' + articleId);
            myEvent.setParams({"data": articleId});
            myEvent.fire(); 
        }
        
    },
})