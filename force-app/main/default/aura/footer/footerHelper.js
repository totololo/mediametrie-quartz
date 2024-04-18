({
    GetContactType : function(component) {
        // console.log('we are in the GetCountAllarticle') 
        var action = component.get("c.contactType");
        action.setCallback(this, function(response){
            console.log('Anes response '+ response.getReturnValue());
                component.set("v.ContactType",response.getReturnValue());
        });
        $A.enqueueAction(action);
        
    },
})