({
    doInit : function(component, event, helper) {
        helper.getTableData(component, event, helper);
    },   
    
   /* handleNextPage: function(component, event, helper) { 
        if(component.get('v.pageNumber') < component.get('v.totalRecords') / component.get('v.recordsPerPage')){
            component.set('v.onLoad', true);
            component.set('v.pageNumber', component.get('v.pageNumber') + 1);
            helper.getTableData(component, event, helper);
        }
    },
    
    handlePrevPage: function(component, event, helper) { 
        if(component.get('v.pageNumber') > 1){
            component.set('v.onLoad', true);
            component.set('v.pageNumber', component.get('v.pageNumber') - 1);
            helper.getTableData(component, event, helper);
        }
    }*/
})