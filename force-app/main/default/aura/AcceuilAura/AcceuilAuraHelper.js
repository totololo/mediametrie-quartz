({
    getArticles : function(component, offset) {
        var action = component.get("c.getAllArticles");
        action.setParams({ 
            offset : offset,
            onPageInit: component.get("v.onPageInit")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var articles = JSON.parse(result.articlesData);
                component.set("v.articles", articles );
                
                if(component.get("v.onPageInit")){
                    var pageNumber = JSON.parse(result.pageNumber);
                    component.set("v.numberOfPages", Math.floor(pageNumber['nb']/10) +1); 
                    component.set("v.onPageInit",false);
                }
                
                component.set("v.now", Date.now());
                for (let i = 0; i < articles.length; i++) {
                    var moisNow = (new Date()).getUTCMonth();
                    var moisArticle = (new Date(articles[i]["date_article"])).getUTCMonth()
                    const yearNow = (new Date()).getUTCFullYear();
                    const yearArticle = (new Date(articles[i]["date_article"])).getUTCFullYear()
                    if(yearNow-yearArticle > 0){
                        const yearNow = (new Date()).getUTCFullYear();
                        const yearArticle = (new Date(articles[i]["date_article"])).getUTCFullYear()
                        articles[i]["date_article"]='Il y a '+(yearNow-yearArticle).toString() +' an(s)';
                    }
                    else if(moisNow-moisArticle > 0){
                        articles[i]["date_article"]='Il y a '+(moisNow-moisArticle).toString()+' mois';
                    }
                        else{
                            var jourNow = (new Date()).getDate();
                            var jourArticle = (new Date(articles[i]["date_article"])).getDate()
                            if(jourNow-jourArticle > 0){
                                articles[i]["date_article"]= 'Il y a ' + (jourNow-jourArticle).toString() +' jour(s)';
                            }else{
                                var hourNow = (new Date()).getHours();
                                var hourNow = (new Date(articles[i]["date_article"])).getHours()
                                if(hourNow-hourNow > 0){
                                    articles[i]["date_article"]='Il y a '+(hourNow-hourNow).toString() +' heure(s)';
                                }
                                else{
                                    var minuteNow = (new Date()).getMinutes();
                                    var minuteArticle = (new Date(articles[i]["date_article"])).getMinutes()
                                    articles[i]["date_article"]='Il y a '+(minuteNow-minuteArticle).toString() +' minutes(s)';
                                }
                            }
                        }
                    // articles[i]["date_article"]='its a test';
                }
            }else{
                var error = response.getError();
            }
            component.set("v.onLoad",false);            
        });
        $A.enqueueAction(action);
    },
    
    GetCountAllarticles : function(component) {
        // console.log('we are in the GetCountAllarticle') 
        var action = component.get("c.GetCountAllarticles");
        action.setCallback(this, function(response){
            // console.log('Anes response '+ response.getReturnValue());
            var articles = JSON.parse(response.getReturnValue());
            console.log('Anes response articlescount '+ articles['nb']);
            component.set("v.numberOfPages", Math.floor(articles['nb']/10) +1);
        });
        $A.enqueueAction(action);
    }
})