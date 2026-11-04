import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDeals from '@salesforce/apex/DealController.getDeals';

const COLUMNS = [
    { label: 'Deal', fieldName: 'Name' },
    { label: 'Stage', fieldName: 'StageName' },
    {
        label: 'Amount',
        fieldName: 'Amount',
        type: 'currency',
        typeAttributes: { currencyCode: 'INR' },
        editable: true
    },
    { label: 'Close date', fieldName: 'CloseDate', type: 'date-local', editable: true }
];

export default class CustomerDeals extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    draftValues = [];
    error;

    @wire(getDeals, { accountId: '$recordId' })
    deals;

    get errors() {
        return this.error || this.deals.error;
    }

    async handleSave(event) {
        const records = event.detail.draftValues.map((draft) => ({ fields: { ...draft } }));
        try {
            await Promise.all(records.map((record) => updateRecord(record)));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Deals saved',
                    message: `${records.length} deal(s) updated.`,
                    variant: 'success'
                })
            );
            this.draftValues = [];
            this.error = undefined;
            await refreshApex(this.deals);
        } catch (error) {
            this.error = error;
        }
    }
}
