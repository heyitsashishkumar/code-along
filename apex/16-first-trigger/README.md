# 16 · Your first Apex trigger: `before` vs `after`

The code for **Apex from Zero #16**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`ContactTrigger`**, our first Apex trigger on `Contact`, which runs on `before insert, before update`, loops over `Trigger.new`, and fills in default `LeadSource = 'Web'` and `MailingCountry = 'India'` in memory before the database write—using zero extra DML statements:

**`force-app/main/default/triggers/ContactTrigger.trigger`**

```apex
trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact customer : Trigger.new) {
        if (String.isBlank(customer.LeadSource)) {
            customer.LeadSource = 'Web';
        }
        if (String.isBlank(customer.MailingCountry)) {
            customer.MailingCountry = 'India';
        }
    }
}
```

## Deploy and run it

1. **Deploy `ContactTrigger.trigger`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/triggers/ContactTrigger.trigger --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   Contact c = new Contact(FirstName = 'Kiran', LastName = 'Rao');
   insert c;
   Contact saved = [
       SELECT Id, FirstName, LastName, LeadSource, MailingCountry
       FROM Contact
       WHERE Id = :c.Id
   ];
   System.debug('Saved contact: ' + saved);
   delete c;
   ```

## What you should see

```
|USER_DEBUG|[8]|DEBUG|Saved contact: Contact:{Id=003..., FirstName=Kiran, LastName=Rao, LeadSource=Web, MailingCountry=India}
```

**Your small task:** write a quick `@IsTest` method that inserts `new Contact(FirstName = 'Ravi', LastName = 'Verma')` and asserts `Assert.areEqual('Web', saved.LeadSource);` and `Assert.areEqual('India', saved.MailingCountry);`.
