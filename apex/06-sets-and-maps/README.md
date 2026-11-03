# 06 · Sets and Maps: fast lookup by ID

The code for **Apex from Zero #6**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`AccountDirectory`**, which deduplicates company IDs from a contact list using `Set<Id>`, builds an ID-to-Account lookup table in one step with `new Map<Id, Account>(accounts)`, and safely resolves any company's name by ID:

**`force-app/main/default/classes/AccountDirectory.cls`**

```apex
public with sharing class AccountDirectory {
    public static Set<Id> collectAccountIds(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        if (contacts == null) {
            return accountIds;
        }
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        return accountIds;
    }

    public static Map<Id, Account> buildDirectory(List<Account> accounts) {
        if (accounts == null) {
            return new Map<Id, Account>();
        }
        return new Map<Id, Account>(accounts);
    }

    public static String findAccountName(Map<Id, Account> directory, Id accountId) {
        if (directory != null && accountId != null && directory.containsKey(accountId)) {
            return directory.get(accountId).Name;
        }
        return 'Unassigned';
    }
}
```

## Deploy and run it

1. **Deploy `AccountDirectory.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/AccountDirectory.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   Id vermaId = '001000000000001AAA';
   Id guptaId = '001000000000002AAA';
   List<Contact> contacts = new List<Contact>{
       new Contact(FirstName = 'Ravi', LastName = 'Verma', AccountId = vermaId),
       new Contact(FirstName = 'Pooja', LastName = 'Verma', AccountId = vermaId),
       new Contact(FirstName = 'Neha', LastName = 'Gupta', AccountId = guptaId)
   };
   List<Account> accounts = new List<Account>{
       new Account(Id = vermaId, Name = 'Verma Logistics'),
       new Account(Id = guptaId, Name = 'Gupta Stores')
   };
   Set<Id> ids = AccountDirectory.collectAccountIds(contacts);
   System.debug('Unique company IDs: ' + ids.size());
   Map<Id, Account> directory = AccountDirectory.buildDirectory(accounts);
   System.debug('Verma: ' + AccountDirectory.findAccountName(directory, vermaId));
   System.debug('Null ID: ' + AccountDirectory.findAccountName(directory, null));
   ```

## What you should see

```
|USER_DEBUG|[12]|DEBUG|Unique company IDs: 2
|USER_DEBUG|[14]|DEBUG|Verma: Verma Logistics
|USER_DEBUG|[15]|DEBUG|Null ID: Unassigned
```

**Your small task:** add a method `putAccount(Map<Id, Account> directory, Account shop)` to `AccountDirectory` that checks `directory != null && shop != null && shop.Id != null` and calls `directory.put(shop.Id, shop)`.
