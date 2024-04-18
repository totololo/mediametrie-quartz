({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Composition du Foyer', fieldName: 'Nom_Composition_Foyer__c', type: 'text'},
            {label: 'Utilisation de l\'équipement', fieldName: 'Utilisation_de_l_equipement__c', type: 'text', editable: true }
        ]);
        var recordId = cmp.get("v.recordId");
        helper.initEqtFoyerInd(cmp, recordId);

    },
    handleSaveEdition: function (cmp, event, helper) {
        //var draftValues = cmp.set('v.draftValues', event.getParam("draftValues"));
        var valuesToUpdate = event.getParam("draftValues");
        var recordId =cmp.get("v.recordId");
        console.log("valuesToUpdate: " + valuesToUpdate);
        
        helper.sendDataToUpdate(cmp, valuesToUpdate, recordId);
    }
            
});