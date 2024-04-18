({
   // Load controles from Salesforce
 myAction : function(component, event, helper) 
    {
         // Create the action
         var action = component.get("c.getRelatedList");
        var existingControleArray=[];
        var title=$A.get("$Label.c.Controle_du_jour");
         component.set("v.controleNumber", title);
       //  alert(component.get("v.controles"));
        action.setParams
        ({
            recordId: component.get("v.recordId")
            
        });
        // Add callback behavior for when data is received
        action.setCallback(this, function(data){ 
            var state =data.getState(); 
            
         //Get the length of data   
            var responseLength=data.getReturnValue().length;
        
        // Handle server response           
            if(state==="SUCCESS")
            {
                    component.set("v.controleNumber",title + ' ' + '(' + data.getReturnValue().length + ')');
                    component.set("v.controles",data.getReturnValue());
            }
       
            else if(state=="ERROR"){
           if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Message d'erreur: " + errors[0].message);
                    }
                }
                else{
                    console.log("Erreur Inconnu");
                }
            }
        });
       
       // Send action off to be executed
        $A.enqueueAction(action);
 },
    
   //do action Edit/Delete when is selecteted in the MenuItem 
   handleSelect: function (cmp, event) {           
        var selectedMenuItemValue2 = event.getParam("value");
        var res = selectedMenuItemValue2.split(";");
        var selectedMenuItemValue = res[1];
        var currentId = res[0];
       
        switch (selectedMenuItemValue) {
        //Action to edit a record in the related List
            case 'Edit':  
             var editRecordEvent = $A.get("e.force:editRecord");
                editRecordEvent.setParams({
                    "recordId": currentId
                });
               editRecordEvent.fire();
                break;
            
           //Delete Action to remove a record  
            case 'Delete':
                var action = cmp.get("c.deleteControle");
                action.setParams({
                    "controleId": currentId
                });
               action.setCallback(this, function(data) {
            var state = data.getState();
            if (state === "SUCCESS" ) {    
                 $A.get('e.force:refreshView').fire();
                var toastEvent = $A.get("e.force:showToast");
                if(data.getReturnValue()==='DONE'){ 
                    toastEvent.setParams({
                    "title": "Success!",
                    "message": "The record has been delete successfully.",
                    "type" : "success"                    
                }); 
                }else{
                  toastEvent.setParams({
                    "title": "Failed!",
                    "message": data.getReturnValue(),
                    "type" : "error"});   
                }                                       
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                 
            }
        });
        $A.enqueueAction(action);
        }
    },    

    //Action to Create a record
 	addControle: function(component, evt, helper) {
         var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Controle__c"
        });
     
        createRecordEvent.fire();
      
    }, 
    
    show : function( component, event, helper ) { 
    // to Show Popup if v.selectedControle value is different null
  	component.set("v.selectedControle", event.currentTarget.getAttribute("data-value") )
   
	}, 
    
    hide : function( component, event, helper ) {
     // to close Popup if v.selectedControle value is null
	 component.set( "v.selectedControle", null );
       
	},
    
    //redirect to lightning record detail
    handleClick: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
		var currentId =event.currentTarget.getAttribute("data-value");
        navEvt.setParams({
            "recordId":  currentId,
        });
        navEvt.fire();
         	 
    },
 
})