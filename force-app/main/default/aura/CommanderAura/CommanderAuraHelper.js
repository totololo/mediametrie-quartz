({   
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