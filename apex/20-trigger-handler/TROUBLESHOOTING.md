# Troubleshooting · 20 · The Trigger Handler pattern and trigger tests

Every error we hit while making **Apex from Zero #20**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Variable does not exist: OpportunityTriggerHandler` when deploying `OpportunityTrigger.trigger` alone

- **Why:** If you deploy `OpportunityTrigger.trigger` before `OpportunityTriggerHandler.cls` has been deployed to the org, the compiler cannot find `OpportunityTriggerHandler`.
- **Fix:** Deploy `OpportunityTriggerHandler.cls` first, or deploy both folders together with `sf project deploy start --source-dir force-app --target-org desk-org`.

## `System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Deal amount cannot be negative.: [Amount]` (`E24`)

```
System.DmlException: Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Deal amount cannot be negative.: [Amount]
```

- **Why:** In `OpportunityTriggerTest.defaultsMissingFieldsRejectsNegativeAmountAndIgnoresNoAccount`, inserting a negative amount throws `FIELD_CUSTOM_VALIDATION_EXCEPTION` if called with plain `insert`. Using `Database.insert(badDeal, false)` lets the test assert `Assert.isFalse(badResult.isSuccess())` and `Assert.areEqual('Deal amount cannot be negative.', badResult.getErrors()[0].getMessage())` cleanly.

## `CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY ... maximum trigger depth exceeded` (Trigger recursion trap)

- **Why:** Our `OpportunityTriggerHandler.afterChange` updates `Account` records, which does not re-fire `OpportunityTrigger`. However, if an `after` trigger on `Opportunity` ever runs `update` on `Opportunity` itself, the trigger will re-fire itself up to depth 16 and fail with `maximum trigger depth exceeded`.
- **Fix:** Modify fields on the same object inside `before` triggers (0 extra DML), or check that the relevant field actually changed via `Trigger.oldMap` before running DML.
