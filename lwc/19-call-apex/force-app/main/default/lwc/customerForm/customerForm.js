import { LightningElement, api } from 'lwc';

export default class CustomerForm extends LightningElement {
    @api recordId;
    fields = ['Name', 'Title', 'Phone', 'Email', 'LeadSource', 'MailingCity'];
}
