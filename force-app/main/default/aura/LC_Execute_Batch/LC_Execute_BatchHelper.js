({
	lancerBatch1 : function(component) {
		var action = component.get('c.runBatchPrecodage'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
	lancerBatch2 : function(component) {
		var action = component.get('c.runBatchCreationRequete'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch3 : function(component) {
		var action = component.get('c.runBatchRecuperationRdv'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch4 : function(component) {
		var action = component.get('c.runBatchShareNote'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch5 : function(component) {
		var action = component.get('c.runBatchCtrAband'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch6 : function(component) {
		var action = component.get('c.runBatchRemiseSolde'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    
    lancerBatch8 : function(component) {
		var action = component.get('c.runBatchCreditExcep'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch9 : function(component) {
		var action = component.get('c.runBatchCreditNoel'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch10 : function(component) {
		var action = component.get('c.runBatchDelEven'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch12 : function(component) {
		var action = component.get('c.runBatch021'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch13 : function(component) {
		var action = component.get('c.runBatchCloseCase009'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch14 : function(component) {
		var action = component.get('c.runBatch017'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch15 : function(component) {
		var action = component.get('c.runBatch014'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch16 : function(component) {
		var action = component.get('c.runBatch022RM'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch17 : function(component) {
		var action = component.get('c.runBatch025inactif'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch18 : function(component) {
		var action = component.get('c.runBatch025majetiqu'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch19 : function(component) {
		var action = component.get('c.runBatch026'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
    lancerBatch20 : function(component) {
		var action = component.get('c.runBatch010'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	},
      lancerBatch21 : function(component) {
		var action = component.get('c.runBatch018'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	}
    
    /*
    lancerBatch11 : function(component) {
		var action = component.get('c.runBatchCreateAppel'); 
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success');
            }
            else{
                console.log('error', a.getError());
            }
        });
        $A.enqueueAction(action);
	}*/
    
    
})