# Troubleshooting · 08 · Partial saves and `try` / `catch` (`Database.insert`)

Every error we hit while making **Apex from Zero #8**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## Where did the `REQUIRED_FIELD_MISSING` error go when using `Database.insert(contacts, false)`?

When `allOrNone` is `false`, Apex does not throw `System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]`. Instead, failed rows have `sr.isSuccess() == false`, and their errors sit inside `sr.getErrors()`:

```apex
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        for (Database.Error err : sr.getErrors()) {
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
            System.debug('Fields: ' + err.getFields());
        }
    }
}
```

Which prints:

```
REQUIRED_FIELD_MISSING: Required fields are missing: [LastName]
Fields: (LastName)
```

## An orphan `Account` stays in the database after `catch (DmlException e)`

- **Why:** Uncaught exceptions roll the entire transaction back automatically. Once you catch `DmlException` with `try` / `catch`, you prevent the crash—so any DML that already succeeded before the error (like `insert shop;`) stays committed unless you roll it back.
- **Fix:** Call `Savepoint sp = Database.setSavepoint();` before the first DML statement, and call `Database.rollback(sp);` inside `catch (DmlException e)`.

## `System.LimitException: Too many DML statements: 151` when calling `Database.setSavepoint()` in a loop

```
System.LimitException: Too many DML statements: 151
```

- **Why:** Every call to `Database.setSavepoint()` and `Database.rollback(sp)` counts as 1 DML statement toward the 150-DML governor limit.
- **Fix:** Create a single `Savepoint` outside the loop before your transaction steps begin.
