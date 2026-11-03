# Troubleshooting · 13 · Write `DealController` and throw readable errors

Every error we hit while making **Apex from Zero #13**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.LimitException: Can only throw this exception type from VisualForce or Aura context`

You try to test the negative `AuraHandledException` branch of `createQuickDeal` from anonymous Apex (`scripts/apex/hello.apex`):

```
System.LimitException: Can only throw this exception type from VisualForce or Aura context
```

- **Why:** Salesforce only allows throwing `AuraHandledException` inside an Aura/LWC request or inside an `@IsTest` unit test method, not from anonymous Apex.
- **Fix:** Test the negative `AuraHandledException` path inside an `@IsTest` method (as we do in `DealControllerTest.cls` in Video 15).

## `System.AssertException: Assertion Failed: Expected: ..., Actual: Script-thrown exception`

In an `@IsTest` unit test, you catch `AuraHandledException e` and assert `e.getMessage()`, and it fails with:

```
System.AssertException: Assertion Failed: Expected: Deal amount must be positive., Actual: Script-thrown exception
```

- **Why:** Calling `new AuraHandledException(msg)` sets the message sent to the LWC browser client, but leaves Apex's own `e.getMessage()` as the default string `'Script-thrown exception'` unless `setMessage(msg)` is also called.
- **Fix:** Always call `err.setMessage(msg);` before `throw err;`:

  ```apex
  AuraHandledException err = new AuraHandledException(
      'Account, deal name, and a positive amount are required.'
  );
  err.setMessage('Account, deal name, and a positive amount are required.');
  throw err;
  ```

## `System.LimitException: Too many DML statements: 1` on `createQuickDeal`

- **Why:** You wrote `@AuraEnabled(cacheable=true)` instead of plain `@AuraEnabled` above `createQuickDeal`.
- **Fix:** Remove `(cacheable=true)` from any method that inserts, updates, or deletes records.
