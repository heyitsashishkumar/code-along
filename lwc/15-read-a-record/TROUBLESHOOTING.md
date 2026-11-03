# Troubleshooting · 15 · Read a Record into Your Own HTML (`@wire` and `getRecord`)

These are all the errors we hit while making **LWC from Zero #15**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `Invalid reference Contact.Phonee of type sobjectField in file customerSummary.js`

Misspelling a field API name in a `@salesforce/schema/...` import — such as `import PHONE_FIELD from '@salesforce/schema/Contact.Phonee';` — fails right at deploy time with:

```
Invalid reference Contact.Phonee of type sobjectField in file customerSummary.js
```

- **Why:** unlike plain strings in video 14, `@salesforce/schema/...` imports are verified against your org's real object and field metadata when you deploy (and prevents someone from deleting a field in Setup while your component references it).
- **Fix:** change `Contact.Phonee` to `Contact.Phone`.

## The **Customer summary** card stays completely blank, with no error (`recordId: 'recordId'`)

If you leave the `$` off `'$recordId'` inside `@wire`:

```js
// Broken:
@wire(getRecord, { recordId: 'recordId', fields: FIELDS })
contact;
```

the deploy succeeds, and on the Contact page the **Customer summary** card stays blank forever — neither `contact.data` nor `contact.error` is ever set, and no error is logged.

- **Why:** without `$`, LWC passes the literal 8-letter word `'recordId'` as the record ID instead of reading `this.recordId`. Putting `$` inside the string (`'$recordId'`) tells `@wire` to read `this.recordId` and re-run whenever `this.recordId` changes.
- **Fix:** write `recordId: '$recordId'` (with the `$` inside the quotes).

## `Cannot read properties of undefined` when the component first loads

If your template or getter tries to read nested properties on `this.contact.data.fields.Name.value` before `@wire` has returned data from Salesforce, it throws `Cannot read properties of undefined`.

- **Why:** when `customerSummary` is first created, `this.contact` is `{}` (`this.contact.data` is `undefined`). Data arrives a moment later when the wire finishes.
- **Fix:** wrap the template markup in `<template lwc:if={contact.data}>` and use `getFieldValue(this.contact.data, NAME_FIELD)` inside your getters.

## Writing `{contact.data.Name}` shows nothing on the card

- **Why:** `getRecord` does not return a flat object with `.Name`; it returns `{ fields: { Name: { value: 'Ravi Verma', displayValue: null }, ... } }`.
- **Fix:** use `getFieldValue(this.contact.data, NAME_FIELD)` from `'lightning/uiRecordApi'`.
