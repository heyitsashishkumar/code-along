# 09 · Put One Component Inside Another (Composition)

The code for **LWC from Zero #9**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerDesk`**, a parent component that holds `<c-customer-card>` and `<c-customer-greeting>` inside its own template, so Lightning App Builder only needs `customerDesk` in the left column instead of five separate components stacked by hand.

The key idea: **a camelCase component folder like `customerCard` becomes the kebab-case HTML tag `<c-customer-card></c-customer-card>` inside another component's template, and only the top-level component placed in App Builder needs `<isExposed>true</isExposed>`.**

**`force-app/main/default/lwc/customerDesk/customerDesk.html`**:

```html
<template>
    <c-customer-card></c-customer-card>
    <c-customer-greeting></c-customer-greeting>
</template>
```

**`force-app/main/default/lwc/customerDesk/customerDesk.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerDesk extends LightningElement {}
```

**`force-app/main/default/lwc/customerDesk/customerDesk.js-meta.xml`**:

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

And in `customerCard/customerCard.js-meta.xml` and `customerGreeting/customerGreeting.js-meta.xml`, `<isExposed>` is now `false` (with `<targets>` removed), because `customerDesk` puts them on the page rather than App Builder.

## Deploy it and update the page

1. Deploy the whole `force-app` folder so the parent and its child components go up together:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab, click the gear in the top right and choose **Edit Page**.
3. Remove the separate `customerCard` and `customerGreeting` from the left column, and drag **`customerDesk`** into the left column instead.
4. Click **Save**, then click the back arrow in the top left.

## What you should see

On the **Customer Desk** tab, `customerDesk` renders both the **Ravi Sharma** card and the **Greet a customer** card together as a single unit.

**Your small task:** add `<c-customer-status></c-customer-status>` right below `<c-customer-greeting></c-customer-greeting>` inside `customerDesk.html`, set `<isExposed>false</isExposed>` in `customerStatus.js-meta.xml`, and deploy `force-app`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
