# Troubleshooting · 18 · Trigger context variables, `Trigger.old`, and reparenting

Every error we hit while making **Apex from Zero #18**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.NullPointerException: Attempt to de-reference a null object` (`E04`) on `Trigger.new` during `delete` or `Trigger.old` / `Trigger.oldMap` during `insert`

```
System.NullPointerException: Attempt to de-reference a null object
```

- **Why:**
  - On `insert` and `undelete`, there was no previous version of the record, so `Trigger.old` and `Trigger.oldMap` are `null`.
  - On `delete`, there is no new version of the record, so `Trigger.new` and `Trigger.newMap` are `null`.
  Looping over `Trigger.new` on `delete` or calling `Trigger.oldMap.get(deal.Id)` on `insert` throws `System.NullPointerException`.
- **Fix:** Always guard with `if (Trigger.new != null)` and `if (Trigger.old != null)` (or check `Trigger.isUpdate` before using `Trigger.oldMap`).

## Old parent `Account.AnnualRevenue` stays stale when an `Opportunity` is reparented to a different `Account`

- **Why:** When `packing.AccountId` changes from `sharma.Id` to `gupta.Id`, `Trigger.new` only holds `gupta.Id`. The previous parent `sharma.Id` is only in `Trigger.old`.
- **Fix:** Collect `AccountId` into `Set<Id> accountIds` from **both** `Trigger.new` and `Trigger.old`.
