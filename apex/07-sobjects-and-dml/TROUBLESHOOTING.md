# Troubleshooting · 07 · sObjects and saving records with DML

Every error we hit while making **Apex from Zero #7**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]`

You try to insert a `Contact` without setting `LastName`:

```apex
Contact c = new Contact(FirstName = 'Ravi');
insert c;
```

And the run fails with:

```
System.DmlException: Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]
```

- **Why:** Every standard `Contact` requires `LastName` (just as `Account` requires `Name`, and `Opportunity` requires `Name`, `StageName`, and `CloseDate`).
- **Fix:** Always populate the required fields before calling `insert`.

## `System.DmlException: Update failed. First exception on row 0; first error: MISSING_ARGUMENT, Id not specified in an update call: []`

You call `update shop;` on an `Account` created in memory that has never been inserted (`shop.Id == null`):

```
System.DmlException: Update failed. First exception on row 0; first error: MISSING_ARGUMENT, Id not specified in an update call: []
```

- **Why:** `update` modifies an existing database row identified by its `Id`.
- **Fix:** Call `insert` first to save a new record (or use `upsert` when a list may contain both new and existing records).

## `System.DmlException: Insert failed. First exception on row 0 with id 001C300000ugMotIAE; first error: INVALID_FIELD_FOR_INSERT_UPDATE, cannot specify Id in an insert call: [Id]`

You call `insert shop;` a second time on a record that was already inserted:

```
System.DmlException: Insert failed. First exception on row 0 with id 001C300000ugMotIAE; first error: INVALID_FIELD_FOR_INSERT_UPDATE, cannot specify Id in an insert call: [Id]
```

- **Why:** Once `insert shop;` runs, Salesforce stamps the new 18-character `Id` onto `shop.Id`. `insert` refuses any record that already has an `Id`.
- **Fix:** Use `update shop;` to save changes to a record that already has an `Id`.

## `System.LimitException: Too many DML statements: 151`

- **Why:** Putting `insert c;` inside a `for` loop uses one DML statement per record and hits Salesforce's 150-DML governor limit on the 151st record.
- **Fix:** Add records to a `List<Contact> contacts` inside the loop, and run a single `insert contacts;` after the loop ends.
