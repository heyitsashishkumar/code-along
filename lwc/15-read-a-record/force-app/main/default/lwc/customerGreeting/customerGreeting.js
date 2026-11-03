import { LightningElement } from 'lwc';

export default class CustomerGreeting extends LightningElement {
    customerName = 'friend';

    handleNameChange(event) {
        this.customerName = event.target.value;
    }
}
