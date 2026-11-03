# 15 · Read a Record into Your Own HTML (`@wire` and `getRecord`)

The code for **LWC from Zero #15**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerSummary`**, a custom Contact summary card that loads a Contact record (including its parent Account's name, `Contact.Account.Name`) using `@wire(getRecord, { recordId: '$recordId', fields: FIELDS })`, reads each field safely with `getFieldValue`, and renders your own HTML layout (`lwc:if={contact.data}` and `lwc:elseif={contact.error}`).

The key idea: **import field references from `@salesforce/schema/...` so Salesforce checks them when you deploy, prefix reactive wire parameters with `$` (`'$recordId'`), and always check `contact.data` before reading fields with `getFieldValue`.**

**`force-app/main/default/lwc/customerSummary/customerSummary.js`**:

```js
import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import TITLE_FIELD from '@salesforce/schema/Contact.Title';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Contact.Account.Name';

const FIELDS = [NAME_FIELD, TITLE_FIELD, PHONE_FIELD, EMAIL_FIELD, ACCOUNT_NAME_FIELD];

export default class CustomerSummary extends LightningElement {
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
            </template>
            <template lwc:elseif={contact.error}>
                <p class="error slds-text-color_error">Couldn't load this customer.</p>
            </template>
        </div>
    </lightning-card>
</template>
```

## Deploy it and add it to a Contact page

1. If you haven't imported the sample records yet, run once:

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

3. On **Ravi Verma**'s Contact page, click the gear in the top right, choose **Edit Page**, drag **`customerSummary`** above `customerForm` in the right column, click **Save**, and go back.

## What you should see

Inside the **Customer summary** card on **Ravi Verma**'s Contact page:

```
Ravi Verma
Owner, Verma Electricals
+91 90000 00109
ravi@vermaelectricals.example.com
```

And if you edit Ravi's `Title` in `customerForm` right below it and click **Save**, `customerSummary` updates immediately without refreshing the page, because both components share Lightning Data Service's cache.

**Your small task:** import `MAILING_CITY_FIELD` from `'@salesforce/schema/Contact.MailingCity'`, add it to `FIELDS`, add a `get city()` getter using `getFieldValue`, and show it in `customerSummary.html`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
