import { LightningElement, api } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';

export default class ErrorPanel extends LightningElement {
    @api errors;

    get messages() {
        return reduceErrors(this.errors);
    }
}
