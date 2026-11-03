# 14 · Show and Edit Real Salesforce Records (`lightning-record-form`)

The code for **LWC from Zero #14** (the start of Part 2: real Salesforce records, no Apex yet). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerForm`**, placed on a real Salesforce **Contact** record page (`lightning__RecordPage`): it receives the Contact's ID automatically through `@api recordId` and uses `<lightning-record-form>` to view and edit six fields (`Name`, `Title`, `Phone`, `Email`, `LeadSource`, `MailingCity`) in two columns — without writing a single line of Apex.

The key idea: **on a record page, Salesforce automatically fills `@api recordId` with the current record's ID, and `lightning-record-form` loads, displays, validates and saves the record through Lightning Data Service.**

**`force-app/main/default/lwc/customerForm/customerForm.html`**:

```html
<template>
    <lightning-card title="Customer details" icon-name="standard:contact">
        <div class="slds-p-horizontal_small">
            <lightning-record-form
                record-id={recordId}
                object-api-name="Contact"
                fields={fields}
                columns="2"
                mode="view"
            ></lightning-record-form>
        </div>
    </lightning-card>
</template>
```

**`customerForm.js`**:

```js
import { LightningElement, api } from 'lwc';

export default class CustomerForm extends LightningElement {
    @api recordId;
    fields = ['Name', 'Title', 'Phone', 'Email', 'LeadSource', 'MailingCity'];
}
```

**`customerForm.js-meta.xml`**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>68.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__RecordPage</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__RecordPage">
            <objects>
                <object>Contact</object>
            </objects>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```

## Load the sample records and deploy

1. If you haven't loaded Sharma Traders' sample Accounts, Contacts and Opportunities into your org yet, run once from this folder:

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

3. Open **Contacts** in your org, click **Ravi Verma**, click the gear in the top right, choose **Edit Page**, drag **`customerForm`** into the right column, click **Save** (and **Activate** if prompted), and click the back arrow.

## What you should see

On **Ravi Verma**'s Contact page, the **Customer details** card displays `Name`, `Title`, `Phone`, `Email`, `Lead Source` and `Mailing City` in two columns with inline pencil icons. Clicking a pencil edits the field and saves it straight to Salesforce.

**Your small task:** also try `lightning-record-view-form` with `lightning-output-field` (when you only want read-only fields) or change `mode="view"` to `mode="readonly"` to see the difference.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
