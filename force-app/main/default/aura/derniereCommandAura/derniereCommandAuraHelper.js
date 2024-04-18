({
    getInformationsPanel: function(component, event, helper) {
        var action = component.get("c.getInformations");
        action.setParams({ 
            pageNumber : component.get('v.pageNumber'),
            fromSolde: false,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                let reponse = response.getReturnValue();                
                component.set('v.dernierCommandeData', reponse.listCommande);
                component.set('v.totalRecords', reponse.tableRows);
                component.set('v.recordsPerPage', reponse.recordsPerPage);
                var totalPages = Math.ceil(reponse.tableRows / reponse.recordsPerPage);
                component.set('v.totalPages', totalPages == 0 ? 1 : totalPages);
            }else{
                var errorMessage = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    }
})