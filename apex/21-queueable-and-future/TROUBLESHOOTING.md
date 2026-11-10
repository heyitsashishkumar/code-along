# Troubleshooting · 21 · Async Apex part 1: `Queueable` and `@future`

Every error we hit while making **Apex from Zero #21**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Future methods do not support parameter type of List<Contact>`

- **Why:** `@future` methods only accept primitive data types (such as `Id`, `String`, `Integer`) or collections of primitives (`Set<Id>`, `List<String>`). Passing sObjects like `List<Contact>` is forbidden because the record could change between the time the method is queued and the time it runs.
- **Fix:** Pass `Set<Id> contactIds` to an `@future` method, or implement `Queueable` (whose constructor accepts `List<Contact>` or custom Apex types).

## `System.AssertException: Assertion Failed: Expected: 2, Actual: 0` when asserting async results before `Test.stopTest()`

- **Why:** `System.enqueueJob(...)` and `@future` only queue work to run after the current transaction finishes. Querying `Task` before `Test.stopTest()` runs before the background job has executed.
- **Fix:** Wrap the async calls between `Test.startTest();` and `Test.stopTest();` and run your assertions on the lines **after** `Test.stopTest();`.

## `System.DmlException: Insert failed. First exception on row 0; first error: MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object (or vice versa)`

- **Why:** Salesforce does not allow DML on a setup object (`User`, `PermissionSetAssignment`, `GroupMember`) and a non-setup object (`Account`, `Contact`, `Task`) in the same transaction.
- **Fix:** Move the second DML operation into a `Queueable` or `@future` method so it executes in a separate background transaction (or wrap one inside `System.runAs(user)` in an `@IsTest` method).
