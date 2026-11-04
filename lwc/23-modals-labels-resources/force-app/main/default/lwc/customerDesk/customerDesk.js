import { LightningElement } from 'lwc';

export default class CustomerDesk extends LightningElement {
    handleClear() {
        this.refs.contactList.clearSelection();
    }
}
