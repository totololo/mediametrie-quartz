({
    doInitHelper : function(component, event, helper) {
        let knowId = component.get('v.knowId');
        if(knowId){
            var action = component.get("c.getInfo");
            action.setParams({
                knowId: knowId,
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    for(var key in result){
                        component.set('v.question', result[key][0].question);
                        component.set('v.response', result[key][0].reponse);
                        break;
                    }
                }else{
                    var error = response.getError();
                }
                component.set('v.onLoad', false);
            });
            $A.enqueueAction(action);
        }
        component.set('v.onLoad', false);
    },
})