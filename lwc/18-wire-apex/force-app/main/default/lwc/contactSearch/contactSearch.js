import { LightningElement, wire } from 'lwc';
import findContacts from '@salesforce/apex/ContactController.findContacts';

const DELAY = 300;

export default class ContactSearch extends LightningElement {
    searchKey = '';
    selectedId;
    delayTimeout;

    @wire(findContacts, { searchKey: '$searchKey' })
    contacts;

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        const contacts = this.contacts.data || [];
        return contacts.find((contact) => contact.Id === this.selectedId);
    }
}
