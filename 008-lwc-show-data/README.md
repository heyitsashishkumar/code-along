# 008 · Show data from JavaScript

The code at the end of **video 8** of *LWC & Apex from Zero: Code Along*, "Show Data from JavaScript (Classes, Objects, Fields, Curly Braces)". Type it yourself first, then compare your files with these.

## What you built

**`customerGreeting`**, placed under `customerCard` on the Customer Desk page. It shows **Namaste, friend!**

**`customerGreeting.html`**:

```html
<template>
    <p>Namaste, {name}!</p>
</template>
```

**`customerGreeting.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerGreeting extends LightningElement {
    name = 'friend';
}
```

`customerCard` is unchanged from [007](../007-lwc-on-a-real-page/).

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org with `SFDX: Authorize an Org`, as in video 5. If you're coding along in your own `sharma-desk` project, that's already done.

Then open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Deploy This Source to Org` on the `force-app` folder, or, in the terminal, from inside this folder:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```
