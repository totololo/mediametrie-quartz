({
    showToastSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Succès!",
            "message": "L'enregistrement a été mis à jour avec succès"
        });
        toastEvent.fire();
    },
    
    showToastError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "erreur!",
            "message": "Une erreur s'est produite"
        });
        toastEvent.fire();
    },
})