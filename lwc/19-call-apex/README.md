# 19 · Call Apex on a Click (`async`/`await`, `lightning-spinner` and `try`/`catch`/`finally`)

The code for **LWC from Zero #19** (paired with **Apex from Zero #13**). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`DealController.cls`**, exposing `getDeals(Id accountId)` to query an Account's `Opportunity` records in user mode (`WITH USER_MODE`), ordered by `CloseDate`.
2. **`customerDeals`**, placed on the **Account** record page (`lightning__RecordPage`): when the user clicks **Show deals**, `async handleLoad()` calls `await getDeals({ accountId: this.recordId })` imperatively, shows `<lightning-spinner>` while waiting, formats each deal's rupee amount with `<lightning-formatted-number currency-code="INR">`, and stops the spinner inside `finally`.

The key idea: **call an imported Apex function with `await` inside an `async` method when you want to run it on a click, pass `this.recordId` directly (no `$`), and turn `this.isLoading = false` off inside `finally` so the spinner never gets stuck.**

**`force-app/main/default/classes/DealController.cls`**:

```apex
public with sharing class DealController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getDeals(Id accountId) {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE AccountId = :accountId
            WITH USER_MODE
            ORDER BY CloseDate
        ];
    }
}
```

**`force-app/main/default/lwc/customerDeals/customerDeals.html`**:

```html
<template>
    <lightning-card title="Deals" icon-name="standard:opportunity">
        <lightning-button slot="actions" label="Show deals" onclick={handleLoad}></lightning-button>
        <div class="deals slds-p-horizontal_small">
            <template lwc:if={isLoading}>
                <lightning-spinner alternative-text="Loading deals" size="small"></lightning-spinner>
            </template>
            <template lwc:if={deals}>
                <template for:each={deals} for:item="deal">
                    <p key={deal.Id} class="deal">
                        {deal.Name}, {deal.StageName}:
                        <lightning-formatted-number value={deal.Amount} format-style="currency" currency-code="INR" class="slds-m-left_xx-small"></lightning-formatted-number>
                    </p>
                </template>
            </template>
            <c-error-panel errors={error}></c-error-panel>
        </div>
    </lightning-card>
</template>
```

**`customerDeals.js`**:

```js
import { LightningElement, api } from 'lwc';
import getDeals from '@salesforce/apex/DealController.getDeals';

export default class CustomerDeals extends LightningElement {
    @api recordId;
    deals;
    error;
    isLoading = false;

    async handleLoad() {
        this.isLoading = true;
        try {
            this.deals = await getDeals({ accountId: this.recordId });
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.deals = undefined;
        } finally {
            this.isLoading = false;
        }
    }
}
```

**`customerDeals.css`**:

```css
.deals {
    position: relative;
    min-height: 2rem;
}
```

## Deploy and open it

1. If you haven't imported the sample records yet, run once:

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. Deploy `force-app`:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

3. In your org, open **Accounts**, click **Verma Electricals** (or any sample Account), click the gear in the top right, choose **Edit Page**, drag **`customerDeals`** onto the Account record page, click **Save** (and **Activate** if prompted), and go back.

## What you should see

On the Account page, the **Deals** card shows a **Show deals** button in its top-right actions slot. Click **Show deals**: a small spinner flashes inside the card, and the Account's opportunities appear with their stage and formatted Indian Rupee amount (`₹95,000.00`).

**Your small task:** add a getter `get buttonLabel() { return this.deals ? 'Refresh deals' : 'Show deals'; }` and bind `label={buttonLabel}` on `<lightning-button>` so the button text changes after the first load.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
