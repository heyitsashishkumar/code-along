import { LightningElement, api, wire } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import CUSTOMER_SELECTED from '@salesforce/messageChannel/Customer_Selected__c';

export default class CustomerForm extends LightningElement {
    @api recordId;
    selectedContactId;
    fields = ['Name', 'Title', 'Phone', 'Email', 'LeadSource', 'MailingCity'];
    subscription;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(this.messageContext, CUSTOMER_SELECTED, (message) => {
            this.selectedContactId = message.contactId;
        });
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    get contactId() {
        return this.selectedContactId || this.recordId;
    }
}
