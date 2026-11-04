import { LightningElement } from 'lwc';

export default class CustomerStatus extends LightningElement {
    orderCount = 0;

    handleOrderCountChange(event) {
        this.orderCount = Number(event.target.value);
    }

    handleReset() {
        this.orderCount = 0;
    }

    get isNewCustomer() {
        return this.orderCount === 0;
    }

    get isRegularCustomer() {
        return this.orderCount < 10;
    }
}
