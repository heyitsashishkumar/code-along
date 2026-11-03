# Troubleshooting · 10 · Parent-to-child, child-to-parent, and aggregates

Every error we hit while making **Apex from Zero #10**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Didn't understand relationship 'Contact' in FROM part of query call`

You write singular `FROM Contact` instead of plural `FROM Contacts` inside a parent-to-child subquery:

```apex
List<Account> shops = [
    SELECT Id, Name, (SELECT Id, LastName FROM Contact)
    FROM Account
    LIMIT 5
];
```

And compilation fails with:

```
Error (executeCompileFailure): Compilation failed at Line 1 column 23 with the error:
Didn't understand relationship 'Contact' in FROM part of query call. If you are attempting to use a custom relationship, be sure to append the '__r' after the custom relationship name. Please reference your WSDL or the describe call for the appropriate names.
```

- **Why:** A parent-to-child subquery queries the **child relationship name**, which is plural (`Contacts`, `Opportunities`, `Tasks`), not the singular object name.
- **Fix:** Change `FROM Contact` to `FROM Contacts`.

## `System.NullPointerException: Attempt to de-reference a null object` after `SUM(Amount)`

You run `SELECT SUM(Amount) total FROM Opportunity WHERE ...` when 0 rows match, and do math on `sum` without checking for `null`:

```
Error (executeRuntimeFailure): Execution failed at this code:
System.NullPointerException: Attempt to de-reference a null object
```

- **Why:** Even when 0 rows match the `WHERE` clause, `AggregateResult[] rows` still contains 1 row whose `rows[0].get('total')` is `null` (not `0`).
- **Fix:** Guard with `return sum != null ? sum : 0;`.

## `Illegal assignment from Object to Decimal`

You write `Decimal sum = rows[0].get('total');` without casting:

```
Error (executeCompileFailure): Compilation failed at Line 2 column 9 with the error:
Illegal assignment from Object to Decimal
```

- **Why:** `AggregateResult.get(alias)` returns the general `Object` type.
- **Fix:** Cast the value explicitly: `Decimal sum = (Decimal) rows[0].get('total');`.
