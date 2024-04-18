({
    checkDates:function(component, event, helper) {
        var startDate = document.getElementById("date_debut").value;
        var endDate = document.getElementById("date_fin").value;
        
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;
        
        let message = '';
        //check if start date is greater than end date
        if(endDate && startDate > endDate){
            message = $A.get("$Label.c.EXP_ErrorEndDateGreaterThanStartDate");
        }
        
        //check if today date is greater than start date
        if(startDate && startDate < today){
            message += message ? ', ' : '';
            message += $A.get("$Label.c.EXP_DateErrorSuperieure") + ' ' + dd + '/' + mm + '/' + yyyy
        }
        
        //check if start date is greater than end date
        if(endDate && endDate < today){
            message += message ? ', ' : '';
            message += $A.get("$Label.c.EXP_EndDateErrorSuperieure") + ' ' + dd + '/' + mm + '/' + yyyy;
        }
        
        component.set('v.dateErrorMessage', message);
        //Disable submit button
        if(message){
            component.set('v.buttonDisabled', true);
        }else if(!component.get('v.StatusEmpty')){
            component.set('v.buttonDisabled', false);
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