({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    
    displayAritcles : function(component, event, helper) {
        var articleTitle = document.getElementById(event.target.id);     
        var articleTitleId = articleTitle.id;
        var articleBodyId = document.getElementById(articleTitleId + "/body");
        articleBodyId.style.display = articleBodyId.style.display === "none" ? "block" : "none";
        if(articleBodyId.style.display != "none"){
            
            articleBodyId.classList.add("selected");
            articleBodyId.classList.remove("div-removed");
            
        }else{
            articleBodyId.classList.add("div-removed");
            articleBodyId.classList.remove("selected");
        }
    },
    
    showResponse : function(component, event, helper) {
        var articleTitleId = document.getElementById(event.target.id).id;            
        var articleBodyId = document.getElementById(articleTitleId + "/response");
        articleBodyId.style.display = articleBodyId.style.display === "none" ? "block" : "none";
        var openedDiv = component.get('v.openedDiv');
        if(articleBodyId.style.display != "none"){
            if(openedDiv && articleBodyId.id != openedDiv){
                var openedDivId = document.getElementById(openedDiv);
                openedDivId.style.display = "none";
            }
            component.set('v.openedDiv', articleBodyId.id);
        }
    },   
    
    openKnowledgeInfo : function(component, event, helper) {        
        var URL =  window.location.href+'/faqdetails?ques=' + event.currentTarget.getAttribute('data-Id');
        window.location.href=URL;
    },    
})