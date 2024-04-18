import { LightningElement, api, wire, track} from 'lwc';
import getListsViews from '@salesforce/apex/GetListsViews.GetListsViews';

import { refreshApex } from '@salesforce/apex';


const COLS= [{label:'Name',fieldName:'Name', type:'text'}]
export default class BearList extends LightningElement {
	error;
    cols=COLS;  
    @api obj
    @api queue

    @wire(getListsViews , { Queue: '$queue',Obj : '$obj' })
        listview
        
        
    // @wire(getListsViews , { Queue: '$queue',Obj : '$obj' })
    // listview(result){
    //     listviewResult = result;
    //     const{DataTransfer, value}=result;
    // }
        @api refreshList(){
            console.log('we are in the refreshList method Anes ');
          
                 refreshApex(this.listview); 
              
          
    
            // getListsViews([{ Queue: '$queue',Obj : '$obj' }])
            // .then(result => {
            // console.log('Data Anes:'+ JSON.stringify(result));
            // }) .catch(error => {
            // console.log(error);
            // this.error = error;
            // })
            
        }
}