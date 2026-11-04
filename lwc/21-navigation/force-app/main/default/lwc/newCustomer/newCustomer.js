import { LightningElement } from 'lwc';
import { createRecord, updateRecord, deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import ID_FIELD from '@salesforce/schema/Contact.Id';
import FIRST_NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LAST_NAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';

export default class NewCustomer extends LightningElement {
    firstName = '';
    lastName = '';
    email = '';
    contactId;
    error;

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    async handleCreate() {
        const fields = {};
        fields[FIRST_NAME_FIELD.fieldApiName] = this.firstName;
        fields[LAST_NAME_FIELD.fieldApiName] = this.lastName;
        fields[EMAIL_FIELD.fieldApiName] = this.email;
        try {
            const contact = await createRecord({ apiName: CONTACT_OBJECT.objectApiName, fields });
            this.contactId = contact.id;
            this.error = undefined;
            this.showToast('Customer created', `${this.firstName} ${this.lastName} is saved.`, 'success');
        } catch (error) {
            this.error = error;
        }
    }

    async handleUpdate() {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.contactId;
        fields[TITLE_FIELD.fieldApiName] = 'Top customer';
        try {
            await updateRecord({ fields });
            this.error = undefined;
            this.showToast('Customer updated', 'Marked as a top customer.', 'success');
        } catch (error) {
            this.error = error;
        }
    }

    async handleDelete() {
        try {
            await deleteRecord(this.contactId);
            this.contactId = undefined;
            this.error = undefined;
            this.showToast('Customer deleted', 'The record is in the Recycle Bin.', 'success');
        } catch (error) {
            this.error = error;
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
