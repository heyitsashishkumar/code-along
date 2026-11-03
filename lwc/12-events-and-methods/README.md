# 12 · Event Bubbling, `@api` Setters, and Calling a Child (`lwc:ref`)

The code for **LWC from Zero #12**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Three upgrades to the customer list on **`customerDesk`**:
1. **Event bubbling (`bubbles: true`)**: `contactTile` adds `bubbles: true` to its `'select'` event so `contactList.html` can listen once on the surrounding `<div onselect={handleSelect}>` instead of on every `<c-contact-tile>`.
2. **`@api` getter + setter (`get contact()` / `set contact(value)`)**: `contactTile` computes a two-letter avatar badge (`RV`, `NG`, `LI`, `ZK`, `RD`) whenever the parent passes a `contact` in.
3. **Public method (`@api clearSelection()`) + `lwc:ref`**: `contactList` exposes `@api clearSelection()`, and `customerDesk` calls `this.refs.contactList.clearSelection()` when you click **Clear selection**.

The key idea: **use `bubbles: true` to catch a child event on an element inside the parent's template, an `@api` getter/setter pair to run code whenever `@api` data arrives, and `@api` on a method plus `lwc:ref` (`this.refs`) when a parent needs to tell a child to do something.**

**`force-app/main/default/lwc/contactTile/contactTile.js`**:

```js
import { LightningElement, api } from 'lwc';

export default class ContactTile extends LightningElement {
    _contact;
    initials = '';

    @api
    get contact() {
        return this._contact;
    }

    set contact(value) {
        this._contact = value;
        this.initials = value
            ? value.Name.split(' ')
                  .map((part) => part[0])
                  .join('')
            : '';
    }

    handleClick() {
        const selectEvent = new CustomEvent('select', {
            detail: this.contact.Id,
            bubbles: true
        });
        this.dispatchEvent(selectEvent);
    }
}
```

**`force-app/main/default/lwc/contactList/contactList.html`**:

```html
<template>
    <lightning-card title="Customers" icon-name="standard:contact">
        <div class="slds-p-horizontal_small" onselect={handleSelect}>
            <template for:each={contacts} for:item="contact">
                <c-contact-tile key={contact.Id} contact={contact}></c-contact-tile>
            </template>
            <template lwc:if={selectedContact}>
                <p class="selected slds-m-top_small">Selected: {selectedContact.Name}, {selectedContact.Phone}</p>
            </template>
        </div>
    </lightning-card>
</template>
```

**`force-app/main/default/lwc/customerDesk/customerDesk.html`**:

```html
<template>
    <c-customer-card></c-customer-card>
    <c-contact-list lwc:ref="contactList"></c-contact-list>
    <lightning-button label="Clear selection" onclick={handleClear} class="slds-m-top_small"></lightning-button>
</template>
```

**`customerDesk.js`**:

```js
import { LightningElement } from 'lwc';

export default class CustomerDesk extends LightningElement {
    handleClear() {
        this.refs.contactList.clearSelection();
    }
}
```

## Deploy it

Deploy `force-app` from VS Code or the terminal:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```

Refresh the **Customer Desk** tab.

## What you should see

- Each customer tile now starts with a circular initials badge (`RV`, `NG`, `LI`, `ZK`, `RD`).
- Clicking **Ravi Verma** shows `Selected: Ravi Verma, +91 90000 00109`.
- Clicking **Clear selection** underneath the card clears the `Selected:` line immediately.

**Your small task:** disable the **Clear selection** button when nothing is selected, or add a second button in `customerDesk` that calls a new `@api selectFirst()` method on `contactList`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
