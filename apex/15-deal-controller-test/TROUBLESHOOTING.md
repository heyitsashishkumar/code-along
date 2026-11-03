# Troubleshooting · 15 · Test data, users, and exceptions: `DealControllerTest`

Every error we hit while making **Apex from Zero #15**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.AssertException: Assertion Failed: Expected: ..., Actual: Script-thrown exception`

When asserting `e.getMessage()` inside `catch (AuraHandledException e)`:

```
System.AssertException: Assertion Failed: Expected: Deal amount must be positive., Actual: Script-thrown exception
```

- **Why:** `new AuraHandledException(msg)` only sets `e.getMessage()` in Apex when `err.setMessage(msg)` was called before `throw err;` in `DealController.cls`.
- **Fix:** In `DealController.createQuickDeal`, call `err.setMessage('Account, deal name, and a positive amount are required.');` before `throw err;`.

## Why do we need `Assert.fail('Expected AuraHandledException for invalid deal input');` inside `try`?

- **Why:** If someone accidentally deletes the `if (...)` validation in `DealController.createQuickDeal`, the call inside `try` won't throw `AuraHandledException`, the `catch` block will never run, and the test would silently pass by mistake!
- **Fix:** Always place `Assert.fail(...)` on the line right after the call that should throw an exception. If the exception is thrown as expected, execution jumps straight to `catch`; if it isn't thrown, `Assert.fail(...)` fails the test immediately.

## `System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [StageName, CloseDate]: [StageName, CloseDate]`

- **Why:** When creating test `Opportunity` records in `getDealsReturnsOnlyThatAccountsDeals`, every `Opportunity` requires `Name`, `StageName`, and `CloseDate`.
- **Fix:** Include `Name`, `StageName`, and `CloseDate` on every test `Opportunity` before calling `insert`.
