import { LightningElement } from 'lwc';

export default class CustomerStatus extends LightningElement {
    orderCount = 0;

    handleOrderCountChange(event) {
        this.orderCount = Number(event.target.value);
    }

    get isNewCustomer() {
        return this.orderCount === 0;
    }

    get isRegularCustomer() {
        return this.orderCount < 10;
    }
}
