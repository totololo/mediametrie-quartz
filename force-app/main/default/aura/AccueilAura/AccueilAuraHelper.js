({
    getArticles : function(component, offset) {
        console.log('getArticles');
        component.set('v.onLoad', true);
        var action = component.get("c.getAllArticles");
        action.setParams({ 
            offset : offset,
            onPageInit: component.get("v.onPageInit")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var currentDateTime = new Date();
                var result = response.getReturnValue();
                var articles = JSON.parse(result.articlesData);
                component.set("v.articles", articles );
                if(component.get("v.onPageInit")){
                    var pageNumber = JSON.parse(result.pageNumber);
                    var numberOfPages = Math.floor(pageNumber['nb']/10) +1;
                    component.set("v.numberOfPages", numberOfPages); 
                    var pageNumbers = this.paginate(numberOfPages, 1, 5);
                    component.set("v.pageNumbers", pageNumbers);
                    component.set("v.onPageInit",false);
                    component.set("v.showNextButton", true);
                }
                
                for (let i = 0; i < articles.length; i++) {
                    var maDate = new Date(articles[i].date_article);
                    articles[i].date_article = maDate.getDate()+'/'+parseInt(maDate.getMonth()+1)+'/'+maDate.getUTCFullYear()+' à '+maDate.getHours()+':'+maDate.getMinutes();
                }
                component.set("v.onLoad",false); 
            }else{
                var error = response.getError();
                component.set("v.onLoad",false); 
            }
        });
        $A.enqueueAction(action);
    },
    
    paginate : function(totalPages, currentPage, maxButtons) {
        // Calculate the starting and ending page numbers
        var start = Math.max(1, currentPage - Math.floor(maxButtons / 2));
        var end = Math.min(totalPages, start + maxButtons - 1);
        // Generate the page numbers array
        var pageNumbers = [];
        pageNumbers.push('Précédent');
        
        if(start>1){
            pageNumbers.push(1);
            if(start>2){
                pageNumbers.push('...');}
        }
        for (var i = start; i <= end; i++) {
            pageNumbers.push(i);
        }
        if(end<totalPages){
            if(end+1 < totalPages){
                pageNumbers.push('...');}
            pageNumbers.push(totalPages);
        }
        pageNumbers.push('Suivant');
        
        return pageNumbers;
    }
})