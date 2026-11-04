# 18 · Wire an Apex Method (`@AuraEnabled(cacheable=true)` and `@salesforce/apex`)

The code for **LWC from Zero #18** (opening Part 3: Calling Apex, paired with **Apex from Zero #12**). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`ContactController.cls`**, an Apex controller marked `public with sharing` with two `@AuraEnabled(cacheable=true)` read methods (`getContacts()` and `findContacts(String searchKey)` using `WITH USER_MODE`).
2. **`contactSearch`** upgraded from its hard-coded array in video 13 to wire live `Contact` records from your org using `@wire(findContacts, { searchKey: '$searchKey' })`, a 300 ms debounce (`setTimeout`), `<c-contact-tile>`, and `<c-error-panel errors={contacts.error}></c-error-panel>`.

The key idea: **import the Apex method from `@salesforce/apex/ClassName.methodName`, mark the Apex method `@AuraEnabled(cacheable=true)`, and prefix reactive parameters with `$` (`'$searchKey'`).**

**`force-app/main/default/classes/ContactController.cls`**:

```apex
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WHERE Name LIKE :key
            WITH USER_MODE
            ORDER BY Name
            LIMIT 10
        ];
    }
}
```

**`force-app/main/default/lwc/contactSearch/contactSearch.js`**:

```js
import { LightningElement, wire } from 'lwc';
import findContacts from '@salesforce/apex/ContactController.findContacts';

const DELAY = 300;

export default class ContactSearch extends LightningElement {
    searchKey = '';
    selectedId;
    delayTimeout;

    @wire(findContacts, { searchKey: '$searchKey' })
    contacts;

    handleSearchChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    handleSelect(event) {
        this.selectedId = event.detail;
    }

    get selectedContact() {
        const contacts = this.contacts.data || [];
        return contacts.find((contact) => contact.Id === this.selectedId);
    }
}
```

**`contactSearch.html`**:

```html
<template>
    <lightning-card title="Find a customer" icon-name="standard:search">
        <div class="slds-p-horizontal_small">
            <lightning-input type="search" label="Search by name" onchange={handleSearchChange} class="slds-m-bottom_small"></lightning-input>
            <template lwc:if={contacts.data}>
                <div onselect={handleSelect}>
                    <template for:each={contacts.data} for:item="contact">
                        <c-contact-tile key={contact.Id} contact={contact}></c-contact-tile>
                    </template>
                </div>
            </template>
            <template lwc:if={selectedContact}>
                <p class="selected slds-m-top_small">Selected: {selectedContact.Name}, {selectedContact.Phone}</p>
            </template>
            <c-error-panel errors={contacts.error}></c-error-panel>
        </div>
    </lightning-card>
</template>
```

## Deploy and open it

1. If you haven't imported Sharma Traders' sample records yet, run once:

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. Deploy `force-app` (both `ContactController.cls` and the LWC components):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

3. Open the **Customer Desk** tab in your org and look at the **Find a customer** card (`contactSearch`).

## What you should see

- Before you type anything, `searchKey` is `''` and the first 10 contacts from your org load automatically in alphabetical order.
- Type `Verma` in **Search by name**: 300 ms after you stop typing, the list narrows to **Pooja Verma** and **Ravi Verma**.
- Click **Ravi Verma**: `Selected: Ravi Verma, +91 90000 00109` appears at the bottom of the card.

**Your small task:** check `ContactController.getContacts()` and see how you could wire a zero-parameter Apex method with `@wire(getContacts) contacts;` when no search input is needed.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
