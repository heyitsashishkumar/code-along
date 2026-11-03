# 07 · sObjects and saving records with DML

The code for **Apex from Zero #7**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Part 1 of **`CustomerOnboarding`** (`onboardShopWithContacts`), which creates a new `Account` record in memory, saves it with `insert` to get its 18-character `Id`, collects linked `Contact` records in a `List<Contact>`, and saves them in a single bulk `insert contacts;` outside the loop:

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
}
```

## Deploy and run it

1. **Deploy `CustomerOnboarding.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/CustomerOnboarding.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   List<String> names = new List<String>{ 'Mehta', 'Kapoor' };
   Account shop = CustomerOnboarding.onboardShopWithContacts('Mehta Electricals', names);
   System.debug('Saved shop: ' + shop);
   ```

## What you should see

```
|USER_DEBUG|[3]|DEBUG|Saved shop: Account:{Name=Mehta Electricals, BillingCity=Noida, Id=001...}
```

**Your small task:** in `scripts/apex/hello.apex`, create a `new Opportunity(Name = 'Mehta Annual Supply', StageName = 'Prospecting', CloseDate = Date.today().addDays(30), Amount = 120000, AccountId = shop.Id)` and `insert` it.
