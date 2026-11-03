# Troubleshooting · 14 · Show and Edit Real Salesforce Records (`lightning-record-form`)

These are all the traps we hit while making **LWC from Zero #14**, tested on our own org (`lwc-long` and `lwc-rehearse` at API `68.0`).

## A field is missing from the form, with no deploy error (`'Phonee'`)

If you misspell a field name inside the string array in `customerForm.js` — for example:

```js
fields = ['Name', 'Title', 'Phonee', 'Email', 'LeadSource', 'MailingCity'];
```

the deploy succeeds without any error, and on the Contact page the `Phone` field simply does not appear.

- **Why:** plain strings like `'Phonee'` are not checked by the compiler when you deploy. Salesforce only discovers the bad field name at runtime in the browser. (Video 15 replaces string field names with `@salesforce/schema/Contact.Phone` imports so the compiler catches typos at deploy time.)
- **Fix:** check the exact API name of each field (`'Name'`, `'Title'`, `'Phone'`, `'Email'`, `'LeadSource'`, `'MailingCity'`).

## The form shows empty blank inputs (create mode) instead of the Contact's values

- **Did you forget `@api` before `recordId` in `customerForm.js`, or spell it `recordID` (capital `D`)?**
  - **Why:** Lightning Record Pages pass the current record's ID into the exact public property `@api recordId`. If `@api` is missing or the casing differs, `recordId` stays `undefined`, and `lightning-record-form` without a `record-id` switches to creating a brand-new record.
  - **Fix:** declare `@api recordId;` in `customerForm.js` and bind `record-id={recordId}` in `customerForm.html`.

- **Did you place `customerForm` on the Customer Desk app page (`lightning__AppPage`) instead of a Contact record page (`lightning__RecordPage`)?**
  - **Why:** an App Page does not belong to a single Contact record, so it has no `recordId` to pass in.
  - **Fix:** open a Contact record (such as **Ravi Verma**) and use **Edit Page** there.

## `customerForm` doesn't appear in Lightning App Builder on a Contact page

- **Fix:** check `customerForm.js-meta.xml` for three things:
  1. `<isExposed>true</isExposed>`
  2. `<target>lightning__RecordPage</target>` inside `<targets>`
  3. `<object>Contact</object>` inside `<targetConfigs>` (and make sure you opened **Edit Page** on a **Contact** record, not an Account).
