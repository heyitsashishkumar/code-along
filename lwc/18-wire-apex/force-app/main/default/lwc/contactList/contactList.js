import { LightningElement, api, wire } from 'lwc';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactList extends LightningElement {
    contacts = [];
    error;
    selectedId;

    @wire(getContacts)
    wiredContacts({ error, data }) {
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = [];
        }
    }

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    @api
    clearSelection() {
        this.selectedId = undefined;
    }

    get selectedContact() {
        return this.contacts.find((contact) => contact.Id === this.selectedId);
    }
}
