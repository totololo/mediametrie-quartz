({
	doInit : function(component, event, helper) {
		const urlParams = new URLSearchParams(window.location.search);
        let knowId = urlParams.get('ques');
        component.set('v.knowId', knowId);
        helper.doInitHelper(component, event, helper);
	}
})