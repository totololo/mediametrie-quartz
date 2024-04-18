({
	//check if Status field is empty
    checkStatusHelper:function(component, event, helper) {
        var statusValue = document.getElementById("statusValue").value;
        if(!statusValue || statusValue == '-Aucun-'){
            component.set('v.StatusEmpty', true);
            component.set('v.buttonDisabled', true);
        }else {
            component.set('v.StatusEmpty', false);
            if(!component.get('v.dateErrorMessage')){
                component.set('v.buttonDisabled', false);
            }
        }
    },
    
    showToastSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.EXP_SuccesTitle"),
            "message": $A.get("$Label.c.EXP_DemandeEnvoyee")
        });
        toastEvent.fire();
    },
    
    showToastError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": $A.get("$Label.c.EXP_ErrorTitle"),
            "message": $A.get("$Label.c.EXP_ErreurDemande")
        });
        toastEvent.fire();
    },
    
    changeDescriptionDisplay : function(component, event, helper, displayStyle) {
        var descRequiElement = document.getElementById("description-required");
        descRequiElement.style.display = displayStyle;
    },   
})