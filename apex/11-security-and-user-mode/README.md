# 11 · Security in Apex: `with sharing` and `WITH USER_MODE`

The code for **Apex from Zero #11**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

A complete security audit of our Sharma Traders backend classes (**`CustomerQueries`** and **`CustomerOnboarding`**), combining:

1. **Class-level record sharing** (`public with sharing class`): enforces which rows the logged-in user can see.
2. **SOQL user mode** (`WITH USER_MODE` after `WHERE` and before `ORDER BY` / `LIMIT`): enforces Object CRUD, Field-Level Security (FLS), and row sharing in every query.
3. **DML user mode** (`insert as user record;` and `Database.insert(records, false, AccessLevel.USER_MODE)`): enforces Object CRUD, FLS, and sharing when saving records.

## Deploy and run it

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Test user-mode queries and DML in anonymous Apex:**

   ```apex
   List<Contact> noida = CustomerQueries.getContactsByCity('Noida');
   System.debug('User-mode contacts: ' + noida.size());
   Account testShop = new Account(Name = 'User Mode Traders', BillingCity = 'Noida');
   insert as user testShop;
   System.debug('Inserted in user mode: ' + testShop.Id);
   delete as user testShop;
   ```

## What you should see

```
|USER_DEBUG|[2]|DEBUG|User-mode contacts: 4
|USER_DEBUG|[5]|DEBUG|Inserted in user mode: 001...
```

**Your small task:** check every `.cls` file in `force-app/main/default/classes/` and confirm that every single one starts with `public with sharing class`.
