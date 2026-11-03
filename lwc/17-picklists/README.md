# 17 · Picklists and Object Info Without Hardcoding (`getObjectInfo` and `getPicklistValues`)

The code for **LWC from Zero #17** (completing Part 2). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`leadSourcePicker`**, a dropdown (`lightning-combobox`) on the **Customer Desk** page whose label (`Lead Source`) and options (`Web`, `Phone Inquiry`, `Partner Referral`, `Purchased List`, `Other`, plus any values an admin adds in Setup) come live from Salesforce metadata using two chained `@wire` calls:
1. `@wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })` loads `Contact`'s metadata, including `defaultRecordTypeId` and field labels.
2. `@wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: LEAD_SOURCE_FIELD })` waits for `objectInfo.data.defaultRecordTypeId` and then fetches the active picklist options for `Contact.LeadSource`.

The key idea: **never hardcode picklist options or labels in JavaScript — chain `getObjectInfo` into `getPicklistValues` with `'$objectInfo.data.defaultRecordTypeId'` so your dropdown always matches Setup.**

**`force-app/main/default/lwc/leadSourcePicker/leadSourcePicker.html`**:

```html
<template>
    <lightning-card title="How did they find us?" icon-name="standard:picklist_type">
        <div class="slds-p-horizontal_small">
            <lightning-combobox
                label={label}
                options={options}
                value={value}
                placeholder="Pick one"
                onchange={handleChange}
            ></lightning-combobox>
            <template lwc:if={value}>
                <p class="picked slds-m-top_small">You picked: {value}</p>
            </template>
        </div>
    </lightning-card>
</template>
```

**`leadSourcePicker.js`**:

```js
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
```

## Deploy it and add it to the page

1. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab, click the gear in the top right, choose **Edit Page**, drag **`leadSourcePicker`** into the right column below `newCustomer`, click **Save**, and go back.

## What you should see

- Inside **How did they find us?**, a `Lead Source` combobox appears with placeholder `Pick one`.
- Open the dropdown and choose **Partner Referral**: `You picked: Partner Referral` appears below the combobox.

**Your small task:** add this `Lead Source` combobox into `newCustomer` from video 16 so you can choose a new customer's `LeadSource` right when you create them.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
