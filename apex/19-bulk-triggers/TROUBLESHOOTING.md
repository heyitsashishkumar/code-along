# Troubleshooting · 19 · Bulkifying triggers: the 200-record rule and `addError`

Every error we hit while making **Apex from Zero #19**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Deal amount cannot be negative.: [Amount]` (`E24`)

When you run plain `insert` on an `Opportunity` with a negative `Amount` (`Amount = -500`), `deal.Amount.addError('Deal amount cannot be negative.')` blocks the save with:

```
System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Deal amount cannot be negative.: [Amount]
```

- **Why:** `deal.Amount.addError(...)` marks the record invalid during `before insert` / `before update` and attaches the error to the `Amount` field (`[Amount]`).
- **Fix:** Pass a non-negative `Amount`, or use `Database.insert(records, false)` when importing a batch where valid rows should still save and invalid rows should report their error in `SaveResult.getErrors()`.

## `System.LimitException: Too many SOQL queries: 101` (`E18`)

```
Error (executeRuntimeFailure): Execution failed at this code:
System.LimitException: Too many SOQL queries: 101
```

- **Why:** Putting a `[SELECT ...]` query inside `for (Opportunity deal : Trigger.new)` runs one query per record and crashes on record 101 when a batch of 200 records is inserted or updated.
- **Fix:** Collect all `AccountId` values into a `Set<Id> accountIds` first, and run **one** query outside the loop with `WHERE AccountId IN :accountIds`.

## `System.LimitException: Too many DML statements: 151` (`E17`)

```
System.LimitException: Too many DML statements: 151
```

- **Why:** Putting `update account;` inside a loop uses one DML statement per record and crashes on record 151 in a 200-record trigger batch.
- **Fix:** Add each `Account` to `List<Account> accountsToUpdate` inside the loop, and run a single `update accountsToUpdate;` after the loop ends.
