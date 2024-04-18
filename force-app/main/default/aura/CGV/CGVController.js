({
	doInit: function(component, event, helper) {
        var action = component.get("c.ContactCgu");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.cguText", result.cgu);
                console.log('basiten result: ',result);
            } 
            else {
                var error = response.getError();
            }
        });
        $A.enqueueAction(action);
    }
})