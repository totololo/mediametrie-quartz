({
    doInit : function(component, event, helper) {
        var action = component.get("c.onPageInit");
        action.setParams({
            currentPage: 'NousContacter',
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
                console.log('erreur Mr');
                var error = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    },
    
    getSousType :function(component, event, helper) {
        var fieldDependenciesMap = component.get('v.fieldDependenciesMap');
        var typeVal = document.getElementById("typeValue").value;
        
        if(!typeVal){
            typeVal = component.get('v.type')[1];
            
            component.get('v.type').forEach((element) => {
                if(element == $A.get("$Label.c.FOR_Type_problemeMM")){
                typeVal = element;
            } 
                                            }
                                           );
        }
        
        component.set('v.typeValue', typeVal);   
        
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
        
        if(!typeVal){
            //typeVal = component.get('v.type')[0].value;
            typeVal = component.get('v.type')[0];
        }

        component.set('v.typeValue', typeVal);
        
        
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

        var action = component.get("c.getsousType");
        action.setParams({
            motif: typeVal,
            Formulaire: 'Nous contacter',
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var sousTypesList = result;
                console.log('result sousTypesList sousTypesList '+ sousTypesList);
                var indexOfAutre = result.indexOf($A.get("$Label.c.EXP_Autre"));
                if(result.indexOf($A.get("$Label.c.EXP_Autre")) != -1){
                    var autreString = result.splice(result.indexOf($A.get("$Label.c.EXP_Autre")),1);
                    sousTypesList.push('Autre');
                    //var listUpdate = sousTypesList.splice(sousTypesList.length,0,autreString);
                }
                
                console.log('result sousTypesList '+sousTypesList);
                console.log('result sousTypesList '+sousTypesList[0]);
                component.set('v.firstValue', sousTypesList[0]);
                component.set('v.sousType', sousTypesList);
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
    
    handleUploadFinished: function (component, event, helper) {
        
        component.set('v.documentId', event.getParam("files")[0].contentVersionId);
    },
    
    createCase:function(component, event, helper) {
        component.set('v.onLoad', true);
        var typeElement	    = document.getElementById("typeValue");
        var sousTypeElement = document.getElementById("sousTypeValue");
        var description     = document.getElementById("description").value;
        var documentId 	    = component.get('v.documentId');
        const autreVal	    = $A.get("$Label.c.EXP_Autre");
        var descriptionElement = document.getElementById("description");
        if((sousTypeElement.value && sousTypeElement.value != autreVal) || description){
            descriptionElement.classList.remove("required-input");
            var action = component.get("c.createNousContactezCase");
            action.setParams({
                type: typeElement.value,
                sousType: sousTypeElement.value,
                description: description,
                documentId: documentId,
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if(result){
                        component.set('v.sousType', component.get('v.sousTypeInitial'));
                        descriptionElement.value = '';
                        typeElement.value = autreVal;
                        sousTypeElement.value = autreVal;
                        component.set('v.documentId', '');
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
            descriptionElement.classList.add("required-input");
            component.set('v.onLoad', false);
        }
    }
})