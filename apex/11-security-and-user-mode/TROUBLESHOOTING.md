# Troubleshooting · 11 · Security in Apex: `with sharing` and `WITH USER_MODE`

Every error we hit while making **Apex from Zero #11**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Unexpected token 'WITH'` when `WITH USER_MODE` is placed at the end of a SOQL query

You write `WITH USER_MODE` after `ORDER BY` or `LIMIT`:

```apex
List<Contact> contacts = [
    SELECT Id, Name
    FROM Contact
    ORDER BY Name
    LIMIT 50
    WITH USER_MODE
];
```

And compilation fails with:

```
Unexpected token 'WITH'
```

- **Why:** In SOQL clause order, `WITH USER_MODE` must come after `FROM` / `WHERE` (and `GROUP BY`), and **before** `ORDER BY` and `LIMIT`.
- **Fix:** Move `WITH USER_MODE` directly above `ORDER BY`:

  ```apex
  SELECT Id, Name
  FROM Contact
  WITH USER_MODE
  ORDER BY Name
  LIMIT 50
  ```

## `System.QueryException` / `System.SecurityException` on inaccessible fields under `WITH USER_MODE`

When a restricted user (such as a Standard User or Minimum Access user in an `@IsTest` test using `System.runAs`) lacks Object CRUD or Field-Level Security on a queried or inserted field:

```
Operation failed due to fields being inaccessible on Sobject Contact, checkErrorsOn...
```

- **Why:** Unlike default Apex system mode, `WITH USER_MODE` and `insert as user` (`AccessLevel.USER_MODE`) enforce the running user's object and field permissions and refuse to read or write restricted fields.
- **Fix:** Grant the needed field permission via a Permission Set, remove the restricted field from the query, or strip inaccessible fields with `Security.stripInaccessible(AccessType.READABLE, records)`.

## Omitting `with sharing` at the top of a class

- **Why:** Writing `public class MyController` without `with sharing` or `inherited sharing` runs the class in `without sharing` mode by default, exposing private rows to all users.
- **Fix:** Always declare `public with sharing class` (or `public inherited sharing class`).
