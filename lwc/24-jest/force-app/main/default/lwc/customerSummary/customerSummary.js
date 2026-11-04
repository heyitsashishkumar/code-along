import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';
import NoteModal from 'c/noteModal';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ACCOUNT_ID_FIELD from '@salesforce/schema/Contact.AccountId';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Contact.Account.Name';

const FIELDS = [NAME_FIELD, TITLE_FIELD, PHONE_FIELD, EMAIL_FIELD, ACCOUNT_ID_FIELD, ACCOUNT_NAME_FIELD];

export default class CustomerSummary extends NavigationMixin(LightningElement) {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    contact;

    get name() {
        return getFieldValue(this.contact.data, NAME_FIELD);
    }

    get title() {
        return getFieldValue(this.contact.data, TITLE_FIELD);
    }

    get phone() {
        return getFieldValue(this.contact.data, PHONE_FIELD);
    }

    get email() {
        return getFieldValue(this.contact.data, EMAIL_FIELD);
    }

    get company() {
        return getFieldValue(this.contact.data, ACCOUNT_NAME_FIELD);
    }

    handleOpenCompany() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: getFieldValue(this.contact.data, ACCOUNT_ID_FIELD),
                actionName: 'view'
            }
        });
    }

    handleNewCustomer() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: { objectApiName: 'Contact', actionName: 'new' }
        });
    }

    handleAllCustomers() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: { objectApiName: 'Contact', actionName: 'list' },
            state: { filterName: 'Recent' }
        });
    }

    async handleAddNote() {
        const note = await NoteModal.open({ size: 'small', customerName: this.name });
        if (note === undefined) {
            return;
        }
        if (!note.trim()) {
            await LightningAlert.open({
                label: 'Nothing to save',
                message: 'Write the note first, then click Save.',
                theme: 'warning'
            });
            return;
        }
        await createRecord({
            apiName: 'Task',
            fields: {
                WhoId: this.recordId,
                Subject: 'Note from the customer desk',
                Description: note,
                Status: 'Completed'
            }
        });
        this.dispatchEvent(
            new ShowToastEvent({ title: 'Note saved', message: 'It is in the activity history.', variant: 'success' })
        );
    }
}
