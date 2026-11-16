# 006 · Your first component

The code at the end of **video 6** of *LWC & Apex from Zero: Code Along*, "Your First Component: Three Files and What Every Line Means". Type it yourself first, then compare your files with these.

## What you built

**`customerCard`**, the first piece of Sharma Traders' Customer Desk. A component is a folder with three files (ignore the `__tests__` folder until video 82):

**`force-app/main/default/lwc/customerCard/customerCard.html`** is what it shows:

```html
<template>
    <h1>Ravi Verma</h1>
    <p>Verma Logistics, Noida</p>
</template>
```

**`customerCard.js`** is what it does. Nothing yet: VS Code wrote it for us.

```js
import { LightningElement } from 'lwc';

export default class CustomerCard extends LightningElement {}
```

**`customerCard.js-meta.xml`** says where it can go. Not on a page yet: video 7 changes `isExposed`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>68.0</apiVersion>
    <isExposed>false</isExposed>
</LightningComponentBundle>
```

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org with `SFDX: Authorize an Org`, as in video 5. If you're coding along in your own `sharma-desk` project, that's already done.

Then open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Deploy This Source to Org` on the `force-app` folder, or, in the terminal, from inside this folder:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```
