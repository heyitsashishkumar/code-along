# Troubleshooting · 22 · Async Apex part 2: `Database.Batchable` and `Schedulable`

Every error we hit while making **Apex from Zero #22**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.UnexpectedException: No more than one executeBatch can be called from within a test method. Please make sure the iterable returned from your start method matches the batch size, resulting in one executeBatch invocation.`

- **Why:** In `@IsTest`, Salesforce allows at most **one** `execute()` chunk invocation per test method. If `start()` returns 400 rows and `Database.executeBatch(batch, 200)` uses a scope size of 200, `Test.stopTest()` throws `System.UnexpectedException`.
- **Fix:** Insert at most `scope` matching test rows (e.g. `<= 200` rows) in your unit test so all test records are processed in a single batch chunk.

## Counter variable resets to `0` in `finish()` even with `Database.Stateful`

- **Why:** Only non-static **instance member variables** (`public Integer dealsFlagged = 0;`) are preserved between chunks by `Database.Stateful`. `static` variables still reset at the end of every chunk's transaction.
- **Fix:** Remove the `static` keyword from any field you want `Database.Stateful` to preserve across chunks.
