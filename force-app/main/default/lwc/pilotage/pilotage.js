import { LightningElement } from 'lwc';

export default class Pilotage extends LightningElement {
 value ='';
selectedRecords=''
    get options() {
        return [
            { label: 'Foyer', value: 'Account' },
            { label: 'Requête', value: 'Case' },
            { label: 'Tâche', value: 'Task' },
            { label: 'Étiquette', value: 'Etiquette__c' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
        console.log('selectedRecords')
    }
}