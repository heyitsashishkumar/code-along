# 21 · Async Apex part 1: `Queueable` and `@future` (work in the background)

The code for **Apex from Zero #21**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`WelcomeEmailJob.cls`**, implementing `Queueable` (`execute(QueueableContext context)` creating welcome `Task` records for onboarded contacts) alongside an `@future` method (`stampOnboardingNoteAsync(Set<Id> contactIds)`):

```apex
public with sharing class WelcomeEmailJob implements Queueable {
    private final List<Contact> contacts;

    public WelcomeEmailJob(List<Contact> contacts) {
        this.contacts = contacts != null ? contacts : new List<Contact>();
    }

    public void execute(QueueableContext context) {
        if (this.contacts.isEmpty()) {
            return;
        }
        List<Task> tasks = new List<Task>();
        for (Contact c : this.contacts) {
            if (c.Id != null) {
                tasks.add(
                    new Task(
                        WhoId = c.Id,
                        Subject = 'Welcome call for ' + c.LastName,
                        Status = 'Not Started',
                        Priority = 'Normal',
                        ActivityDate = Date.today().addDays(2)
                    )
                );
            }
        }
        if (!tasks.isEmpty()) {
            insert as user tasks;
        }
    }

    @future
    public static void stampOnboardingNoteAsync(Set<Id> contactIds) {
        if (contactIds == null || contactIds.isEmpty()) {
            return;
        }
        List<Contact> toUpdate = [
            SELECT Id, Description
            FROM Contact
            WHERE Id IN :contactIds
            WITH USER_MODE
        ];
        for (Contact c : toUpdate) {
            c.Description = 'Onboarded by Sharma Traders async desk';
        }
        update as user toUpdate;
    }
}
```

2. **`WelcomeEmailJobTest.cls`**, using `Test.startTest()` and `Test.stopTest()` to flush both `System.enqueueJob(new WelcomeEmailJob(onboarded))` and `WelcomeEmailJob.stampOnboardingNoteAsync(...)` synchronously at **100% coverage**.

## Deploy and run the tests

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run `WelcomeEmailJobTest` with code coverage:**

   ```bash
   sf apex run test --class-names WelcomeEmailJobTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

Both test methods in `WelcomeEmailJobTest` pass with `100%` code coverage on `WelcomeEmailJob`.

**Your small task:** query `AsyncApexJob` inside `WelcomeEmailJobTest` (`[SELECT Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobId]`) after `Test.stopTest()` and assert `Status == 'Completed'` and `NumberOfErrors == 0`.
