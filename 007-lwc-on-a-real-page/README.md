# 007 · On a real Salesforce page

The code at the end of **video 7** of *LWC & Apex from Zero: Code Along*, "Put Your Component on a Real Salesforce Page". Type it yourself first, then compare your files with these.

## What you built

`customerCard` is exposed, so Lightning App Builder can place it. **`customerCard.js-meta.xml`**:

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

The **Customer Desk** app page, its tab and its place in the Sales app are made by clicking in App Builder (video 7). They live in your org, not in this folder.

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org with `SFDX: Authorize an Org`, as in video 5. If you're coding along in your own `miller-desk` project, that's already done.

Then open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Deploy This Source to Org` on the `force-app` folder, or, in the terminal, from inside this folder:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```
