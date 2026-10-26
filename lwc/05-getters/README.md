# 05 · Calculated values with getters

The code for **LWC from Zero #5**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerName`**, placed under `customerGreeting` on the **Customer Desk** tab: two `lightning-input` boxes (first name and last name) and a `Full name:` line calculated on the fly by a JavaScript getter.

The key idea: **a getter works out a value from other values, and the template reads it like a field.**

**`force-app/main/default/lwc/customerName/customerName.html`**:

```html
<template>
    <lightning-input label="First name" onchange={handleFirstNameChange}></lightning-input>
    <lightning-input label="Last name" onchange={handleLastNameChange}></lightning-input>
    <p>Full name: {fullName}</p>
</template>
```

**`customerName.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerName extends LightningElement {
    firstName = '';
    lastName = '';

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
}
```

**`customerName.js-meta.xml`**:

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

The project also includes `customerCard` and `customerGreeting` from videos 3 and 4.

## Deploy it and add it to the page

1. Deploy `force-app` from VS Code (`SFDX: Deploy This Source to Org`) or the terminal:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab in your org, click the gear in the top right and choose **Edit Page**.
3. Under **Custom (3)** on the left, drag `customerName` below `customerGreeting`.
4. Click **Save**, then click the back arrow in the top left.

## What you should see

Before you type anything, both fields are empty, so the line reads:

```
Full name:
```

Type `Ravi` in **First name** and `Sharma` in **Last name**, and the line updates on every letter to:

```
Full name: Ravi Sharma
```

**Your small task:** add a second getter called `initials`, and show `Initials: RS` for `Ravi Sharma` (hint: `this.firstName.charAt(0)`). This folder doesn't include that getter, so you can try it yourself.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
