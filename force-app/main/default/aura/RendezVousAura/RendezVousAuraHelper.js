({
    checkDates:function(component, event, helper) {
        var startDate = document.getElementById("date_debut").value;
        //var endDate = document.getElementById("date_fin").value;
        
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = yyyy + '-' + mm + '-' + dd;

        let message = '';
        
        let dateOfTheWeek = new Date(startDate).getDay();
        if(dateOfTheWeek === 0){
            message = $A.get("$Label.c.EXP_RDVDateErrorOnSunday");
;
        } 
        
        //check if start date is greater than end date
        /*if(endDate && startDate > endDate){
            message += message ? ', ' : '';
            message = 'La date de fin doit être supérieure à la date de début';
        }*/
        
        //check if today date is greater than start date
        if(startDate && startDate < today){
            message += message ? ', ' : '';
            message += $A.get("$Label.c.EXP_DateErrorSuperieure") + ' ' + dd + '/' + mm + '/' + yyyy
        }
        
        //check if start date is greater than end date
        /*if(endDate && endDate < today){
            message += message ? ', ' : '';
            message += 'La date de fin doit être supérieure à ' + mm + '/' + dd + '/' + yyyy;
        }*/
         
        component.set('v.dateErrorMessage', message);
        //Disable submit button
        if(message){
            component.set('v.buttonDisabled', true);
        }else if(!component.get('v.StatusEmpty')){
            component.set('v.buttonDisabled', false);
        }
    },
    
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
    
    changeDescriptionDisplay : function(component, event, helper, displayStyle) {
        var descRequiElement = document.getElementById("description-required");
        descRequiElement.style.display = displayStyle;
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
    
    /* 
        MMAT/PaME :  09h00 – 20h00   Samedi  : 10h00-20h00 
        AIP :  11h-21h Samedi : 11h-20h30
        //////////////////////////////////////////////////
        AIP					MMAT/PaME				AIP Samedi			MMAT/PaME Samedi
        11h-13h				09h00 – 11h00			11h - 13			10h00 – 12h00

        13h-15h				11h00 – 13h00			13h - 15h			12h00 – 14h00
        
        15h-18h				13h00 – 15h00			15h - 17h			14h00 – 16h00
        
        18h-21h				17h00 – 19h00			17h - 19h			16h00 – 18h00
        
        					19h00 - 20h00			19h - 20h30			18h00 – 20h00
    */
    
    getTimeList:function(component, event, helper, startHour, stopHour) {
        var startDate 	  = document.getElementById("date_debut").value;
        let dateOfTheWeek = new Date(startDate).getDay();
        let timesMap 	  = [];
        var timeRange;
        
        if(dateOfTheWeek == 6){
            if(!component.get('v.isAIP')){
                startHour += 1;
            }
        }
        var timeList = [];
        for (let h = startHour; h < stopHour; h += 2) {
            const hh = h.toString().padStart(2, '0');
            var endRDV = h + 2 <= stopHour ? h + 2 : stopHour;
            if(component.get('v.isAIP') && dateOfTheWeek == 6 && h == stopHour - 2){
                endRDV = h + 1 <= stopHour ? h + 1 : stopHour;
                timeRange = hh + ':00' + '-' + endRDV.toString().padStart(2, '0') + ':30';
                timesMap.push({
                    value: hh + ':00' + ' - ' + endRDV.toString().padStart(2, '0') + ':30', 
                    key: timeRange
                });
            }else{
                timeRange = hh + ':00' + '-' + endRDV.toString().padStart(2, '0') + ':00';
                timesMap.push({
                    value: hh + ':00' + ' - ' + endRDV.toString().padStart(2, '0') + ':00', 
                    key: timeRange
                });
            }
        }
        component.set('v.timesMap', timesMap);
    }
})