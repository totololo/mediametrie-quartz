({
    doInit : function(component, event, helper) {
        var action = component.get("c.onPageInit");
        action.setParams({
                currentPage: 'Planifier un RDV',
            });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var typesList = result.typeList;
    			typesList.splice(result.typeList.length,0,typesList.splice(result.typeList.indexOf($A.get("$Label.c.EXP_Autre")),1)[0]);
                component.set('v.type', typesList);
                component.set('v.sousType', result.sousTypeList);
                component.set('v.fieldDependenciesMap', result.fieldDependenciesMap);
                component.set('v.contactType', result.contactType);
                component.set('v.appointmentStartTime', result.appointmentStartTime);
                component.set('v.appointmentEndTime', result.appointmentEndTime);     
                component.set('v.isAIP', result.contactType == 'AIP');   
                component.set('v.horraireList', result.contactType == 'AIP' ? $A.get("$Label.c.EXP_HorraireAIP") : $A.get("$Label.c.EXP_HorraireNotAIP"));
                var getSousTypeFunction = component.get('c.getSousType');
        		$A.enqueueAction(getSousTypeFunction)
            }else{
                var error = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    },
    
    /*getSousType :function(component, event, helper) {
        var typeVal = document.getElementById("typeValue").value;
        if(!typeVal){
            typeVal = $A.get("$Label.c.EXP_Autre");
        }
        component.set('v.typeValue', typeVal);
                        console.log('v.typeValue', typeVal);
        var fieldDependenciesMap = component.get('v.fieldDependenciesMap');        
        //component.set('v.sousType', fieldDependenciesMap[typeVal]);
        var sousTypeFilteredList = fieldDependenciesMap[typeVal];
        
        if(typeVal == $A.get("$Label.c.EXP_Autre")){
            helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
        }else{
            helper.changeDescriptionDisplay(component, event, helper, "none");
        }
                        console.log('result sousTypeFilteredList '+sousTypeFilteredList);

        //if(sousTypeFilteredList.length < 1){
          //  helper.changeDescriptionDisplay(component, event, helper, "none");
        //}
           if(typeVal == $A.get("$Label.c.EXP_Autre")){
            helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
        }else{
            helper.changeDescriptionDisplay(component, event, helper, "none");
        }
       // component.set('v.sousTypeEmpty', sousTypeFilteredList.length < 1);
        
        if(typeVal != $A.get("$Label.c.EXP_Autre")){
            var descriptionElement = document.getElementById("description");
            descriptionElement.classList.remove("required-input");
        }else{
           // component.set('v.sousTypeInitial', sousTypeFilteredList);
        }
                        console.log('typeVal '+typeVal);

                var action = component.get("c.getsousType");
        action.setParams({
            motif: typeVal,
            Formulaire: 'Planifier un RDV',
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.sousType', response.getReturnValue());
            }else{
                var error = response.getError();
                console.log('result Anes '+error);
            }
        });
        $A.enqueueAction(action);
        
   
    
    },*/
        getSousType :function(component, event, helper) {
                var fieldDependenciesMap = component.get('v.fieldDependenciesMap');
            var typeVal = document.getElementById("typeValue").value;

        
        let sousTypeListCommander = component.get('v.contactType') == 'AIP' 
                                    ?  $A.get("$Label.c.EXP_SL_AIP_SousTypeListCommander").split(';')  
                                    : $A.get("$Label.c.EXP_SL_SousTypeListCommander").split(';');

        let sousTypeFilteredList = [];
        let fieldDependenciesMapVal = fieldDependenciesMap[typeVal]
        for(var key in fieldDependenciesMapVal){
            if(sousTypeListCommander.includes(fieldDependenciesMapVal[key])){
                sousTypeFilteredList.push(fieldDependenciesMapVal[key])
            }
        }

        console.log('typeVal', typeVal);

         if(!typeVal){
                                            typeVal = component.get('v.type')[1];
            component.get('v.type').forEach((element) => {

                if(element == $A.get("$Label.c.FOR_Type_RDV")){
                console.log('element true : ', element);
                typeVal = element;
            }
    }
    );
}
        component.set('v.typeValue', typeVal);
                console.log('typeVal after set', typeVal);

       
        if(typeVal == $A.get("$Label.c.EXP_Autre")){
            helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
        }else{
            helper.changeDescriptionDisplay(component, event, helper, "none");
        }
        
        
        component.set('v.sousTypeEmpty', sousTypeFilteredList.length < 1);
        
        if(typeVal != $A.get("$Label.c.EXP_Autre")){
            var descriptionElement = document.getElementById("description");
            descriptionElement.classList.remove("required-input");
        }else{
            component.set('v.sousTypeInitial', sousTypeFilteredList);
        }
        // new code 
        console.log('typeVal '+typeVal);
        var action = component.get("c.getsousType");
        action.setParams({
            motif: typeVal,
            Formulaire: 'Planifier un RDV',
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('result Anes '+JSON.stringify(result));
                component.set('v.sousType', response.getReturnValue());
                if(sousTypeFilteredList.length < 1){
                helper.changeDescriptionDisplay(component, event, helper, "none");
        }
            }else{
                var error = response.getError();
                console.log('result Anes '+error);
            }
        });
        $A.enqueueAction(action); 
    }, 
    checkSousType: function (component, event, helper) {
        var sousTypeValue = document.getElementById("sousTypeValue").value;
        var descRequiElement = document.getElementById("description-required");
        descRequiElement.style.display = sousTypeValue == $A.get("$Label.c.EXP_Autre") ? "inline-flex" : "none";
        if(sousTypeValue != $A.get("$Label.c.EXP_Autre")){
            var descriptionElement = document.getElementById("description");
            descriptionElement.classList.remove("required-input");
        }
    },

    getDateDebut:function(component, event, helper) {
        helper.checkDates(component, event, helper);
        const timeDropDown = document.getElementById('timeDiv');
        if(!component.get('v.dateErrorMessage')){
            component.set('v.timeDisabled', true);
            component.set('v.timeList', []);
            timeDropDown.removeAttribute('disabled');
        	helper.getTimeList(component, event, helper, component.get('v.appointmentStartTime'), component.get('v.appointmentEndTime'));
        }else{
            component.set('v.timeList', []);
            timeDropDown.setAttribute('disabled', '');
        }
    },
    
    getDateFin:function(component, event, helper) {
        helper.checkDates(component, event, helper);
    },
    
    checkStatus:function(component, event, helper) {
        helper.checkStatusHelper(component);
    },
    
    createRDV:function(component, event, helper) {
        helper.checkDates(component);
        if(!component.get('v.dateErrorMessage')){
            component.set('v.onLoad', true);
            var typeElement 	  	= document.getElementById("typeValue");
            var sousTypeElement  	= document.getElementById("sousTypeValue");
            var description   		= document.getElementById("description").value;
            var startDateElement 	= document.getElementById("date_debut");
            var selectedTimeElement = document.getElementById("timeDiv");
            var aucun 		  		= $A.get("$Label.c.EXP_AucunDropDown");
            const autreVal	    	= $A.get("$Label.c.EXP_Autre");
        	var descriptionElement  = document.getElementById("description");
            if(((sousTypeElement.value && sousTypeElement.value != autreVal) || description || component.get('v.sousTypeEmpty')) && startDateElement.value ){
                descriptionElement.classList.remove("required-input");
                startDateElement.classList.remove("required-input");
                var action = component.get("c.createRendezVousCase");
                action.setParams({
                    type: typeElement.value,
                    sousType: sousTypeElement.value,
                    description: description,
                    startDate : startDateElement.value,
                    appointmentTime: selectedTimeElement.value,
                });
                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state == 'SUCCESS') {
                        var result = response.getReturnValue();
                        if(result){
                            descriptionElement.value = '';
                            typeElement.value = autreVal;
                            component.set('v.sousType', component.get('v.sousTypeInitial'));
                            sousTypeElement.value = autreVal;
                            startDateElement.value = '';
                            helper.getTimeList(component, event, helper, 0, 0);
                            helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
                            helper.showToastSuccess(component, event, helper);
                        }else{
                            helper.showToastError(component, event, helper);
                        }
                    }else{
                        helper.showToastError(component, event, helper);
                        var errorMessage = response.getError();
                    }
                    component.set('v.onLoad', false);
                });
                $A.enqueueAction(action);
            }else{
                if(!description){
                    descriptionElement.classList.add("required-input");
                }
                
                if(!startDateElement.value){
                    startDateElement.classList.add("required-input");
                }
                component.set('v.onLoad', false);
            }
        }
    }
})