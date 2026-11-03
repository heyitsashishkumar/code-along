# Troubleshooting · 09 · Put One Component Inside Another (Composition)

These are all the errors we hit while making **LWC from Zero #9**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `LWC1058: Invalid HTML syntax: non-void-html-element-start-tag-with-trailing-solidus`

Writing a self-closing custom tag like `<c-customer-card/>` in `customerDesk.html` underlines the tag in red in VS Code and fails to deploy with:

```
LWC1058: Invalid HTML syntax: non-void-html-element-start-tag-with-trailing-solidus. For more information, please visit https://html.spec.whatwg.org/multipage/parsing.html#parse-error-non-void-html-element-start-tag-with-trailing-solidus (2:5)
```

- **Why:** LWC templates follow strict HTML rules: custom elements and `lightning-*` components are non-void elements and cannot self-close with `/>`.
- **Fix:** always write both an opening and a closing tag:

  ```html
  <c-customer-card></c-customer-card>
  ```

## `LWC1010: Failed to resolve entry for module "customerCard"`

Writing the tag with a capital letter (`<c-customerCard></c-customerCard>`) instead of kebab-case (`<c-customer-card></c-customer-card>`) fails to deploy with two error rows:

```
Compilation Failure
/c/customercard/customerCard.js:0,0 : LWC1010: Failed to resolve entry for module "customerCard".
```

- **Why:** HTML lowercases tag names (`<c-customerCard>` becomes `<c-customercard>`), so LWC looks for a component folder named `customercard` instead of `customerCard`. Every capital letter after the first must be written as `-` followed by the lowercase letter.
- **Fix:** change `<c-customerCard></c-customerCard>` to `<c-customer-card></c-customer-card>`.

## `No MODULE named markup://c:customerGreeting found : [markup://c:customerDesk]`

If you right-click only `customerDesk` and deploy it to an org where `customerGreeting` (or `customerCard`) hasn't been deployed yet, the deploy fails with:

```
No MODULE named markup://c:customerGreeting found : [markup://c:customerDesk]
```

- **Why:** Salesforce compiles `customerDesk` against the child components already in the org or in the same deployment batch.
- **Fix:** deploy the whole `force-app` folder (`sf project deploy start --source-dir force-app --target-org desk-org` or right-click `force-app/main/default/lwc` and choose **SFDX: Deploy This Source to Org**) so the child and parent deploy together.
