import { LightningElement, api } from 'lwc';

export default class ContactTile extends LightningElement {
    _contact;
    initials = '';

    @api
    get contact() {
        return this._contact;
    }

    set contact(value) {
        this._contact = value;
        this.initials = value
            ? value.Name.split(' ')
                  .map((part) => part[0])
                  .join('')
            : '';
    }

    handleClick() {
        const selectEvent = new CustomEvent('select', {
            detail: this.contact.Id,
            bubbles: true
        });
        this.dispatchEvent(selectEvent);
    }
}
