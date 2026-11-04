# Troubleshooting · 21 · Moving Around the App (`NavigationMixin`)

These are all the errors and traps we hit while making **LWC from Zero #21**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## Clicking a navigation button does nothing (`TypeError: this[NavigationMixin.Navigate] is not a function`)

If your class declaration still says `export default class CustomerSummary extends LightningElement` instead of `extends NavigationMixin(LightningElement)`:

- **Why:** `this[NavigationMixin.Navigate]` is a symbol-keyed method added to your component's prototype by the `NavigationMixin(...)` wrapper function. Without `extends NavigationMixin(LightningElement)`, `this[NavigationMixin.Navigate]` is `undefined`.
- **Fix:** wrap `LightningElement` in `NavigationMixin(LightningElement)`:

  ```js
  export default class CustomerSummary extends NavigationMixin(LightningElement) {
  ```

## Clicking "Open company" does nothing or opens an invalid page

- **Why:** `handleOpenCompany()` reads `getFieldValue(this.contact.data, ACCOUNT_ID_FIELD)`. If you forgot to add `ACCOUNT_ID_FIELD` (`@salesforce/schema/Contact.AccountId`) to the `FIELDS` array passed to `@wire(getRecord, ...)`, `getFieldValue` returns `undefined`.
- **Fix:** ensure `ACCOUNT_ID_FIELD` is included in `const FIELDS = [..., ACCOUNT_ID_FIELD, ACCOUNT_NAME_FIELD];`.

## Writing `this.NavigationMixin.Navigate(...)` with a dot instead of square brackets

- **Why:** `NavigationMixin.Navigate` is a JavaScript `Symbol`, not a string property name named `"NavigationMixin"`.
- **Fix:** always call it with square brackets: `this[NavigationMixin.Navigate]({ ... });`.
