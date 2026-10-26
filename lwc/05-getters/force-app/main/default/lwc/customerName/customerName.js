import { LightningElement } from 'lwc';

export default class CustomerName extends LightningElement {
    firstName = '';
    lastName = '';

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
}
