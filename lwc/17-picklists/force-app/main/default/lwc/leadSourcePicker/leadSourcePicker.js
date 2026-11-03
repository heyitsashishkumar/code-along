import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import LEAD_SOURCE_FIELD from '@salesforce/schema/Contact.LeadSource';

export default class LeadSourcePicker extends LightningElement {
    value;

    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, {
        recordTypeId: '$objectInfo.data.defaultRecordTypeId',
        fieldApiName: LEAD_SOURCE_FIELD
    })
    picklistValues;

    get label() {
        return this.objectInfo.data ? this.objectInfo.data.fields.LeadSource.label : '';
    }

    get options() {
        return this.picklistValues.data ? this.picklistValues.data.values : [];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
}
