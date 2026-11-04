# 19 · Bulkifying triggers: the 200-record rule and `addError`

The code for **Apex from Zero #19**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

The complete logic inside **`OpportunityTrigger`** (before extracting `OpportunityTriggerHandler.cls` in Video 20), adding field-level validation with `deal.Amount.addError('Deal amount cannot be negative.')` in `Trigger.isBefore` and verifying 200-record bulk execution in 1 SOQL query and 1 DML statement:

**`force-app/main/default/triggers/OpportunityTrigger.trigger`**

```apex
trigger OpportunityTrigger on Opportunity (
    before insert,
    before update,
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isBefore) {
        for (Opportunity deal : Trigger.new) {
            if (deal.Amount != null && deal.Amount < 0) {
                deal.Amount.addError('Deal amount cannot be negative.');
            }
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
        if (Trigger.new != null) {
            for (Opportunity deal : Trigger.new) {
                if (deal.AccountId != null) {
                    accountIds.add(deal.AccountId);
                }
            }
        }
        if (Trigger.old != null) {
            for (Opportunity deal : Trigger.old) {
                if (deal.AccountId != null) {
                    accountIds.add(deal.AccountId);
                }
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

2. **Test 200 deals in bulk and `addError` in anonymous Apex:**

   ```apex
   Account sharma = new Account(Name = 'Sharma Bulk 200');
   insert sharma;
   List<Opportunity> deals = new List<Opportunity>();
   for (Integer i = 1; i <= 200; i++) {
       deals.add(new Opportunity(Name = 'Bulk ' + i, AccountId = sharma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 1000));
   }
   insert deals;
   System.debug('200-deal AnnualRevenue: ' + [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue);
   Database.SaveResult bad = Database.insert(new Opportunity(Name = 'Negative', StageName = 'Prospecting', CloseDate = Date.today(), Amount = -500), false);
   System.debug('Negative deal blocked: ' + bad.getErrors()[0].getMessage());
   delete sharma;
   ```

## What you should see

```
|USER_DEBUG|[9]|DEBUG|200-deal AnnualRevenue: 200000.00
|USER_DEBUG|[11]|DEBUG|Negative deal blocked: Deal amount cannot be negative.
```

**Your small task:** compare `deal.addError('...')` (record-level banner at the top of the form) with `deal.Amount.addError('...')` (field-level error attached to `[Amount]`).
