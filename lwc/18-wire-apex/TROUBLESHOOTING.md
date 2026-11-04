# Troubleshooting · 18 · Wire an Apex Method (`@AuraEnabled(cacheable=true)` and `@salesforce/apex`)

These are all the errors and traps we hit while making **LWC from Zero #18**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `Apex methods that are to be cached must be marked as @AuraEnabled(cacheable=true)` (`T13`)

If `ContactController.findContacts` is annotated with `@AuraEnabled` without `(cacheable=true)`:

```apex
// Broken for @wire:
@AuraEnabled
public static List<Contact> findContacts(String searchKey) { ... }
```

the deploy succeeds, no contacts appear on the page, and `<c-error-panel errors={contacts.error}>` displays:

```
Apex methods that are to be cached must be marked as @AuraEnabled(cacheable=true)
```

- **Why:** `@wire` caches responses in Lightning Data Service and refuses to call any Apex method unless it is marked `@AuraEnabled(cacheable=true)`. (Notice too that if a component doesn't render `contacts.error`, the card stays completely blank with no message!)
- **Fix:** change `@AuraEnabled` to `@AuraEnabled(cacheable=true)` in `ContactController.cls` and redeploy.

## Typing in the search box returns no matches (or `null` parameter in Apex)

If you write `{ key: '$searchKey' }` inside `@wire(findContacts, ...)` when the Apex parameter is declared as `findContacts(String searchKey)`:

- **Why:** `@wire` matches the keys of the JavaScript configuration object to the Apex method's parameter names **case-sensitively**. Because `key` doesn't match `searchKey`, Salesforce passes `searchKey = null` into Apex.
- **Fix:** make the object key match the Apex parameter name letter for letter:

  ```js
  @wire(findContacts, { searchKey: '$searchKey' })
  contacts;
  ```

## Nothing renders when looping with `for:each={contacts}`

- **Why:** when you wire a property (`@wire(...) contacts;`), LWC assigns an object `{ data, error }` to `this.contacts`. The array returned by Apex is inside `this.contacts.data`.
- **Fix:** guard with `<template lwc:if={contacts.data}>` and iterate over `for:each={contacts.data}`.

## `System.LimitException: Too many DML statements: 1`

- **Why:** Salesforce sets the DML governor limit to `0` inside any `@AuraEnabled(cacheable=true)` method so cached reads can never modify database rows.
- **Fix:** keep `@AuraEnabled(cacheable=true)` methods read-only. For methods that insert, update or delete records, use `@AuraEnabled` without `cacheable=true` and call them imperatively (Video 19).
