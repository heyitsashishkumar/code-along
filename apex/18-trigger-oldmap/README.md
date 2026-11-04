# 18 · Trigger context variables, `Trigger.old`, and reparenting

The code for **Apex from Zero #18**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Stage 2 of **`OpportunityTrigger`**, adding `after delete, after undelete` to the trigger header and collecting `AccountId` from both `Trigger.new` (when `Trigger.new != null`) and `Trigger.old` (when `Trigger.old != null`) so reparenting a deal from one Account to another, deleting a deal, or undeleting a deal always updates every affected Account:

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

2. **Test reparenting, delete, and undelete in anonymous Apex:**

   ```apex
   Account sharma = new Account(Name = 'Sharma Test');
   Account gupta = new Account(Name = 'Gupta Test');
   insert new List<Account>{ sharma, gupta };
   Opportunity racks = new Opportunity(Name = 'Racks', AccountId = sharma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 50000);
   Opportunity packing = new Opportunity(Name = 'Packing', AccountId = sharma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 30000);
   insert new List<Opportunity>{ racks, packing };
   packing.AccountId = gupta.Id;
   update packing;
   System.debug('After reparent — Sharma: ' + [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue + ', Gupta: ' + [SELECT AnnualRevenue FROM Account WHERE Id = :gupta.Id].AnnualRevenue);
   delete racks;
   System.debug('After delete — Sharma: ' + [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue);
   undelete racks;
   System.debug('After undelete — Sharma: ' + [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue);
   delete new List<Account>{ sharma, gupta };
   ```

## What you should see

```
|USER_DEBUG|[9]|DEBUG|After reparent — Sharma: 50000.00, Gupta: 30000.00
|USER_DEBUG|[11]|DEBUG|After delete — Sharma: 0.00
|USER_DEBUG|[13]|DEBUG|After undelete — Sharma: 50000.00
```

**Your small task:** trace what `accountIds` contains when a deal's `AccountId` changes from `sharma.Id` to `null`, and confirm that `sharma.Id` is still collected from `Trigger.old`.
