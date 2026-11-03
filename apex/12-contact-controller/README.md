# 12 · Write `ContactController` for LWC `@wire`

The code for **Apex from Zero #12**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`ContactController`**, the exact Apex class that **LWC from Zero #18** imports and wires with `@wire(findContacts, { searchKey: '$searchKey' })`:

**`force-app/main/default/classes/ContactController.cls`**

```apex
public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WHERE Name LIKE :key
            WITH USER_MODE
            ORDER BY Name
            LIMIT 10
        ];
    }
}
```

## Deploy and run it

1. **Deploy `ContactController.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/ContactController.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   System.debug('All contacts: ' + ContactController.getContacts().size());
   for (Contact c : ContactController.findContacts('Verma')) {
       System.debug(c.Name + ' · ' + c.Title + ' · ' + c.Phone);
   }
   ```

## What you should see

```
|USER_DEBUG|[1]|DEBUG|All contacts: 16
|USER_DEBUG|[3]|DEBUG|Pooja Verma · Operations Manager · +91 90000 00110
|USER_DEBUG|[3]|DEBUG|Ravi Verma · Procurement Head · +91 90000 00109
```

**Your small task:** if you're also following **LWC from Zero**, check Video 18 (`lwc/18-wire-apex`)—your `ContactController.getContacts` and `ContactController.findContacts` methods slot right under `@salesforce/apex/ContactController.findContacts`.
