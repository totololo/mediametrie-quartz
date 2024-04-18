({
    putdatatype : function(component, actionName, val) {
        var action = component.get(actionName);
        action.setParams({ v : val });
        action.setCallback(this, function(response) {
        console.log('actionname = ' + actionName )
           if(actionName == 'c.IncomingEventMethod'){
            const rsp = response.getReturnValue();   
            const obj = JSON.parse(rsp);
            console.log('Anes comments '+obj["comments"] );
            var helper = this;
            console.log('Anes comments '+obj["CaseID"] );
            helper.navigate(component,helper,event,obj["CaseID"]);
            helper.callAcceptTry(component,helper,event,obj["tryId"]);
        //    if(  obj["comments"]!= null && typeof num1 == 'number'  ) {
        //     setTimeout(() => {helper.callAcceptTry(component,obj["TryId"])}, 1000*obj["comments"]);
        //     }else{ 
           
            //}

            }
            // else{ // ReleasedEvent

            // const rsp = response.getReturnValue();   
            // console.log('Anes response of released event '+rsp );
            // var helper = this;
            // //helper.navigate(component,helper,event,rsp);
            // }

        });
        $A.enqueueAction(action);
      
    },

callAcceptTry : function(component,helper,event,tryId){
    console.log('Anes we are in the call acepptTry = ' +tryId);
    var actionAcceptTry = component.get("c.AcceptTry");
    actionAcceptTry.setParams({ tryId : tryId });
    actionAcceptTry.setCallback(this, function(response) {
        console.log('actionname = ' + actionName )
        const rsp = response.getReturnValue();   
        console.log('Anes the response in acceptTry  ');
    });
            $A.enqueueAction(actionAcceptTry);
},

navigate : function(component,helper,event,recId) {
    console.log('Anes record id in navigate =' + recId);
        // var editRecordEvent = $A.get("e.force:editRecord");
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
             "recordId": recId.replace(/\s/g, ''),
             "slideDevName": "related"

       });
        editRecordEvent.fire();
        }
})