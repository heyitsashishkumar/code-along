# 11 · Send a Message Up: Child to Parent (`CustomEvent`)

The code for **LWC from Zero #11**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Clicking any customer tile in **`contactTile`** now fires a custom `'select'` event carrying that customer's `Id` in `detail`. The parent **`contactList`** listens with `onselect={handleSelect}` and displays `Selected: <Name>, <Phone>` at the bottom of the card.

The key idea: **data goes down from parent to child with `@api`; messages go up from child to parent with `new CustomEvent('name', { detail })` and `this.dispatchEvent(...)`.**

**`force-app/main/default/lwc/contactTile/contactTile.html`**:

```html
<template>
    <div class="tile slds-box slds-box_x-small slds-m-bottom_x-small" onclick={handleClick}>
        <p class="slds-text-heading_small">{contact.Name}</p>
        <p class="slds-text-color_weak">{contact.Title}</p>
    </div>
</template>
```

**`contactTile.js`**:

```js
import { LightningElement, api } from 'lwc';

export default class ContactTile extends LightningElement {
    @api contact;

    handleClick() {
        const selectEvent = new CustomEvent('select', { detail: this.contact.Id });
        this.dispatchEvent(selectEvent);
    }
}
```

**`force-app/main/default/lwc/contactList/contactList.html`**:

```html
<template>
    <lightning-card title="Customers" icon-name="standard:contact">
        <div class="slds-p-horizontal_small">
            <template for:each={contacts} for:item="contact">
                <c-contact-tile key={contact.Id} contact={contact} onselect={handleSelect}></c-contact-tile>
            </template>
            <template lwc:if={selectedContact}>
                <p class="selected slds-m-top_small">Selected: {selectedContact.Name}, {selectedContact.Phone}</p>
            </template>
        </div>
    </lightning-card>
</template>
```

**`contactList.js`**:

```js
import { LightningElement } from 'lwc';

export default class ContactList extends LightningElement {
    contacts = [
        { Id: '1', Name: 'Ravi Verma', Title: 'Owner', Phone: '+91 90000 00109' },
        { Id: '2', Name: 'Neha Gupta', Title: 'Purchase Manager', Phone: '+91 90000 00112' },
        { Id: '3', Name: 'Lakshmi Iyer', Title: 'Managing Director', Phone: '+91 90000 00113' },
        { Id: '4', Name: 'Zubair Khan', Title: 'Owner', Phone: '+91 90000 00115' },
        { Id: '5', Name: 'Rani Das', Title: 'Owner', Phone: '+91 90000 00117' }
    ];
    selectedId;

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        return this.contacts.find((contact) => contact.Id === this.selectedId);
    }
}
```

## Deploy it

Deploy `force-app` from VS Code or the terminal:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```

Refresh the **Customer Desk** tab and click a customer tile.

## What you should see

- Click **Ravi Verma**: below the five tiles, `Selected: Ravi Verma, +91 90000 00109` appears.
- Click **Lakshmi Iyer**: the line updates immediately to `Selected: Lakshmi Iyer, +91 90000 00113`.

**Your small task:** also show `{selectedContact.Title}` in the `Selected:` paragraph (`Selected: {selectedContact.Name} ({selectedContact.Title}), {selectedContact.Phone}`).

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
