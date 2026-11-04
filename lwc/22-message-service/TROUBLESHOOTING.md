# Troubleshooting · 22 · Components That Aren't Related (Lightning Message Service)

These are all the errors and traps we hit while making **LWC from Zero #22**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## Deploy fails when importing `@salesforce/messageChannel/Customer_Selected__c`

If `Customer_Selected.messageChannel-meta.xml` is missing `<isExposed>true</isExposed>` or hasn't been deployed with the components:

- **Why:** a Lightning Message Channel must be in `force-app/main/default/messageChannels/Customer_Selected.messageChannel-meta.xml` with `<isExposed>true</isExposed>`, and its import name always ends in `__c` (`@salesforce/messageChannel/Customer_Selected__c`).
- **Fix:** deploy the `messageChannels` folder together with `lwc` (`sf project deploy start --source-dir force-app`).

## Clicking a customer tile updates `Selected: Ravi Verma`, but `customerDeals` never loads any deals

- **Why:** `contact.AccountId` must be returned by `ContactController.findContacts` so `publish(this.messageContext, CUSTOMER_SELECTED, { contactId: contact.Id, accountId: contact.AccountId })` sends a real Account ID. Also check that `@wire(getDeals, { accountId: '$accountId' })` in `customerDeals.js` uses `'$accountId'` with the `$` prefix.
- **Fix:** ensure `AccountId` is in the `SELECT` list of `ContactController.findContacts`, and `@wire(getDeals, { accountId: '$accountId' })` has the `$` prefix.

## Leaving out `@wire(MessageContext) messageContext;`

- **Why:** `publish(this.messageContext, ...)` and `subscribe(this.messageContext, ...)` require a wired `MessageContext` object as their first argument so Salesforce knows which Lightning page context the components belong to.
- **Fix:** declare `@wire(MessageContext) messageContext;` on every component that calls `publish` or `subscribe`.
