({
    
    getTableData: function(component, event, helper) {
        var action = component.get("c.getEquipementsduFoyer");
        action.setParams({ 
            pageNumber : component.get('v.pageNumber'), 
            recordsPerPage:200
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                let reponse = response.getReturnValue();
                component.set('v.data', reponse.equipements);
                component.set('v.isAIP', reponse.userRecordTypeName==='AIP');
            }else{
                var errorMessage = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    }
})