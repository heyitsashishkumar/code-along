# Troubleshooting · 25 · Put It Together: Sharma Traders' Customer Desk

Every real error we hit while building and testing **LWC from Zero #25**, copied word-for-word from our terminal (`bugs.md` `B07`), never from memory.

## `TypeError: Cannot read properties of undefined (reading 'data')` inside `contactSearch.html` when running `customerDesk.test.js` (`B07`)

When you run `npx jest customerDesk` without mocking the children's Apex imports, the test crashes inside `<c-contact-search>`'s template with:

```
  ● c-customer-desk › puts the desk together: header, search, details and deals

    TypeError: Cannot read properties of undefined (reading 'data')

      at tmpl (force-app/main/default/lwc/contactSearch/contactSearch.html:59:1)
```

- **Why:** in Jest, mounting `<c-customer-desk>` also mounts its real child components (`<c-contact-search>` and `<c-customer-deals>`). Without test wire adapters registered for their `@salesforce/apex` imports, `this.contacts` and `this.deals` remain `undefined` in Jest, so reading `contacts.data` in the child's template throws `TypeError`. (In a real org, the wire service initializes wired properties to `{ data: undefined, error: undefined }` automatically.)
- **Fix:** mock the children's Apex imports with `createApexTestWireAdapter` at the top of `customerDesk.test.js`:

  ```js
  jest.mock(
      '@salesforce/apex/ContactController.findContacts',
      () => {
          const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
          return { default: createApexTestWireAdapter(jest.fn()) };
      },
      { virtual: true }
  );
  jest.mock(
      '@salesforce/apex/DealController.getDeals',
      () => {
          const { createApexTestWireAdapter } = require('@salesforce/sfdx-lwc-jest');
          return { default: createApexTestWireAdapter(jest.fn()) };
      },
      { virtual: true }
  );
  ```

## `No MODULE named markup://c:... found` when deploying `customerDesk` alone (`T22`)

- **Why:** `customerDesk.html` references `<c-desk-header>`, `<c-contact-search>`, `<c-customer-form>`, and `<c-customer-deals>`. Deploying `customerDesk` to a new org before its child components (and Apex controllers / message channel / labels / static resource) exist in the org fails with `No MODULE named markup://c:... found`.
- **Fix:** deploy the whole `force-app` directory at once:

  ```bash
  sf project deploy start --source-dir force-app --target-org desk-org
  ```
