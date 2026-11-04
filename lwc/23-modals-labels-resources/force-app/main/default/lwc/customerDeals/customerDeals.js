import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import CUSTOMER_SELECTED from '@salesforce/messageChannel/Customer_Selected__c';
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
    accountId;
    columns = COLUMNS;
    draftValues = [];
    error;
    subscription;

    @wire(MessageContext)
    messageContext;

    @wire(getDeals, { accountId: '$accountId' })
    deals;

    connectedCallback() {
        // On an account's page, show its deals; on the desk, wait for a customer to be picked.
        this.accountId = this.recordId;
        this.subscription = subscribe(this.messageContext, CUSTOMER_SELECTED, (message) => {
            this.accountId = message.accountId;
        });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

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
