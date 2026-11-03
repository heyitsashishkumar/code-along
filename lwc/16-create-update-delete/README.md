# 16 · Create, Update and Delete a Record from Your Own Buttons

The code for **LWC from Zero #16**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Three pieces that work together on the **Customer Desk** page:
1. **`newCustomer`**: creates a real Contact with `createRecord`, updates its `Title` to `'Top customer'` with `updateRecord`, deletes it to the Recycle Bin with `deleteRecord`, and pops up a green banner with `ShowToastEvent`.
2. **`ldsUtils`**: a plain JavaScript module (`reduceErrors`) that unpacks Salesforce's nested error objects (`error.body.output.fieldErrors`, `error.body.output.errors`, `error.body.message`) into plain strings.
3. **`errorPanel`**: a reusable `<c-error-panel errors={error}></c-error-panel>` component that displays those messages in red whenever an operation fails.

The key idea: **`createRecord`, `updateRecord` and `deleteRecord` return Promises — call them with `async` / `await` inside `try` / `catch`, show success with `ShowToastEvent`, and pass `error` to `<c-error-panel>` so errors never fail silently.**

**`force-app/main/default/lwc/newCustomer/newCustomer.html`**:

```html
<template>
    <lightning-card title="New customer" icon-name="standard:contact">
        <div class="slds-p-horizontal_small">
            <lightning-input label="First name" onchange={handleFirstNameChange}></lightning-input>
            <lightning-input label="Last name" onchange={handleLastNameChange}></lightning-input>
            <lightning-input type="email" label="Email" onchange={handleEmailChange}></lightning-input>
            <lightning-button variant="brand" label="Create" onclick={handleCreate} class="slds-m-top_small"></lightning-button>
            <template lwc:if={contactId}>
                <p class="created slds-m-top_small">Created customer {contactId}</p>
                <lightning-button label="Mark as top customer" onclick={handleUpdate} class="slds-m-right_x-small"></lightning-button>
                <lightning-button variant="destructive" label="Delete" onclick={handleDelete}></lightning-button>
            </template>
            <c-error-panel errors={error}></c-error-panel>
        </div>
    </lightning-card>
</template>
```

**`newCustomer.js`**:

```js
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
```

## Deploy it and add it to the page

1. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab, click the gear in the top right, choose **Edit Page**, drag **`newCustomer`** into the right column, click **Save**, and go back.

## What you should see

- Leave **Last name** blank and click **Create**: `<c-error-panel>` shows `Required fields are missing: [LastName]` in red.
- Fill in `First name` (`Meera`), `Last name` (`Kapoor`), `Email` (`meera@example.com`) and click **Create**: a green toast says `Customer created — Meera Kapoor is saved.`, and `Created customer 003...` appears with **Mark as top customer** and **Delete** buttons.
- Click **Mark as top customer** to update her `Title`, or **Delete** to move the record to the Recycle Bin.

**Your small task:** add a `Phone` `lightning-input` (`PHONE_FIELD` from `@salesforce/schema/Contact.Phone`) and include it in `handleCreate`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
