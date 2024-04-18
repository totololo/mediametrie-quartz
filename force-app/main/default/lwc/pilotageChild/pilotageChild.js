import { LightningElement,wire,api,track } from 'lwc';
import getListview from '@salesforce/apex/PilotageController.getListview'
//import getRecordsFromListview from'@salesforce/apex/fillQueues.getRecordsFromListview';
import updateListView from'@salesforce/apex/AP10_updateCampaign.updateListView';
import CallBat22FromLwc from '@salesforce/apex/CallBat22FromLwc.CallBat22FromLwc';
import DeleteLVfromCampaign from '@salesforce/apex/DeleteLVfromCampaign.DeleteLVfromCampaign';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
import LightningConfirm from 'lightning/confirm';

import getCampaigns from '@salesforce/apex/getRecordCampaign.getCampaigns';

const COLS= [{label:'Name',fieldName:'Name', type:'text'}
]

export default class PilotageChild extends LightningElement {


    selectedRecords= []
cols=COLS;  
@api object;
@track cardeTitle ;
@track disableButton=true;
value='';
@track returnOptions = [];

// @wire(GetCampaignList)
// GetCampaignList({data,error}){
//         if (data) {
//         console.log("data "+data); 
//         } else if (error) {
//         console.log("error "+error);
//         }
// }

@wire (getCampaigns) wiredCampaigns({data,error}){
          if (data) {
          console.log("data+ "+data); 
                  for( var i = 0; i < data.length; i++){
                        this.returnOptions = [...this.returnOptions ,{value: data[i].CampagneID_Avaya__c , label: data[i].Name}];                                   
                console.log('returnOptions '+this.returnOptions[i].value)
        }

          } else if (error) {
         console.log("error "+error);
          }
     }

get options() {
    return this.returnOptions;
}

handleChange(event) {
    this.value = event.detail.value;
}

    @wire(getListview, {objectName:'$object'})
listview



DeleteListView(){
            //createAccountContact({wrapper:pass})/
            var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
            if(selectedRecords.length > 0 && this.value!=''){

                console.log('selectedRecords are ', selectedRecords);
                // console.log('test '+ this.value);
                DeleteLVfromCampaign({objectlst:selectedRecords,Queue:this.value})
                .then(result => {
                    getRecordNotifyChange([{ Queue: '$queue',Obj : '$obj' }]);
                    this.template.querySelector('c-pilotage-queues').refreshList();
                    this.disableButton = false;
                    const event = new ShowToastEvent({
                        variant:'Success',
                        message: "Vues de liste de liste supprimer de la file d'attente : " + this.value,
                    });
                    this.dispatchEvent(event);
                    }) .catch(error => {
                        const event = new ShowToastEvent({
                            variant:'Warning',
                            message: "Vues de liste n'est pas supprimer de la file d'attente : " + this.value,
                        });
                        this.dispatchEvent(event);
                    
                    this.error = error;
                    })
                    
                    }   
                    else{
                        const event = new ShowToastEvent({
                            variant:'warning',
                            message: "Merci de bien choisir des vues de liste et une file d'attente",
                        });
                        this.dispatchEvent(event);
                    }         
            }

        async  CreateAppels() {
    //createAccountContact({wrapper:pass})/
    var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
    if(selectedRecords.length > 0){

    console.log('selectedRecords are ', selectedRecords);
    // console.log('test '+ this.value);
    const result = await LightningConfirm.open({
        message: 'Voulez-vous mettre à jour les campagnes existantes dans le CCtelDialer ? ',
        variant: 'header',
        label: 'Merci de confirmer',
        theme: 'success',
    });
    if(result==true){     
    console.log('Anes after confirmation ');
    CallBat22FromLwc()
    .then(result => {
    console.log('Data Anes:'+ JSON.stringify(result));
    }) .catch(error => {
    console.log(error);
    this.error = error;
    })

    }   
}
    else{
    alert('Merci de choisir des vues de liste');
    }
    
    }


    AddListView() {
                //createAccountContact({wrapper:pass})/
        var selectedRecords =  this.template.querySelector("lightning-datatable").getSelectedRows();
        if(selectedRecords.length > 0 && this.value!=''){
            updateListView({objectlst:selectedRecords,Queue:this.value})
            getRecordNotifyChange([{ objectlst:selectedRecords,Queue:this.value }]);
            
            setTimeout(() => {
            this.template.querySelector('c-pilotage-queues').refreshList();
                setTimeout(() => {
                    const event = new ShowToastEvent({
                        variant:'Success',
                        message: "Vues de liste de liste ajouter a la file d'attente : " + this.value,
                    });
            
                        this.dispatchEvent(event);
                        this.disableButton = false;
                    }, 2000);  
                }, 1000);
        }        
        
        else{
            const event = new ShowToastEvent({
                variant:'warning',
                message: "Merci de bien choisir des vues de liste et une file d'attente",
            });
            this.dispatchEvent(event);
        }
}

}