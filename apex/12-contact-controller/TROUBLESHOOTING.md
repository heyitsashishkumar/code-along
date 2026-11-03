# Troubleshooting · 12 · Write `ContactController` for LWC `@wire`

Every error we hit while making **Apex from Zero #12**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.LimitException: Too many DML statements: 1` inside `@AuraEnabled(cacheable=true)`

You put a DML statement (such as `insert new Account(Name = 'Log Call');`) inside a method marked `@AuraEnabled(cacheable=true)` and call it from the UI:

```
System.LimitException: Too many DML statements: 1
```

And the LWC wire error payload returns:

```json
[{"exceptionType":"System.LimitException","isUserDefinedException":false,"message":"Too many DML statements: 1","stackTrace":"Class.ContactController.getContacts: line 4, column 1"}]
```

- **Why:** For any method marked `@AuraEnabled(cacheable=true)`, Salesforce sets the DML statement governor limit to `0` (`Limits.getLimitDmlStatements() == 0`) so cached reads can never mutate database records.
- **Fix:** Keep `cacheable=true` methods 100% read-only. When a method needs to insert, update, or delete records (like `DealController.createQuickDeal` in Video 13), use `@AuraEnabled` without `cacheable=true` and call it imperatively.

## `Apex methods that are to be cached must be marked as @AuraEnabled(cacheable=true)`

You mark a method with plain `@AuraEnabled` (without `(cacheable=true)`) and wire it in LWC with `@wire`.

- **Why:** LWC's `@wire` service caches responses in Lightning Data Service and requires `(cacheable=true)` on the Apex method.
- **Fix:** Change `@AuraEnabled` to `@AuraEnabled(cacheable=true)`.

## `AuraEnabled methods must be named and static`

- **Why:** You left the word `static` off an `@AuraEnabled` method (`public List<Contact> getContacts()`). LWC invokes controller methods on the class without instantiating it.
- **Fix:** Declare every `@AuraEnabled` controller method as `public static`.
