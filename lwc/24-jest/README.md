# 24 · Test Your Component (`@salesforce/sfdx-lwc-jest`)

The code for **LWC from Zero #24**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Real Jest unit tests that run in milliseconds on your laptop (no org needed!) for three components of escalating complexity:
1. **`contactTile/__tests__/contactTile.test.js`**: mounts `<c-contact-tile>`, sets `element.contact = CONTACT`, asserts `.shadowRoot` DOM text (`Ravi Verma`, `Owner`, `RV`), clicks `.tile`, and asserts the `select` `CustomEvent` (`detail: '1'`, `bubbles: true`).
2. **`contactSearch/__tests__/contactSearch.test.js`**: mocks `@salesforce/apex/ContactController.findContacts` with `createApexTestWireAdapter`, tests the 300 ms debounce using `jest.useFakeTimers()` and `jest.advanceTimersByTime(300)`, emits mock contacts with `findContacts.emit(CONTACTS)`, and verifies `publish` on `lightning/messageService`.
3. **`customerDeals/__tests__/customerDeals.test.js`**: mocks `getDeals`, `updateRecord`, and `refreshApex`, dispatches a `save` event on `<lightning-datatable>` with `draftValues`, and verifies that `updateRecord`, the toast event, `refreshApex`, and `table.draftValues = []` all run.

The key idea: **mount the component with `createElement`, flush microtasks with `await Promise.resolve()`, and mock external dependencies (`@salesforce/apex`, `lightning/uiRecordApi`) so each test checks your component's own DOM and events in isolation.**

## Install dependencies and run the tests

1. Install npm packages once in this folder (if you're on Node 20 with npm 10.8, include `--legacy-peer-deps` — see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) `B02`):

   ```bash
   npm install --legacy-peer-deps
   ```

2. Run our three Jest test suites:

   ```bash
   npx jest contactTile contactSearch customerDeals
   ```

## What you should see

```
 PASS  force-app/main/default/lwc/contactTile/__tests__/contactTile.test.js
 PASS  force-app/main/default/lwc/contactSearch/__tests__/contactSearch.test.js
 PASS  force-app/main/default/lwc/customerDeals/__tests__/customerDeals.test.js

Test Suites: 3 passed, 3 total
Tests:       11 passed, 11 total
```

*(What if you run `npm test` across all 18 component folders right now? You'll see `Test Suites: 3 failed, 15 passed, 18 total` because the CLI's auto-generated skeleton tests in `noteModal`, `customerSummary`, and `ldsUtils` hit `B05` and `B06` — see [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for the exact messages and fixes!)*

**Your small task:** fix `ldsUtils/__tests__/ldsUtils.test.js` by importing `{ reduceErrors } from 'c/ldsUtils'` and asserting `expect(reduceErrors({ body: { message: 'Boom' } })).toEqual(['Boom'])`.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7`, Node `20.20.2`, and the Salesforce Extension Pack `68.4.0`, at API version `68.0`.
