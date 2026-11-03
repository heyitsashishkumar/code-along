# Troubleshooting · 10 · Pass Data Down: Parent to Child (`@api`)

These are all the errors we hit while making **LWC from Zero #10**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `Cannot read properties of undefined (reading 'Name')` on the page

If you write `contact;` in `contactTile.js` without `@api` in front of it, the deploy succeeds, and then on the **Customer Desk** page the **Customers** card shows **"A Component Error has occurred!"** with:

```
Cannot read properties of undefined (reading 'Name')
```

- **Why:** without `@api`, `contact` is private to `contactTile`. Even though `contactList.html` writes `contact={contact}`, LWC refuses to set a private property from outside, so `this.contact` stays `undefined` when `contactTile.html` tries to read `{contact.Name}`.
- **Fix:** import `api` from `'lwc'` and decorate the property with `@api`:

  ```js
  import { LightningElement, api } from 'lwc';

  export default class ContactTile extends LightningElement {
      @api contact;
  }
  ```

## `LWC1071: Missing key for element <c-contact-tile> inside of iterator`

Leaving `key={contact.Id}` off `<c-contact-tile>` inside `<template for:each={contacts} for:item="contact">` fails to deploy with:

```
LWC1071: Missing key for element <c-contact-tile> inside of iterator. Elements within iterators must have a unique, computed key value. (5:17)
```

- **Why:** a custom child component inside `for:each` follows the exact same rule as `<li>` in video 7: the first element inside the loop must carry a unique `key`.
- **Fix:** add `key={contact.Id}` on `<c-contact-tile>`.

## `LWC1093: @api method or property cannot be used with @track`

Putting both `@api` and `@track` on `contact` (`@api @track contact;`) fails to deploy with:

```
LWC1535: Unexpected plugin compilation error: Plugin - lwc, Hook - transform, Cause - SyntaxError: /home/sfdc/tools/sfdc-lwc-compiler/15.3.16010/contactTile.js: LWC1093: @api method or property cannot be used with @track (3:2)
```

- **Fix:** use `@api contact;` only. Public `@api` properties are already reactive when the parent passes a new value.

## `No MODULE named markup://c:contactTile found : [markup://c:contactList]`

Deploying `contactList` on its own before `contactTile` has been deployed to the org fails with:

```
No MODULE named markup://c:contactTile found : [markup://c:contactList]
```

- **Fix:** deploy `force-app` (or `force-app/main/default/lwc`) so `contactTile` and `contactList` deploy in the same batch.

## Changing `this.contact.Name = '...'` inside `contactTile` does nothing

If a method inside `contactTile.js` tries to overwrite a property on the object passed from the parent (`this.contact.Name = 'Changed by the child'`), the name on screen does not change and the browser console logs `Script error. null`.

- **Why:** objects passed down through `@api` are wrapped in a read-only membrane. Data flows **down** through `@api`; when a child wants something changed, it sends an event **up** to the parent (video 11).
