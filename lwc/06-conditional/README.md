# 06 · Show or hide parts of the page

The code for **LWC from Zero #6**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerStatus`**, placed under `customerName` on the **Customer Desk** tab: a `lightning-input` number box ("Orders this year") and one message out of three, chosen with `lwc:if`, `lwc:elseif` and `lwc:else`.

The key idea: **`lwc:if` shows a part only when its property is true, and the first true one wins.**

**`force-app/main/default/lwc/customerStatus/customerStatus.html`**:

```html
<template>
    <lightning-input type="number" label="Orders this year" value={orderCount} onchange={handleOrderCountChange}></lightning-input>
    <template lwc:if={isNewCustomer}>
        <p>New customer: offer a welcome discount.</p>
    </template>
    <template lwc:elseif={isRegularCustomer}>
        <p>Regular customer: thank them for coming back.</p>
    </template>
    <template lwc:else>
        <p>Top customer: call them first when new stock arrives.</p>
    </template>
</template>
```

**`customerStatus.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerStatus extends LightningElement {
    orderCount = 0;

    handleOrderCountChange(event) {
        this.orderCount = Number(event.target.value);
    }

    get isNewCustomer() {
        return this.orderCount === 0;
    }

    get isRegularCustomer() {
        return this.orderCount < 10;
    }
}
```

**`customerStatus.js-meta.xml`**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>68.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
    </targets>
</LightningComponentBundle>
```

The project also includes `customerCard`, `customerGreeting` and `customerName` from videos 3, 4 and 5.

## Deploy it and add it to the page

1. Deploy `force-app` from VS Code (`SFDX: Deploy This Source to Org`) or the terminal:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab in your org, click the gear in the top right and choose **Edit Page**.
3. Under **Custom (4)** on the left, drag `customerStatus` below `customerName`.
4. Click **Save**, then click the back arrow in the top left.

## What you should see

- Before you type anything, **Orders this year** shows `0`, and the line under it reads:

  ```
  New customer: offer a welcome discount.
  ```

- Type `5`, and it changes to:

  ```
  Regular customer: thank them for coming back.
  ```

- Type `12`, and it changes to:

  ```
  Top customer: call them first when new stock arrives.
  ```

- Type `0` again, and it goes back to `New customer: offer a welcome discount.`.

**Your small task:** add a fourth note before the others — above 50 orders, show `VIP customer: a personal call from the owner.` Deploy it and try `60`. This folder doesn't include that fourth branch, so you can try it yourself.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
