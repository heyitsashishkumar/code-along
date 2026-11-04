import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getContacts from '@salesforce/apex/ContactController.getContacts';

export default class ContactList extends LightningElement {
    contacts = [];
    error;
    selectedId;
    wiredContactsResult;

    @wire(getContacts)
    wiredContacts(result) {
        this.wiredContactsResult = result;
        const { error, data } = result;
        if (data) {
            this.contacts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = [];
        }
    }

    handleRefresh() {
        return refreshApex(this.wiredContactsResult);
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
