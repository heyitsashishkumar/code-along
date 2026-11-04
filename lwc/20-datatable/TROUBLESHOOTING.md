# Troubleshooting · 20 · Tables: `lightning-datatable`, Inline Edit and `refreshApex`

These are all the errors and traps we hit while making **LWC from Zero #20**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## After clicking Save, the table snaps back to the old Amount (`refreshApex(this.deals.data)`)

If you write `await refreshApex(this.deals.data);` instead of `await refreshApex(this.deals);`:

- **Why:** `refreshApex` needs the outer wired property object (`this.deals`, which contains `{ data, error }` plus internal wire metadata) so Lightning Data Service knows which wire call to re-run. Passing `this.deals.data` (just the inner array) does nothing, leaving the cached array stale until you reload the browser tab.
- **Fix:** pass the whole wired property:

  ```js
  await refreshApex(this.deals);
  ```

## Yellow edited cells and the bottom Save / Cancel bar stay stuck on screen after saving

- **Why:** `<lightning-datatable draft-values={draftValues}>` stays in draft mode until `draftValues` is reset to an empty array.
- **Fix:** set `this.draftValues = [];` inside the `try` block after `Promise.all(...)` finishes.

## A column in `lightning-datatable` is completely blank

If you write `{ label: 'Amount', fieldName: 'amount' }` with a lowercase `'a'`:

- **Why:** `lightning-datatable` matches each column's `fieldName` to the SObject field names returned by SOQL **case-sensitively**. Because SOQL returns `Amount`, `Name`, `StageName` and `CloseDate`, `'amount'` doesn't match any property on the row.
- **Fix:** match the exact Salesforce field API names (`'Name'`, `'StageName'`, `'Amount'`, `'CloseDate'`).

## Inline edit pencil icon doesn't save when `key-field="Id"` is missing or misspelled

- **Why:** `lightning-datatable` uses `key-field="Id"` to attach the record's `Id` to each item in `event.detail.draftValues`. If `key-field` is set to `"id"` (lowercase), `draftValues` won't have `Id`, and `updateRecord` will fail because no record ID was provided.
- **Fix:** always set `key-field="Id"` with a capital `I`.
