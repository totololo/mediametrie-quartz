({
    doInit : function(component, event, helper) {
        var action = component.get("c.onPageInit");
        action.setParams({
            currentPage: 'Commander',
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                var typesList = result.typeList;
    			typesList.splice(result.typeList.length,0,typesList.splice(result.typeList.indexOf($A.get("$Label.c.EXP_Autre")),1)[0]);
                console.log('typesList : ', typesList);
                component.set('v.type', result.typeList);
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
        var typeVal = document.getElementById("typeValue").value;
        console.log('typeVal', typeVal);
        if(!typeVal){
                                                        typeVal = component.get('v.type')[1];

            component.get('v.type').forEach((element) => {
                if(element == $A.get("$Label.c.FOR_Type_fidelite")){
                typeVal = element;
            }
    }
    );
}
 
 component.set('v.typeValue', typeVal);        
var fieldDependenciesMap = component.get('v.fieldDependenciesMap');

let sousTypeListCommander = component.get('v.contactType') == 'AIP' 
?  $A.get("$Label.c.EXP_SL_AIP_SousTypeListCommander").split(';')  
: $A.get("$Label.c.EXP_SL_SousTypeListCommander").split(';');
console.log('sousTypeListCommander', sousTypeListCommander);
let sousTypeFilteredList = [];
let fieldDependenciesMapVal = fieldDependenciesMap[typeVal]
for(var key in fieldDependenciesMapVal){
    if(sousTypeListCommander.includes(fieldDependenciesMapVal[key])){
        sousTypeFilteredList.push(fieldDependenciesMapVal[key])
    }
}
// component.set('v.sousType', sousTypeFilteredList);

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
console.log('motif '+typeVal)
var action = component.get("c.getsousType");
action.setParams({
    motif: typeVal,
    Formulaire: 'Commander',
});
action.setCallback(this, function(response){
    var state = response.getState();
    if(state == 'SUCCESS') {
        var result = response.getReturnValue();
        component.set('v.sousType', response.getReturnValue());
        console.log('result Anes '+result);
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
                    var action = component.get("c.createCommandeCase");
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
                                helper.showToastSuccess(component, event, helper);
                                component.set('v.sousType', component.get('v.sousTypeInitial'));
                                descriptionElement.value = '';
                                typeElement.value = autreVal;
                                sousTypeElement.value = autreVal;
                                component.set('v.documentId', '');
                                helper.changeDescriptionDisplay(component, event, helper, "inline-flex");
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