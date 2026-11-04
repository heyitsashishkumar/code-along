# 23 · Modals, Alerts, Labels and Static Resources (`LightningModal`, `LightningAlert`, `LightningConfirm`, `@salesforce/label` and `@salesforce/resourceUrl`)

The code for **LWC from Zero #23**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`noteModal`** (`extends LightningModal` from `'lightning/modal'`), a popup dialog with `<lightning-modal-header>`, `<lightning-modal-body>`, and `<lightning-modal-footer>` that returns the note text via `this.close(this.note)`.
2. **`customerSummary`** updated with an **Add note** button: opens `await NoteModal.open({ size: 'small', customerName: this.name })`, warns with `await LightningAlert.open(...)` if the note is blank, or saves a completed `Task` record linked to the customer (`WhoId: this.recordId`).
3. **`newCustomer`** updated to ask `await LightningConfirm.open(...)` before calling `deleteRecord(this.contactId)`.
4. **`deskHeader`**, displaying the Sharma Traders SVG logo from `staticresources/sharmaTradersLogo.svg` (`@salesforce/resourceUrl/sharmaTradersLogo`) and custom labels `Desk_Title` and `Desk_Subtitle` from `labels/CustomLabels.labels-meta.xml` (`@salesforce/label/c.Desk_Title`).

The key idea: **use `LightningModal`, `LightningAlert` and `LightningConfirm` instead of browser `window.alert()` / `window.confirm()`, and keep translatable text and brand assets in Custom Labels and Static Resources.**

**`force-app/main/default/lwc/noteModal/noteModal.js`**:

```js
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class NoteModal extends LightningModal {
    @api customerName;
    note = '';

    get heading() {
        return `Add a note about ${this.customerName}`;
    }

    handleNoteChange(event) {
        this.note = event.target.value;
    }

    handleSave() {
        this.close(this.note);
    }

    handleCancel() {
        this.close();
    }
}
```

**`force-app/main/default/lwc/deskHeader/deskHeader.js`**:

```js
import { LightningElement } from 'lwc';
import LOGO from '@salesforce/resourceUrl/sharmaTradersLogo';
import DESK_TITLE from '@salesforce/label/c.Desk_Title';
import DESK_SUBTITLE from '@salesforce/label/c.Desk_Subtitle';

export default class DeskHeader extends LightningElement {
    logoUrl = LOGO;
    label = {
        title: DESK_TITLE,
        subtitle: DESK_SUBTITLE
    };
}
```

## Deploy and open it

1. Deploy `force-app` (which now includes `labels/` and `staticresources/`):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On **Ravi Verma**'s Contact record page, click **Add note** in **Customer summary**, type a note, and click **Save** (or leave it empty and click **Save** to see `LightningAlert`).
3. On the **Customer Desk** page, create a test customer in **New customer** and click **Delete** to see the `LightningConfirm` dialog.

## What you should see

- Clicking **Add note** opens a modal titled `Add a note about Ravi Verma`.
- Clicking **Save** with an empty note opens a warning `LightningAlert` (`Nothing to save — Write the note first, then click Save.`).
- Clicking **Save** with text creates a completed `Task` in Ravi Verma's activity history and shows a green `Note saved` toast.
- Clicking **Delete** in **New customer** opens a `LightningConfirm` dialog (`Delete this customer?`) before deleting.

**Your small task:** add a third Custom Label `Desk_Footer` in `CustomLabels.labels-meta.xml`, import it in `deskHeader.js`, and render it in `deskHeader.html`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
