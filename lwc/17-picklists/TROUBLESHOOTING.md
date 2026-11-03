# Troubleshooting · 17 · Picklists and Object Info Without Hardcoding (`getObjectInfo` and `getPicklistValues`)

These are all the errors and traps we hit while making **LWC from Zero #17**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## The combobox shows its label (`Lead Source`), but the dropdown options are completely empty

If you leave the `$` off `'$objectInfo.data.defaultRecordTypeId'` inside `@wire(getPicklistValues, ...)`:

```js
// Broken:
@wire(getPicklistValues, {
    recordTypeId: 'objectInfo.data.defaultRecordTypeId',
    fieldApiName: LEAD_SOURCE_FIELD
})
picklistValues;
```

the deploy succeeds, the card renders with the `Lead Source` label (from `getObjectInfo`), and clicking `Pick one` opens an empty dropdown with no error in the console.

- **Why:** without `$`, `@wire` passes the literal string `'objectInfo.data.defaultRecordTypeId'` as a record type ID instead of waiting for `this.objectInfo.data.defaultRecordTypeId` to arrive from the first wire.
- **Fix:** put `$` at the start of the string (`'$objectInfo.data.defaultRecordTypeId'`) so the second wire waits for `objectInfo.data` and runs automatically once `defaultRecordTypeId` is ready.

## `Invalid reference Contact.LeadSourc of type sobjectField in file leadSourcePicker.js`

Misspelling the field name in `@salesforce/schema/Contact.LeadSourc` fails at deploy time with:

```
Invalid reference Contact.LeadSourc of type sobjectField in file leadSourcePicker.js
```

- **Fix:** use `@salesforce/schema/Contact.LeadSource`.

## `Cannot read properties of undefined (reading 'fields')` or `(reading 'values')`

If `get label()` writes `return this.objectInfo.data.fields.LeadSource.label;` without checking `this.objectInfo.data` first (or `get options()` reads `this.picklistValues.data.values` without checking `this.picklistValues.data`), the component throws `Cannot read properties of undefined` on initial render before the wires finish.

- **Fix:** guard both getters with a ternary check:

  ```js
  get label() {
      return this.objectInfo.data ? this.objectInfo.data.fields.LeadSource.label : '';
  }

  get options() {
      return this.picklistValues.data ? this.picklistValues.data.values : [];
  }
  ```

## Selecting an option in `lightning-combobox` doesn't show `You picked: ...`

- **Why:** `lightning-combobox` puts the chosen value on `event.detail.value` (standard custom event payload), whereas in earlier videos we read `event.target.value`.
- **Fix:** read `this.value = event.detail.value;` inside `handleChange(event)`.
