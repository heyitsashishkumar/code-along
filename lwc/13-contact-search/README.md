# 13 · Build a Working Contact Search (Part 1 Capstone)

The code for **LWC from Zero #13**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`contactSearch`**, the Part 1 capstone component that brings together everything from videos 3–12:
- A `lightning-input` (`type="search"`) that debounces typing by `300` ms using `window.clearTimeout` and `setTimeout(() => { ... }, DELAY)`.
- A `get matchingContacts()` getter that filters six Sharma Traders customers case-insensitively (`toLowerCase().includes(key)`).
- Repeated `<c-contact-tile>` children inside `<div onselect={handleSelect}>`, so clicking any matching customer shows their name and phone number below the list.

The key idea: **wait 300 ms after the user stops typing before updating `this.searchKey` (debouncing), and always use an arrow function `() => { ... }` inside `setTimeout` so `this` still points to your component.**

**`force-app/main/default/lwc/contactSearch/contactSearch.html`**:

```html
<template>
    <lightning-card title="Find a customer" icon-name="standard:search">
        <div class="slds-p-horizontal_small">
            <lightning-input type="search" label="Search by name" onchange={handleSearchChange} class="slds-m-bottom_small"></lightning-input>
            <div onselect={handleSelect}>
                <template for:each={matchingContacts} for:item="contact">
                    <c-contact-tile key={contact.Id} contact={contact}></c-contact-tile>
                </template>
            </div>
            <template lwc:if={selectedContact}>
                <p class="selected slds-m-top_small">Selected: {selectedContact.Name}, {selectedContact.Phone}</p>
            </template>
        </div>
    </lightning-card>
</template>
```

**`contactSearch.js`**:

```js
import { LightningElement } from 'lwc';

const DELAY = 300;

export default class ContactSearch extends LightningElement {
    contacts = [
        { Id: '1', Name: 'Ravi Verma', Title: 'Owner', Phone: '+91 90000 00109' },
        { Id: '2', Name: 'Rakesh Gupta', Title: 'Owner', Phone: '+91 90000 00111' },
        { Id: '3', Name: 'Neha Gupta', Title: 'Purchase Manager', Phone: '+91 90000 00112' },
        { Id: '4', Name: 'Lakshmi Iyer', Title: 'Managing Director', Phone: '+91 90000 00113' },
        { Id: '5', Name: 'Zubair Khan', Title: 'Owner', Phone: '+91 90000 00115' },
        { Id: '6', Name: 'Rani Das', Title: 'Owner', Phone: '+91 90000 00117' }
    ];
    searchKey = '';
    selectedId;
    delayTimeout;

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    get matchingContacts() {
        const key = this.searchKey.toLowerCase();
        return this.contacts.filter((contact) => contact.Name.toLowerCase().includes(key));
    }

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        return this.contacts.find((contact) => contact.Id === this.selectedId);
    }
}
```

## Deploy it and add it to the page

1. Deploy `force-app` from VS Code or the terminal:

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab, click the gear in the top right, choose **Edit Page**, drag **`contactSearch`** into the right column, click **Save**, and go back to the page.

## What you should see

- With the search box empty, all six customers (`Ravi Verma`, `Rakesh Gupta`, `Neha Gupta`, `Lakshmi Iyer`, `Zubair Khan`, `Rani Das`) appear.
- Type `gupta`: 300 ms after you finish typing, the list narrows to **Rakesh Gupta** and **Neha Gupta**.
- Click **Neha Gupta**: `Selected: Neha Gupta, +91 90000 00112` appears below.

**Your small task:** add `<template lwc:if={hasNoMatches}><p>No customers match "{searchKey}".</p></template>` using a `get hasNoMatches()` getter that returns `this.matchingContacts.length === 0`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
