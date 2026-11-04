# 20 · The Trigger Handler pattern and trigger tests

The code for **Apex from Zero #20** (completing Section 4: Triggers and the handler pattern). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`OpportunityTrigger.trigger`** slimmed down to a 15-line dispatcher following the **One Trigger Per Object** rule:

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
        OpportunityTriggerHandler.beforeSave(Trigger.new);
    }
    if (Trigger.isAfter) {
        OpportunityTriggerHandler.afterChange(Trigger.new, Trigger.old);
    }
}
```

2. **`OpportunityTriggerHandler.cls`** (`public with sharing class OpportunityTriggerHandler`) with `beforeSave(List<Opportunity> newDeals)` and `afterChange(List<Opportunity> newDeals, List<Opportunity> oldDeals)`.
3. **`OpportunityTriggerTest.cls`**, testing `ContactTrigger` defaults, 200-record bulk `Closed Won` rollups (`rollsUp200WonOpportunitiesInBulk`), reparenting + `delete` + `undelete` (`updatesBothAccountsOnReparentDeleteAndUndelete`), and walk-in defaults + negative amount `addError` validation (`defaultsMissingFieldsRejectsNegativeAmountAndIgnoresNoAccount`) at **100% coverage**.

## Deploy and run the full test suite

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run `OpportunityTriggerTest` with code coverage:**

   ```bash
   sf apex run test --class-names OpportunityTriggerTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

All 4 test methods in `OpportunityTriggerTest` pass with `100%` code coverage on `ContactTrigger`, `OpportunityTrigger`, and `OpportunityTriggerHandler`.

**Your small task:** extract `ContactTrigger`'s loop into a new `ContactTriggerHandler.beforeSave(List<Contact> newContacts)` method, call it from `ContactTrigger.trigger`, and re-run `OpportunityTriggerTest` to verify everything still passes at 100%.
