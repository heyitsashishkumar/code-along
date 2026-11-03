import { LightningElement } from 'lwc';

export default class ContactList extends LightningElement {
    contacts = [
        { Id: '1', Name: 'Ravi Verma', Title: 'Owner', Phone: '+91 90000 00109' },
        { Id: '2', Name: 'Neha Gupta', Title: 'Purchase Manager', Phone: '+91 90000 00112' },
        { Id: '3', Name: 'Lakshmi Iyer', Title: 'Managing Director', Phone: '+91 90000 00113' },
        { Id: '4', Name: 'Zubair Khan', Title: 'Owner', Phone: '+91 90000 00115' },
        { Id: '5', Name: 'Rani Das', Title: 'Owner', Phone: '+91 90000 00117' }
    ];
    selectedId;

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        return this.contacts.find((contact) => contact.Id === this.selectedId);
    }
}
