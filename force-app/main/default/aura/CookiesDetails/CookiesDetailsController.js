({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCookiesDetails");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.data', result);
                console.log('result : ', result);
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    } , 
})