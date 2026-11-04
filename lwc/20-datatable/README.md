# 20 · Tables: `lightning-datatable`, Inline Edit and `refreshApex`

The code for **LWC from Zero #20** (completing Part 3: Calling Apex). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerDeals`** upgraded to a 4-column `<lightning-datatable>` (`Deal`, `Stage`, editable `Amount` in `INR`, and editable `Close date`):
- Loads the Account's opportunities with `@wire(getDeals, { accountId: '$recordId' })`.
- Lets staff inline-edit one or more cells (`editable: true`), collecting changes in `event.detail.draftValues`.
- Saves all edited rows in parallel with `Promise.all(records.map((record) => updateRecord(record)))`, fires a `ShowToastEvent`, clears `this.draftValues = []`, and calls `await refreshApex(this.deals)` so the wired table shows the fresh database values immediately.

*(Note on toasts: the LWC developer guide now recommends `lightning/toast` (`Toast.show`) for new components; we show `ShowToastEvent` here because you will see it across existing codebases and Salesforce's own recipe repos.)*

**`force-app/main/default/lwc/customerDeals/customerDeals.html`**:

```html
<template>
    <lightning-card title="Deals" icon-name="standard:opportunity">
        <div class="slds-p-horizontal_small">
            <template lwc:if={deals.data}>
                <lightning-datatable
                    key-field="Id"
                    data={deals.data}
                    columns={columns}
                    draft-values={draftValues}
                    onsave={handleSave}
                    hide-checkbox-column
                ></lightning-datatable>
            </template>
            <c-error-panel errors={errors}></c-error-panel>
        </div>
    </lightning-card>
</template>
```

**`customerDeals.js`**:

```js
import { LightningElement, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDeals from '@salesforce/apex/DealController.getDeals';

const COLUMNS = [
    { label: 'Deal', fieldName: 'Name' },
    { label: 'Stage', fieldName: 'StageName' },
    {
        label: 'Amount',
        fieldName: 'Amount',
        type: 'currency',
        typeAttributes: { currencyCode: 'INR' },
        editable: true
    },
    { label: 'Close date', fieldName: 'CloseDate', type: 'date-local', editable: true }
];

export default class CustomerDeals extends LightningElement {
    @api recordId;
    columns = COLUMNS;
    draftValues = [];
    error;

    @wire(getDeals, { accountId: '$recordId' })
    deals;

    get errors() {
        return this.error || this.deals.error;
    }

    async handleSave(event) {
        const records = event.detail.draftValues.map((draft) => ({ fields: { ...draft } }));
        try {
            await Promise.all(records.map((record) => updateRecord(record)));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Deals saved',
                    message: `${records.length} deal(s) updated.`,
                    variant: 'success'
                })
            );
            this.draftValues = [];
            this.error = undefined;
            await refreshApex(this.deals);
        } catch (error) {
            this.error = error;
        }
    }
}
```

## Deploy and open it

1. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. Open **Verma Electricals** (or any Account with deals) in your org and look at the **Deals** card.

## What you should see

- A 4-column table (`Deal`, `Stage`, `Amount`, `Close date`) with pencil icons on the `Amount` and `Close date` cells.
- Click the pencil on an `Amount` cell, change `95000` to `105000`, and click **Save**: a green toast says `Deals saved — 1 deal(s) updated.`, the yellow cell highlight disappears, and the table displays `₹1,05,000.00`.

**Your small task:** add `editable: true` to the `Deal` column (`{ label: 'Deal', fieldName: 'Name', editable: true }`), deploy, and try renaming a deal inline.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
