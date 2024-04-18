({
    doInitHelper : function(component, event, helper) {
        const urlParams = window.location.href;
        let splittedURL = urlParams.split("/");
        let searchKey;
        if(splittedURL[splittedURL.length - 2] == "global-search"){
            searchKey = decodeURIComponent(splittedURL[splittedURL.length - 1]);
            component.set('v.displayDiv', true);
        }else{
            component.set('v.displayDiv', false);
        }
        
        var action = component.get("c.getInfo");
        action.setParams({
            searchKey: searchKey,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                let allData = [];
                for(var key in result){
                    allData.push({value: result[key], key: key})
                }
                component.set('v.data', allData);                
            }else{
                var error = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    },
})