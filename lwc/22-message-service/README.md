# 22 · Components That Aren't Related (Lightning Message Service)

The code for **LWC from Zero #22**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`Customer_Selected.messageChannel-meta.xml`** in `force-app/main/default/messageChannels/`, defining the `Customer_Selected__c` message channel with two fields: `contactId` and `accountId`.
2. **`contactSearch`** (publisher): imports `publish` and `MessageContext` from `'lightning/messageService'` and `CUSTOMER_SELECTED` from `'@salesforce/messageChannel/Customer_Selected__c'`, and publishes `{ contactId: contact.Id, accountId: contact.AccountId }` whenever a customer tile is clicked.
3. **`customerForm`** and **`customerDeals`** (subscribers): subscribe to `CUSTOMER_SELECTED` in `connectedCallback()`, unsubscribe in `disconnectedCallback()`, and update their displayed Contact details and Account deals automatically when a customer is picked in `contactSearch`.

The key idea: **when sibling components sit in separate regions of a Lightning page without a shared parent component, use Lightning Message Service (`@wire(MessageContext)`, `publish`, `subscribe`, and `unsubscribe`) to communicate cleanly.**

**`force-app/main/default/messageChannels/Customer_Selected.messageChannel-meta.xml`**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningMessageChannel xmlns="http://soap.sforce.com/2006/04/metadata">
    <masterLabel>Customer Selected</masterLabel>
    <isExposed>true</isExposed>
    <description>Sent when a customer is picked on the customer desk.</description>
    <lightningMessageFields>
        <fieldName>contactId</fieldName>
        <description>The Id of the contact that was picked</description>
    </lightningMessageFields>
    <lightningMessageFields>
        <fieldName>accountId</fieldName>
        <description>The Id of that contact's account</description>
    </lightningMessageFields>
</LightningMessageChannel>
```

**Publishing in `contactSearch.js`**:

```js
@wire(MessageContext)
messageContext;

handleSelect(event) {
    this.selectedId = event.detail;
    const contact = this.selectedContact;
    publish(this.messageContext, CUSTOMER_SELECTED, {
        contactId: contact.Id,
        accountId: contact.AccountId
    });
}
```

**Subscribing in `customerDeals.js`**:

```js
@wire(MessageContext)
messageContext;

@wire(getDeals, { accountId: '$accountId' })
deals;

connectedCallback() {
    // On an account's page, show its deals; on the desk, wait for a customer to be picked.
    this.accountId = this.recordId;
    this.subscription = subscribe(this.messageContext, CUSTOMER_SELECTED, (message) => {
        this.accountId = message.accountId;
    });
}

disconnectedCallback() {
    unsubscribe(this.subscription);
    this.subscription = null;
}
```

## Deploy and open it

1. Deploy `force-app` (including `messageChannels/`):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. On the **Customer Desk** tab, place **`contactSearch`** in the left column and **`customerForm`** and **`customerDeals`** in the right column (both are now exposed for `lightning__AppPage` as well as `lightning__RecordPage`).

## What you should see

- Before picking a customer, `customerForm` says `Pick a customer to see their details.` and `customerDeals` says `Pick a customer to see their deals.`.
- Click **Ravi Verma** in **Find a customer**: `customerForm` immediately loads Ravi Verma's Contact fields, and `customerDeals` loads **Verma Electricals**' deals in the datatable!

**Your small task:** add a third field `<fieldName>customerName</fieldName>` to `Customer_Selected.messageChannel-meta.xml`, include `customerName: contact.Name` in `publish(...)`, and display the selected customer's name in the `Deals` card title.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
