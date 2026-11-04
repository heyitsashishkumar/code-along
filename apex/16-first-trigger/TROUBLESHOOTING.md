# Troubleshooting · 16 · Your first Apex trigger: `before` vs `after`

Every error we hit while making **Apex from Zero #16**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.FinalException: Record is read-only` (`E10`)

You declare `trigger ContactTrigger on Contact (after insert)` instead of `before insert`, try to set `customer.LeadSource = 'Web';` on `Trigger.new`, and `insert new Contact(FirstName = 'Ravi', LastName = 'Verma');` fails with:

```
System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, ContactTrigger: execution of AfterInsert

caused by: System.FinalException: Record is read-only

Trigger.ContactTrigger: line 3, column 1: []
```

- **Why:** In `after insert` and `after update`, the record has already been written to the database, so `Trigger.new` is locked read-only (`System.FinalException: Record is read-only`).
- **Fix:** Use `before insert, before update` whenever you set or validate fields on the record being saved (`Trigger.new`).

## `System.SObjectException: DML statement cannot operate on trigger.new or trigger.old`

You call `update Trigger.new;` (or `update customer;`) inside `ContactTrigger`:

```
System.SObjectException: DML statement cannot operate on trigger.new or trigger.old
```

- **Why:** Salesforce is already in the middle of saving `Trigger.new`.
- **Fix:** Remove `update Trigger.new;`—any field you assign on `Trigger.new` inside a `before` trigger is saved automatically as part of the current save with zero extra DML.

## `customer.Id` is `null` inside `before insert`

- **Why:** Salesforce generates the 18-character `Id` during the database write step between `before insert` and `after insert`.
- **Fix:** If your logic needs the new record's `Id` (for example, to query or update a related record), use an `after` trigger (Video 17).
