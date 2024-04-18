({    
    doInit : function(component, event, helper) {
        var action = component.get("c.onPageInit");
        action.setParams({
                currentPage: 'Absence',
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
                var getSousTypeFunction = component.get('c.getSousType');
        		$A.enqueueAction(getSousTypeFunction)
            }else{
                var error = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    },
    
    getSousType :function(component, event, helper) {
        //Disable Sous Type dropdown as it is deppendent from type value
        component.set('v.onLoad', true);
        document.getElementById("sousTypeValue").setAttribute("disabled", "disabled");
        var typeVal = document.getElementById("typeValue").value;
              if(!typeVal){
                                                        typeVal = component.get('v.type')[1];

            component.get('v.type').forEach((element) => {
                if(element == $A.get("$Label.c.FOR_Type_absence")){
                typeVal = element;
            }
    }
    );
}
        if(typeVal){
            component.set('v.typeValue',typeVal);
            var fieldDependenciesMap = component.get('v.fieldDependenciesMap');
            
            let sousTypeAbsence = component.get('v.contactType') == 'AIP' 
            ?  $A.get("$Label.c.EXP_SL_AIP_SousTypeListAbsence").split(';')  
            : [];
            
            let sousTypeFilteredList = [];
            let fieldDependenciesMapVal = fieldDependenciesMap[typeVal]
            for(var key in fieldDependenciesMapVal){
                if(component.get('v.contactType') == 'AIP' && sousTypeAbsence.includes(fieldDependenciesMapVal[key])){
                    sousTypeFilteredList.push(fieldDependenciesMapVal[key])  
                }else if(component.get('v.contactType') != 'AIP'){
                    sousTypeFilteredList.push(fieldDependenciesMapVal[key])
                }
            }
            //component.set('v.sousType', sousTypeFilteredList);
            
            if(typeVal == $A.get("$Label.c.EXP_Autre")){
                helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
            }else{
                helper.changeDescriptionDisplay(component, event, helper, "none");
            }
            
            if(sousTypeFilteredList.length < 1){
                helper.changeDescriptionDisplay(component, event, helper, "none");
            }
            component.set('v.sousTypeEmpty', sousTypeFilteredList.length < 1);
            
            if(typeVal != $A.get("$Label.c.EXP_Autre")){
                var descriptionElement = document.getElementById("description");
                descriptionElement.classList.remove("required-input");
            }else{
                component.set('v.sousTypeInitial', sousTypeFilteredList);
            }
            
            document.getElementById("sousTypeValue").removeAttribute("disabled");
        }
        component.set('v.onLoad', false);
        
                var action = component.get("c.getsousType");
        action.setParams({
            motif: typeVal,
            Formulaire: 'Absence',
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
        
    },
    
    dateUpdated :function(component, event, helper) {
        helper.checkDates(component);
    },
    
    handleUploadFinished: function (component, event, helper) {
        component.set('v.documentId', event.getParam("files")[0].contentVersionId);
    },
    
    createNewCase : function(component, event, helper) {
        helper.checkDates(component);
        if(!component.get('v.dateErrorMessage')){
            component.set('v.onLoad', true);
            var typeElement 	  	= document.getElementById("typeValue");
            var sousTypeElement  	= document.getElementById("sousTypeValue");
            var description   		= document.getElementById("description").value;
            var startDateElement 	= document.getElementById("date_debut");
            var endDateElement 		= document.getElementById("date_fin");            
            var selectedTimeElement = document.getElementById("timeDiv");
			var descriptionElement  = document.getElementById("description");    
            var aucun 		  		= $A.get("$Label.c.EXP_AucunDropDown");
            const autreVal	    	= $A.get("$Label.c.EXP_Autre");
            var documentId 	  	    = component.get('v.documentId');
            if(((sousTypeElement.value && sousTypeElement.value != autreVal) || description || component.get('v.sousTypeEmpty'))
               && startDateElement.value && endDateElement.value){
                descriptionElement.classList.remove("required-input");
                startDateElement.classList.remove("required-input");
                endDateElement.classList.remove("required-input");
                var action = component.get("c.createAbsenceCase");
                action.setParams({
                    type: typeElement.value,
                    sousType: sousTypeElement.value,
                    description: descriptionElement.value,
                    startDate: startDateElement.value,
                    endDate: endDateElement.value,
                    documentId: documentId,
                });
                                                
                action.setCallback(this, function(response){
                    var state = response.getState();
                    if(state == 'SUCCESS') {
                        var result = response.getReturnValue();
                        component.set('v.documentId', '');
                        descriptionElement.value = '';
                        typeElement.value = autreVal;
                        component.set('v.sousType', component.get('v.sousTypeInitial'));
                        sousTypeElement.value = autreVal;
                        startDateElement.value = '';
                        endDateElement.value = '';
                        helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
                        helper.showToastSuccess(component, event, helper);
                    }else{
                        var error = response.getError();
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
                if(!endDateElement.value){
                    endDateElement.classList.add("required-input");
                }
                component.set('v.onLoad', false);
                
            }
        }
    },
})