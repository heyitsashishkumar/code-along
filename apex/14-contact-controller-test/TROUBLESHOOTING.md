# Troubleshooting · 14 · Write your first Apex unit test: `ContactControllerTest`

Every error we hit while making **Apex from Zero #14**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.AssertException: Assertion Failed: Expected: 3, Actual: 0` (tests return 0 rows even though your org has 16 contacts)

You call `ContactController.getContacts()` inside an `@IsTest` method without a `@TestSetup` method (or without inserting test `Contact` records), and get:

```
System.AssertException: Assertion Failed: Expected: 3, Actual: 0
```

- **Why:** By default, Apex unit tests run in an isolated database silo and **cannot see your org's real records**. That way a test passes reliably in any org, even a brand-new empty one.
- **Fix:** Create the records your test needs inside a `@TestSetup static void makeContacts()` method (or inside the `@IsTest` method itself). Any records inserted in `@TestSetup` are rolled back automatically after the test class finishes.

## `System.AssertException: Assertion Failed: Expected: Ravi Verma, Actual: Neha Gupta`

- **Why:** `ContactController.getContacts()` sorts contacts with `ORDER BY Name`. Between `'Neha Gupta'`, `'Pooja Verma'`, and `'Ravi Verma'`, `'Neha Gupta'` comes first alphabetically at index `0`.
- **Fix:** Check the `ORDER BY` clause of the method under test when asserting `contacts[0].Name`.

## Test method doesn't run when clicking `Run All Tests`

- **Why:** Every test method must have `@IsTest` on the line above `static void ...()`, and the class itself must also have `@IsTest` on the line above `private class ContactControllerTest`.
- **Fix:** Add `@IsTest` above the method, save, and deploy `ContactControllerTest.cls` before running tests.
