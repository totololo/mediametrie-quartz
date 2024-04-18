({
	doInit: function(component, event, helper) {
        var action = component.get("c.MentionsLegales");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.mentionslegalesText", result);
            } 
            else {
                var error = response.getError();
            }
        });
        $A.enqueueAction(action);
    }
})