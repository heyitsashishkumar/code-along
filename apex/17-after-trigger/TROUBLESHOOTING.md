# Troubleshooting · 17 · `after` triggers: updating related records (`OpportunityTrigger`)

Every error we hit while making **Apex from Zero #17**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.FinalException: Record is read-only` (`E10`) when `if (Trigger.isBefore)` is missing

You list both `before insert` and `after insert` in the trigger header, and mutate `deal.StageName = 'Prospecting';` outside `if (Trigger.isBefore)`:

```
System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, OpportunityTrigger: execution of AfterInsert

caused by: System.FinalException: Record is read-only
```

- **Why:** When a trigger header includes both `before` and `after` events, Salesforce executes the trigger body **twice** per save—once with `Trigger.isBefore == true`, and a second time with `Trigger.isAfter == true`. Mutating `Trigger.new` during the `after` pass throws `System.FinalException: Record is read-only`.
- **Fix:** Always wrap same-record assignments inside `if (Trigger.isBefore)` and related-record queries/DML inside `if (Trigger.isAfter)`.

## `Account.AnnualRevenue` stays stuck at its old number when the last `'Closed Won'` deal becomes `'Closed Lost'`

- **Why:** When an Account has 0 `'Closed Won'` deals left, `SELECT AccountId, SUM(Amount) total ... GROUP BY AccountId` returns **zero rows** for that `AccountId`. If you only loop over `totalsByAccount.keySet()`, that Account is skipped.
- **Fix:** Loop over `for (Id accountId : accountIds)` and default missing map keys to `0`:

  ```apex
  Decimal total = totalsByAccount.containsKey(accountId)
      ? totalsByAccount.get(accountId)
      : 0;
  ```

## `Illegal assignment from Object to Decimal` (`E20`)

```
Error (executeCompileFailure): Compilation failed at Line 2 column 9 with the error:
Illegal assignment from Object to Decimal
```

- **Why:** `row.get('total')` on an `AggregateResult` returns `Object`.
- **Fix:** Cast explicitly: `Decimal sum = (Decimal) row.get('total');`.
