({
    doInit : function(component, event, helper) {
        var action = component.get("c.getInformations");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.data', result.utilisateur);
                component.set('v.channelPrivilegeList', result.ChannelPrivilegeList);
                component.set('v.personneDeReference', result.personneDeReference);

                let address = result.utilisateur.Contact.Account.ShippingAddress;
                                console.log('getInformationcs ');

                console.log('address ', address);
                if(address){
                   component.set('v.userAddress', address.street+ ', ' +  address.city
                             + ', ' +  address.country + ', ' +  address.postalCode );
                }
                            }else{
                var errorMessage = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    } , 
    
    checkEmailFormat:function(component, event, helper) {
        var validity = component.find("emailInput").get("v.validity");
        component.set('v.buttonDisabled', !validity.valid);
    },
    
    updateUser : function(component, event, helper) {
        var userData = component.get('v.data');
        //userData.Provisioning_IAM__c = document.getElementById("provisioning").value;  
        userData.Tech_CanalPrivilegie__c = document.getElementById("CanalPrivilegie").value; 
        userData.Email =component.find("emailInput").get("v.value"); 
        userData.MobilePhone = document.getElementById("mobile").value; 
        var validity = component.find("emailInput").get("v.validity");
        component.set('v.buttonDisabled', !validity.valid);
        if(validity.valid){
            component.set('v.onLoad', true);
            var action = component.get("c.updateUserInformations");
            action.setParams({
                userToUpdate   : userData
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    helper.showToastSuccess(component, event, helper);
                }else{
                    helper.showToastError(component, event, helper);
                    var errorMessage = response.getError();
                }
                component.set('v.onLoad', false);
            });
            $A.enqueueAction(action);
        }
    },
})