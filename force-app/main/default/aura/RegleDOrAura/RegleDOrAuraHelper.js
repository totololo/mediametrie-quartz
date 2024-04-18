({
	doInitHelper : function(component, event, helper) {
        var action = component.get("c.contactType");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                console.log('resultat',result)
                var pdfRessource = result == 'AIP' ? $A.get('$Resource.RegleDorAIP') + '#view=FitH&toolbar=0' : result == 'MMT' ? $A.get('$Resource.RegleDorMMAT') + '#view=FitH&toolbar=0' : $A.get('$Resource.RegleDorPaME') + '#view=FitH&toolbar=0';
                
                component.set('v.pdfRessource', pdfRessource);
          
            	/////////////////////////
            	var link = document.createElement('a');
                link.setAttribute('href', pdfRessource);
                link.setAttribute('target', '_blank');
                link.style.display = 'none';

            }else{
                var error = response.getError();
            }
            component.set('v.onLoad', false);
        });
        $A.enqueueAction(action);
    },
})