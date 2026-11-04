# 25 · Put It Together: Sharma Traders' Customer Desk

The code for **LWC from Zero #25** (the playlist finale!). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

The finished **`customerDesk`** application component that brings our pieces together into a single responsive two-column workspace using `<lightning-layout multiple-rows>` and `<lightning-layout-item>`:
- Top banner: **`<c-desk-header>`** (SVG logo from a Static Resource + Custom Labels).
- Left column (`medium-device-size="4"`): **`<c-contact-search>`** (debounced `@wire` search against `ContactController.findContacts`, `<c-contact-tile>` list, and Lightning Message Service publisher).
- Right column (`medium-device-size="8"`): **`<c-customer-form>`** (inline view/edit `lightning-record-form` for the selected Contact) stacked above **`<c-customer-deals>`** (inline-editable `lightning-datatable` wired to `DealController.getDeals`, with `updateRecord`, `ShowToastEvent`, and `refreshApex`).

**`force-app/main/default/lwc/customerDesk/customerDesk.html`**:

```html
<template>
    <c-desk-header></c-desk-header>
    <lightning-layout multiple-rows>
        <lightning-layout-item size="12" medium-device-size="4" padding="around-small">
            <c-contact-search></c-contact-search>
        </lightning-layout-item>
        <lightning-layout-item size="12" medium-device-size="8" padding="around-small">
            <c-customer-form></c-customer-form>
            <div class="slds-m-top_small">
                <c-customer-deals></c-customer-deals>
            </div>
        </lightning-layout-item>
    </lightning-layout>
</template>
```

**`customerDesk.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerDesk extends LightningElement {}
```

## Load sample data, deploy, and use the finished desk

1. If you haven't loaded Sharma Traders' sample Accounts, Contacts and Opportunities yet, run once:

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. Deploy the entire project (`force-app`):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

3. On the **Customer Desk** tab in your org, click the gear in the top right, choose **Edit Page**, place **`customerDesk`** in the main region (and **`newCustomer`** / **`leadSourcePicker`** in the sidebar if you like), click **Save**, and go back.

## What you should see

- The **Sharma Traders · Customer desk** header banner at the top.
- Type `Verma` in **Find a customer** on the left and click **Ravi Verma**:
  - On the top right, **Customer details** (`<c-customer-form>`) loads Ravi Verma's Contact fields ready for inline editing.
  - On the bottom right, **Deals** (`<c-customer-deals>`) loads Verma Electricals' Opportunities in an inline-editable `<lightning-datatable>`.

**Your small task:** write a real Jest test in `customerDesk/__tests__/customerDesk.test.js` that asserts `c-desk-header`, `c-contact-search`, `c-customer-form`, and `c-customer-deals` are all rendered inside `customerDesk` (and see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) `B07` for why the children's Apex wires need test adapters!).

## Where to go next

- **Apex from Zero: Code Along** ([`../../apex/`](../../apex/)) — build and test every Apex class, SOQL query, controller, and trigger behind Sharma Traders' customer desk.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
