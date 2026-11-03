# Troubleshooting · 16 · Create, Update and Delete a Record from Your Own Buttons

These are all the errors we hit while making **LWC from Zero #16**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `LWC1503: Parsing error: Unexpected reserved word 'await'. (12:24)`

Using `await createRecord(...)` inside `handleCreate()` without writing `async` before `handleCreate()` fails to deploy with:

```
LWC1503: Parsing error: Unexpected reserved word 'await'. (12:24)
```

- **Why:** JavaScript only allows `await` inside a function or method marked `async`.
- **Fix:** write `async handleCreate()`, `async handleUpdate()`, and `async handleDelete()`.

## `Required fields are missing: [LastName]`

If you click **Create** while **Last name** is empty:
- Without `try` / `catch` and `<c-error-panel>`, nothing appears on the page at all (an unhandled Promise rejection).
- With `try` / `catch` and `<c-error-panel>` (using `reduceErrors` in `ldsUtils.js` to read `error.body.output.fieldErrors.LastName[0].message`), the card shows in red:

```
Required fields are missing: [LastName]
```

- **Why:** `LastName` is required on every Salesforce `Contact` record.
- **Fix:** enter a Last name before clicking **Create**.

## `Enter a valid email address, such as name@email.com.` / `Email: invalid email address: not-an-email`

If you type `not-an-email` into the **Email** box:
1. As soon as you leave the field, `<lightning-input type="email">` shows its own client-side message underneath the input:

   ```
   Enter a valid email address, such as name@email.com.
   ```

2. And if you click **Create** anyway, Salesforce rejects the save and `<c-error-panel>` displays the server-side field error:

   ```
   Email: invalid email address: not-an-email
   ```

- **Fix:** enter a valid email address (or leave Email blank).

## `updateRecord` fails because `Id` is missing

- **Why:** `updateRecord({ fields })` needs to know *which* record to update. Unlike `createRecord`, `fields` must include `fields[ID_FIELD.fieldApiName] = this.contactId;`.
- **Fix:** always set `ID_FIELD.fieldApiName` on `fields` before calling `updateRecord({ fields })`.

## Why can't I write `fields[FIRST_NAME_FIELD] = this.firstName`?

- **Why:** `FIRST_NAME_FIELD` imported from `@salesforce/schema/Contact.FirstName` is an object (`{ fieldApiName: 'FirstName', objectApiName: 'Contact' }`), not a string. `createRecord` and `updateRecord` expect the field's string API name as the key (`FIRST_NAME_FIELD.fieldApiName`), and `CONTACT_OBJECT.objectApiName` for `apiName`.
