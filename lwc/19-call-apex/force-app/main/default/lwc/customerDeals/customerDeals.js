import { LightningElement, api } from 'lwc';
import getDeals from '@salesforce/apex/DealController.getDeals';

export default class CustomerDeals extends LightningElement {
    @api recordId;
    deals;
    error;
    isLoading = false;

    async handleLoad() {
        this.isLoading = true;
        try {
            this.deals = await getDeals({ accountId: this.recordId });
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.deals = undefined;
        } finally {
            this.isLoading = false;
        }
    }
}
