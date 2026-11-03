# 08 · Partial saves and `try` / `catch` (`Database.insert`)

The code for **Apex from Zero #8**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

The completed **`CustomerOnboarding`** class, adding `insertContactsAllowingPartialSuccess` (`Database.insert(contacts, false)` + `Database.SaveResult`) and `onboardWithRollbackOnError` (`Savepoint`, `try` / `catch (DmlException e)`, and `Database.rollback(sp)`):

**`force-app/main/default/classes/CustomerOnboarding.cls`**

```apex
public with sharing class CustomerOnboarding {
    public static Account onboardShopWithContacts(String shopName, List<String> contactLastNames) {
        Account shop = new Account(Name = shopName, BillingCity = 'Noida');
        insert shop;

        List<Contact> contacts = new List<Contact>();
        for (String lastName : contactLastNames) {
            contacts.add(
                new Contact(
                    LastName = lastName,
                    AccountId = shop.Id,
                    MailingCity = 'Noida'
                )
            );
        }
        insert contacts;
        return shop;
    }

    public static Integer insertContactsAllowingPartialSuccess(List<Contact> contacts) {
        Database.SaveResult[] results = Database.insert(contacts, false);
        Integer succeeded = 0;
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                succeeded++;
            }
        }
        return succeeded;
    }

    public static Boolean onboardWithRollbackOnError(String shopName, Contact primaryContact) {
        Savepoint sp = Database.setSavepoint();
        try {
            Account shop = new Account(Name = shopName);
            insert shop;
            primaryContact.AccountId = shop.Id;
            insert primaryContact;
            return true;
        } catch (DmlException e) {
            Database.rollback(sp);
            return false;
        }
    }
}
```

## Deploy and run it

1. **Deploy `CustomerOnboarding.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/CustomerOnboarding.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   List<Contact> batch = new List<Contact>{
       new Contact(LastName = 'Verma'),
       new Contact(FirstName = 'Broken'),
       new Contact(LastName = 'Gupta')
   };
   Integer saved = CustomerOnboarding.insertContactsAllowingPartialSuccess(batch);
   System.debug('Partial saved: ' + saved);
   Boolean ok = CustomerOnboarding.onboardWithRollbackOnError(
       'Ghost Shop', new Contact(FirstName = 'NoLastName')
   );
   System.debug('Rollback onboard ok? ' + ok);
   System.debug('Ghost Shop rows: ' + [SELECT COUNT() FROM Account WHERE Name = 'Ghost Shop']);
   ```

## What you should see

```
|USER_DEBUG|[7]|DEBUG|Partial saved: 2
|USER_DEBUG|[11]|DEBUG|Rollback onboard ok? false
|USER_DEBUG|[12]|DEBUG|Ghost Shop rows: 0
```

**Your small task:** in `insertContactsAllowingPartialSuccess`, add an `else` branch after `if (sr.isSuccess())` that loops through `for (Database.Error err : sr.getErrors())` and logs `err.getStatusCode() + ': ' + err.getMessage()`.
