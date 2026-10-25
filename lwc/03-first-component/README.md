# 03 · Your first component, on a real Salesforce page

The code for **LWC from Zero #3**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`customerCard`**, the first piece of Sharma Traders' customer desk: a card for one customer, on a **Customer Desk** tab in your org. Every component goes through the same six steps: **Create · Template · Script · Expose · Deploy · See**.

The component is a folder with three files (plus a `__tests__` folder for later, in video 24):

**`force-app/main/default/lwc/customerCard/customerCard.html`** is what it shows:

```html
<template>
    <h1>Ravi Sharma</h1>
    <p>Sharma Traders, Greater Noida</p>
</template>
```

**`customerCard.js`** is what it does. Nothing yet: VS Code wrote it for us.

```js
import { LightningElement } from 'lwc';

export default class CustomerCard extends LightningElement {}
```

**`customerCard.js-meta.xml`** says where it can go. `isExposed` is `true`, and the target `lightning__AppPage` lets App Builder put it on an app page:

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

The rest of the folder is the project from [02-setup](../02-setup/), unchanged.

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org, as in [02-setup](../02-setup/README.md#connect-the-project-to-your-org). If you're coding along in your own `customer-desk` project, that's already done.

Then deploy the component either way:

- **In VS Code:** open any of the `customerCard` files, open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows), and run `SFDX: Deploy This Source to Org`. It deploys the whole component and says "SFDX: Deploy This Source to Org succeeded." in the status bar. The details are in the Output panel's **Salesforce Metadata** channel.
- **Or in the terminal**, from inside the project folder:

  ```bash
  sf project deploy start --source-dir force-app --target-org desk-org
  ```

## Put it on a page

1. Open your org (`sf org open`), go to **Setup**, type **App Builder** in Quick Find, and click **Lightning App Builder**.
2. Click **New**. **App Page** is already selected, so click **Next**.
3. Label it **Customer Desk** and click **Next**. Choose **One Region**, then click **Done**.
4. Find `customerCard` under **Custom** on the left and drag it onto the page.
   - Not there? If App Builder was already open when you deployed, click **Save**, then **Not Yet**, and reload the page once.
5. Click **Save**, then **Activation…**. On the **Lightning Experience** tab, choose **Sales**, click **Add page to app**, then **Save**.
6. Go back. From the App Launcher, open **Sales** and click the **Customer Desk** tab.

## What you should see

A **Customer Desk** tab in the Sales app, showing:

```
Ravi Sharma
Sharma Traders, Greater Noida
```

It looks plain: the heading is the same size as the line under it, because Salesforce's styles reset headings. That's expected. Video 8 makes it look like Salesforce.

When you change the text and deploy again, refresh the tab to see the change. If the old text stays, do a hard refresh: hold Shift and click reload.

**Your small task:** add a line saying "Customer since 2019", then deploy and see it. This folder doesn't include that line, so you can try it yourself.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
