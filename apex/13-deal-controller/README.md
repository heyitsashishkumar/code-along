# 13 · Write `DealController` and throw readable errors

The code for **Apex from Zero #13**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`DealController`**, which pairs a cached read method `getDeals(Id accountId)` (called by **LWC from Zero #19 & #20**) with an imperative write method `createQuickDeal` that saves in user mode (`insert as user`) and throws clean UI messages with `AuraHandledException`:

**`force-app/main/default/classes/DealController.cls`**

```apex
public with sharing class DealController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getDeals(Id accountId) {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE AccountId = :accountId
            WITH USER_MODE
            ORDER BY CloseDate
        ];
    }

    @AuraEnabled
    public static Opportunity createQuickDeal(Id accountId, String dealName, Decimal amount) {
        if (accountId == null || String.isBlank(dealName) || amount == null || amount <= 0) {
            AuraHandledException err = new AuraHandledException(
                'Account, deal name, and a positive amount are required.'
            );
            err.setMessage('Account, deal name, and a positive amount are required.');
            throw err;
        }
        Opportunity deal = new Opportunity(
            AccountId = accountId,
            Name = dealName.trim(),
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = amount
        );
        insert as user deal;
        return deal;
    }
}
```

## Deploy and run it

1. **Deploy `DealController.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/DealController.cls --target-org desk-org
   ```

2. **Try the positive path in anonymous Apex:**

   ```apex
   Account shop = [SELECT Id, Name FROM Account WHERE Name = 'Verma Logistics' LIMIT 1];
   Opportunity created = DealController.createQuickDeal(shop.Id, 'Verma Express Crate Order', 85000);
   System.debug('Created deal: ' + created.Id);
   System.debug('Deals for Verma: ' + DealController.getDeals(shop.Id).size());
   delete created;
   ```

## What you should see

```
|USER_DEBUG|[3]|DEBUG|Created deal: 006...
|USER_DEBUG|[4]|DEBUG|Deals for Verma: 3
```

**Your small task:** add a check inside `createQuickDeal` that rejects `amount > 10000000` (one crore rupees) with `'Quick deals cannot exceed 1,00,00,000 rupees.'`, then revert back to the snapshot code before Video 15's unit tests.
