({
    doInit: function(component, event, helper) {
        var action = component.get("c.ContactCguPopUp");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.isModalOpen", result.result);
                //console.log('bastien result.cgu: ',result.cgu );
                component.set("v.cguText", result.cgu);
            } 
            else {
                var error = response.getError();
            }
        });
        $A.enqueueAction(action);
    }, 
    updateCgu: function(component, event, helper){
        var action = component.get("c.updateContactCgu");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set("v.isModalOpen", true);
            } 
            else {
                var error = response.getError();
                component.set("v.isModalOpen", false);
            }
        });
        $A.enqueueAction(action);
    }, 
    loginOut: function(component, event, helper){
    window.location.replace(window.location.origin+"/login");
},
    gotoURL : function (component, event, helper) {
     var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": + "/login"
    });
    urlEvent.fire();
    }
    
})