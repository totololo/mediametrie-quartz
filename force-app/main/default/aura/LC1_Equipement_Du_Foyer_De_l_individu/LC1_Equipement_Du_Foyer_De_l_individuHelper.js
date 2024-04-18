({
    initEqtFoyerInd: function (component, recordId) {
        var eqtFoyerInd = component.get("c.getEquipementFoyerIndividu");
        eqtFoyerInd.setParams({
            recordId: recordId
        });
        eqtFoyerInd.setCallback(this, function(data) {
            component.set("v.data", data.getReturnValue());
        });
        $A.enqueueAction(eqtFoyerInd);
        console.log('init Function');
        
    },
    
    sendDataToUpdate: function (cmp, valuesToUpdate, recordId) {
        
        console.log('save');
        
        for (var i = 0; i < valuesToUpdate.length; i++){
            console.log("Value: " + valuesToUpdate[i].Id);
            console.log("Value: " + valuesToUpdate[i].Utilisation_de_l_equipement__c);
        }
       
        var eqtFoyerInd = cmp.get("c.updateEquipementFoyerIndividu");
        eqtFoyerInd.setParams({
            eqtFoyerIndividuList: valuesToUpdate
        });
        eqtFoyerInd.setCallback(this, function(data) {
            var result = data.getReturnValue();
            console.log('result: ' + result);
            if (result != 'OK') {
                console.log('Pas OK');
                alert(result);
                cmp.set("v.errors", result);
            }
            else {
            	cmp.set("v.errors", []);
                cmp.set("v.draftValues", []);
                console.log('OK');
                this.initEqtFoyerInd(cmp, recordId);
            }
        });
        $A.enqueueAction(eqtFoyerInd);
    }
});