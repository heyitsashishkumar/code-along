# Troubleshooting · 06 · Sets and Maps: fast lookup by ID

Every error we hit while making **Apex from Zero #6**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.NullPointerException: Attempt to de-reference a null object` on `directory.get(unknownId).Name`

You read a field directly on the result of `directory.get(...)` when the key is not in the `Map`:

```apex
Map<Id, Account> directory = new Map<Id, Account>();
Id unknownId = '001000000000099AAA';
System.debug(directory.get(unknownId).Name);
```

And the run fails with:

```
System.NullPointerException: Attempt to de-reference a null object
```

- **Why:** `directory.get(key)` returns `null` when `key` is not in the map. Reading `.Name` on `null` throws `NullPointerException`.
- **Fix:** Check `directory.containsKey(accountId)` before reading `.Name`, or use safe navigation `directory.get(accountId)?.Name`.

## `System.ListException: Row with null Id at index: 0`

You pass a `List<Account>` into `new Map<Id, Account>(accounts)` when one of the records has not been saved to the database yet (`Id == null`):

```
System.ListException: Row with null Id at index: 0
```

- **Why:** `new Map<Id, SObject>(list)` uses each record's `Id` as the map key, so every record in the list must already have a non-null `Id`.
- **Fix:** Only pass records that have an `Id` (after `insert` or a SOQL query) into `new Map<Id, Account>(accounts)`.

## `Expression must be a list type: Set<Id>`

You try to read an item from a `Set<Id>` by index with square brackets (`Id first = accountIds[0];`) and compilation fails with:

```
Error (executeCompileFailure): Compilation failed at Line 2 column 12 with the error:
Expression must be a list type: Set<Id>
```

- **Why:** A `Set` is an unordered collection of unique values, so it has no slot positions or index numbers.
- **Fix:** Check membership with `accountIds.contains(id)`, or loop over the set with `for (Id accId : accountIds)`.
