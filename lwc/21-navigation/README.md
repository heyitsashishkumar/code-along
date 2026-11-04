# 21 · Moving Around the App (`NavigationMixin`)

The code for **LWC from Zero #21** (opening Part 4: A real app). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerSummary`** upgraded with `NavigationMixin` from `'lightning/navigation'` (`export default class CustomerSummary extends NavigationMixin(LightningElement)`) and three navigation buttons on a Contact record page:
1. **Open company** (`type: 'standard__recordPage'`, `actionName: 'view'`): jumps straight to the Contact's parent Account page (`ACCOUNT_ID_FIELD`).
2. **New customer** (`type: 'standard__objectPage'`, `objectApiName: 'Contact'`, `actionName: 'new'`): opens Salesforce's standard New Contact modal.
3. **All customers** (`type: 'standard__objectPage'`, `objectApiName: 'Contact'`, `actionName: 'list'`, `state: { filterName: 'Recent' }`): navigates to the Contacts list view.

The key idea: **wrap `LightningElement` in `NavigationMixin(LightningElement)` and call `this[NavigationMixin.Navigate](pageReference)` — never hardcode `/lightning/r/...` URLs.**

**`force-app/main/default/lwc/customerSummary/customerSummary.js`**:

```js
import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
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
}
```

**`customerSummary.html`**:

```html
<template>
    <lightning-card title="Customer summary" icon-name="standard:contact">
        <div class="slds-p-horizontal_small">
            <template lwc:if={contact.data}>
                <p class="name slds-text-heading_small">{name}</p>
                <p>{title}, {company}</p>
                <p>{phone}</p>
                <p>{email}</p>
                <div class="slds-m-top_small">
                    <lightning-button label="Open company" onclick={handleOpenCompany} class="slds-m-right_x-small"></lightning-button>
                    <lightning-button label="New customer" onclick={handleNewCustomer} class="slds-m-right_x-small"></lightning-button>
                    <lightning-button label="All customers" onclick={handleAllCustomers}></lightning-button>
                </div>
            </template>
            <template lwc:elseif={contact.error}>
                <p class="error slds-text-color_error">Couldn't load this customer.</p>
            </template>
        </div>
    </lightning-card>
</template>
```

## Deploy and open it

1. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. Open **Ravi Verma**'s Contact record page in your org and look at the **Customer summary** card.

## What you should see

- Three buttons under Ravi Verma's details: **Open company**, **New customer**, and **All customers**.
- Click **Open company** to jump to **Verma Electricals**' Account page (where `customerDeals` from video 20 lives!).
- Click **New customer** to open the New Contact modal, or **All customers** to open the Recent Contacts list view.

**Your small task:** add a button that navigates to the current Contact's edit modal (`type: 'standard__recordPage'`, `attributes: { recordId: this.recordId, actionName: 'edit' }`).

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
