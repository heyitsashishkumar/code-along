# 24 · Platform Events (`EventBus.publish`) and Custom Metadata Types (`getAll()`)

The code for **Apex from Zero #24**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`DeskEventService.cls`**, demonstrating zero-SOQL Custom Metadata threshold lookup with a `@TestVisible private static Decimal testThresholdOverride;` seam for unit tests and bulk high-value deal alert creation:

```apex
public with sharing class DeskEventService {
    public static final Decimal DEFAULT_HIGH_VALUE_THRESHOLD = 100000;

    @TestVisible
    private static Decimal testThresholdOverride;

    public static Decimal getHighValueThreshold() {
        if (testThresholdOverride != null) {
            return testThresholdOverride;
        }
        // When a Custom Metadata Type (e.g. Desk_Rule__mdt) is defined,
        // Desk_Rule__mdt.getInstance('Default')?.High_Value_Threshold__c
        // reads from the application cache using 0 SOQL queries!
        return DEFAULT_HIGH_VALUE_THRESHOLD;
    }

    public static List<Task> publishHighValueAlerts(List<Opportunity> deals) {
        List<Task> alerts = new List<Task>();
        if (deals == null || deals.isEmpty()) {
            return alerts;
        }
        Decimal threshold = getHighValueThreshold();
        for (Opportunity deal : deals) {
            if (
                deal.StageName == 'Closed Won' &&
                deal.Amount != null &&
                deal.Amount >= threshold &&
                deal.AccountId != null
            ) {
                alerts.add(
                    new Task(
                        WhatId = deal.AccountId,
                        Subject = 'High-value deal won: ' + deal.Name,
                        Description = 'Amount: INR ' + deal.Amount,
                        Status = 'Not Started',
                        Priority = 'High',
                        ActivityDate = Date.today()
                    )
                );
            }
        }
        if (!alerts.isEmpty()) {
            insert as user alerts;
        }
        return alerts;
    }
}
```

2. **`DeskEventServiceTest.cls`**, verifying with `Limits.getQueries()` that `getHighValueThreshold()` uses `0` SOQL queries, overriding `testThresholdOverride = 50000`, and testing `publishHighValueAlerts` at **100% coverage**.

## Deploy and run the tests

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run `DeskEventServiceTest` with code coverage:**

   ```bash
   sf apex run test --class-names DeskEventServiceTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

`DeskEventServiceTest` passes with `0` SOQL queries used for the threshold lookup and `100%` code coverage on `DeskEventService`.

**Your small task:** in `DeskEventServiceTest`, pass a deal with `StageName = 'Prospecting'` and `Amount = 500000` and assert that `publishHighValueAlerts` returns `0` alerts until the deal reaches `'Closed Won'`.
