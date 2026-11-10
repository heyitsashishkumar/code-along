# 22 · Async Apex part 2: `Database.Batchable` and `Schedulable`

The code for **Apex from Zero #22**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`StaleDealBatch.cls`**, implementing `Database.Batchable<SObject>, Database.Stateful` to scan open deals past their `CloseDate` in chunks and stamp `'Stale deal: past close date'` while preserving `public Integer dealsFlagged = 0;` across chunks:

```apex
public with sharing class StaleDealBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Integer dealsFlagged = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE IsClosed = false AND CloseDate < TODAY
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        List<Opportunity> toUpdate = new List<Opportunity>();
        for (Opportunity deal : scope) {
            deal.Description = 'Stale deal: past close date';
            toUpdate.add(deal);
            this.dealsFlagged++;
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('StaleDealBatch finished. Flagged deals: ' + this.dealsFlagged);
    }
}
```

2. **`StaleDealScheduler.cls`**, implementing `Schedulable` with `CRON_NIGHTLY_2AM = '0 0 2 * * ?'` to launch `Database.executeBatch(new StaleDealBatch(), 200)`.
3. **`StaleDealBatchTest.cls`**, testing both the batch execution and `System.schedule` at **100% coverage**.

## Deploy and run the tests

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run `StaleDealBatchTest` with code coverage:**

   ```bash
   sf apex run test --class-names StaleDealBatchTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

Both test methods in `StaleDealBatchTest` pass with `100%` code coverage on `StaleDealBatch` and `StaleDealScheduler`.

**Your small task:** write a cron expression for every Monday morning at 9:00 a.m. (`'0 0 9 ? * MON'`) and test scheduling it in a unit test or anonymous Apex.
