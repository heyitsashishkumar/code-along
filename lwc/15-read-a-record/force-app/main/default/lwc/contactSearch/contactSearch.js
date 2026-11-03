import { LightningElement } from 'lwc';

const DELAY = 300;

export default class ContactSearch extends LightningElement {
    contacts = [
        { Id: '1', Name: 'Ravi Verma', Title: 'Owner', Phone: '+91 90000 00109' },
        { Id: '2', Name: 'Rakesh Gupta', Title: 'Owner', Phone: '+91 90000 00111' },
        { Id: '3', Name: 'Neha Gupta', Title: 'Purchase Manager', Phone: '+91 90000 00112' },
        { Id: '4', Name: 'Lakshmi Iyer', Title: 'Managing Director', Phone: '+91 90000 00113' },
        { Id: '5', Name: 'Zubair Khan', Title: 'Owner', Phone: '+91 90000 00115' },
        { Id: '6', Name: 'Rani Das', Title: 'Owner', Phone: '+91 90000 00117' }
    ];
    searchKey = '';
    selectedId;
    delayTimeout;

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    get matchingContacts() {
        const key = this.searchKey.toLowerCase();
        return this.contacts.filter((contact) => contact.Name.toLowerCase().includes(key));
    }

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        return this.contacts.find((contact) => contact.Id === this.selectedId);
    }
}
