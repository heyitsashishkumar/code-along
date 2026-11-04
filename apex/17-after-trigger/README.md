# 17 · `after` triggers: updating related records (`OpportunityTrigger`)

The code for **Apex from Zero #17**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Stage 1 of **`OpportunityTrigger`**, which uses `if (Trigger.isBefore)` to fill default `CloseDate` and `StageName` on `Trigger.new`, and `if (Trigger.isAfter)` to sum `'Closed Won'` opportunities per parent account and update `Account.AnnualRevenue`:

**`force-app/main/default/triggers/OpportunityTrigger.trigger`**

```apex
trigger OpportunityTrigger on Opportunity (
    before insert,
    before update,
    after insert,
    after update
) {
    if (Trigger.isBefore) {
        for (Opportunity deal : Trigger.new) {
            if (deal.CloseDate == null) {
                deal.CloseDate = Date.today().addDays(30);
            }
            if (String.isBlank(deal.StageName)) {
                deal.StageName = 'Prospecting';
            }
        }
    }
    if (Trigger.isAfter) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity deal : Trigger.new) {
            if (deal.AccountId != null) {
                accountIds.add(deal.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return;
        }
        Map<Id, Decimal> totalsByAccount = new Map<Id, Decimal>();
        for (AggregateResult row : [
            SELECT AccountId, SUM(Amount) total
            FROM Opportunity
            WHERE AccountId IN :accountIds AND StageName = 'Closed Won'
            GROUP BY AccountId
        ]) {
            Decimal sum = (Decimal) row.get('total');
            totalsByAccount.put((Id) row.get('AccountId'), sum != null ? sum : 0);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Decimal total = totalsByAccount.containsKey(accountId)
                ? totalsByAccount.get(accountId)
                : 0;
            accountsToUpdate.add(new Account(Id = accountId, AnnualRevenue = total));
        }
        update accountsToUpdate;
    }
}
```

## Deploy and run it

1. **Deploy `OpportunityTrigger.trigger`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/triggers/OpportunityTrigger.trigger --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   Account sharma = new Account(Name = 'Sharma Rollup Check');
   insert sharma;
   insert new List<Opportunity>{
       new Opportunity(Name = 'Racks', AccountId = sharma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 50000),
       new Opportunity(Name = 'Packing', AccountId = sharma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 30000)
   };
   Account refreshed = [SELECT Name, AnnualRevenue FROM Account WHERE Id = :sharma.Id];
   System.debug(refreshed.Name + ' AnnualRevenue: ' + refreshed.AnnualRevenue);
   delete sharma;
   ```

## What you should see

```
|USER_DEBUG|[8]|DEBUG|Sharma Rollup Check AnnualRevenue: 80000.00
```

**Your small task:** before `delete sharma;`, update one of the two deals to `StageName = 'Closed Lost'` and verify that `AnnualRevenue` updates from `80000` to `50000`.
