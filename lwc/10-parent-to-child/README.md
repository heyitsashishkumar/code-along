# 10 · Pass Data Down: Parent to Child (`@api`)

The code for **LWC from Zero #10**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Two components that work together to display five Sharma Traders customers:
- **`contactTile`** (child): marks `contact` with `@api` so its parent can pass a customer object in, and renders `{contact.Name}` and `{contact.Title}` in an SLDS box.
- **`contactList`** (parent): holds the array of five customers (`Ravi Verma`, `Neha Gupta`, `Lakshmi Iyer`, `Zubair Khan`, `Rani Das`) and repeats `<c-contact-tile key={contact.Id} contact={contact}></c-contact-tile>` with `for:each`.

The key idea: **a child's properties are private by default; add `@api` in the child so a parent can pass data in through an attribute, and treat `@api` data as read-only inside the child.**

**`force-app/main/default/lwc/contactTile/contactTile.js`**:

```js
import { LightningElement, api } from 'lwc';

export default class ContactTile extends LightningElement {
    @api contact;
}
```

**`contactTile.html`**:

```html
<template>
    <div class="tile slds-box slds-box_x-small slds-m-bottom_x-small">
        <p class="slds-text-heading_small">{contact.Name}</p>
        <p class="slds-text-color_weak">{contact.Title}</p>
    </div>
</template>
```

**`force-app/main/default/lwc/contactList/contactList.js`**:

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
}
```

**`contactList.html`**:

```html
<template>
    <lightning-card title="Customers" icon-name="standard:contact">
        <div class="slds-p-horizontal_small">
            <template for:each={contacts} for:item="contact">
                <c-contact-tile key={contact.Id} contact={contact}></c-contact-tile>
            </template>
        </div>
    </lightning-card>
</template>
```

## Deploy it and add it to the desk

1. Deploy `force-app` from VS Code or the terminal:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. Place `<c-contact-list></c-contact-list>` inside `customerDesk.html` (or add `contactList` to the **Customer Desk** page in App Builder) and refresh the **Customer Desk** tab.

## What you should see

Inside the **Customers** card, five boxed customer tiles appear one below another:
- **Ravi Verma** — Owner
- **Neha Gupta** — Purchase Manager
- **Lakshmi Iyer** — Managing Director
- **Zubair Khan** — Owner
- **Rani Das** — Owner

**Your small task:** add `<p>{contact.Phone}</p>` below `{contact.Title}` in `contactTile.html` and deploy.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
