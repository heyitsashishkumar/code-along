# Troubleshooting · 09 · SOQL: querying your org's database

Every error we hit while making **Apex from Zero #9**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.QueryException: List has no rows for assignment to SObject`

You assign a `[SELECT ...]` query directly to a single `Account` variable instead of a `List<Account>`, and no rows match:

```apex
Account shop = [SELECT Id, Name FROM Account WHERE Name = 'No Such Shop'];
```

And the run fails with:

```
System.QueryException: List has no rows for assignment to SObject
```

- **Why:** Assigning a SOQL query to a single `SObject` variable requires **exactly 1 row**. When 0 rows match, Salesforce throws `System.QueryException: List has no rows for assignment to SObject`.
- **Fix:** Assign queries to a list (`List<Account> shops = [SELECT Id, Name FROM Account WHERE Name = 'No Such Shop' LIMIT 1];`) and check `if (!shops.isEmpty())`.

## `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field: Contact.Email`

You query a `Contact` without listing `Email` in `SELECT`, then read `c.Email`:

```apex
Contact c = [SELECT Id, Name FROM Contact LIMIT 1];
System.debug(c.Email);
```

And the run fails with:

```
System.SObjectException: SObject row was retrieved via SOQL without querying the requested field: Contact.Email
```

- **Why:** SOQL has no `SELECT *`. An `SObject` returned by SOQL only lets you read fields that were explicitly included in `SELECT`.
- **Fix:** Add `Email` to the `SELECT` clause: `SELECT Id, Name, Email FROM Contact LIMIT 1`.

## `System.LimitException: Too many SOQL queries: 101`

You put a `[SELECT ...]` query inside a `for` loop that runs more than 100 times:

```
Error (executeRuntimeFailure): Execution failed at this code:
System.LimitException: Too many SOQL queries: 101
```

- **Why:** Salesforce allows at most 100 synchronous SOQL queries in a single transaction.
- **Fix:** Move the query outside the loop and filter with `WHERE Id IN :ids`.
