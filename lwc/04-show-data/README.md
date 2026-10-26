# 04 · Show data, and react to typing

The code for **LWC from Zero #4**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerGreeting`**, placed under `customerCard` on the **Customer Desk** tab: a greeting line (`Namaste, friend!`) and an input box that updates the greeting on every keystroke (`Namaste, Ravi!`).

The key idea: **the class holds the data, curly braces show it, and an event changes it.**

**`force-app/main/default/lwc/customerGreeting/customerGreeting.html`**:

```html
<template>
    <p>Namaste, {customerName}!</p>
    <lightning-input label="Customer's name" onchange={handleNameChange}></lightning-input>
</template>
```

**`customerGreeting.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerGreeting extends LightningElement {
    customerName = 'friend';

    handleNameChange(event) {
        this.customerName = event.target.value;
    }
}
```

**`customerGreeting.js-meta.xml`**:

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

The project also includes `customerCard` from [03-first-component](../03-first-component/).

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org, as in [02-setup](../02-setup/README.md#connect-the-project-to-your-org). If you're coding along in your own `customer-desk` project, that's already done.

Deploy either way:

- **In VS Code:** open any of the `customerGreeting` files, open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows), and run `SFDX: Deploy This Source to Org`.
- **Or in the terminal**, from inside the project folder:

  ```bash
  sf project deploy start --source-dir force-app --target-org desk-org
  ```

## Put it on the Customer Desk page

1. Open your org (`sf org open`) and go to the **Customer Desk** tab in the **Sales** app (created in [03-first-component](../03-first-component/)).
2. Click the gear in the top right and choose **Edit Page**. Because App Builder opens after you deployed, `customerGreeting` is already under **Custom (2)** on the left.
3. Drag `customerGreeting` under `customerCard`.
4. Click **Save** (the page is already active, so "Changes saved." is all it needs), then click the back arrow in the top left.

## What you should see

Under `customerCard`:

```
Namaste, friend!
[Customer's name input box]
```

Type `Ravi` into the box and the line updates letter by letter to `Namaste, Ravi!`. Clear the box and it shows `Namaste, !`.

**Your small task:** add a second input for the city, and show `"from"` and the city after the name (`Namaste, Ravi from Greater Noida!`). This folder doesn't include that change, so you can try it yourself.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
