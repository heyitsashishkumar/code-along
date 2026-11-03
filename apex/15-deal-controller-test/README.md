# 15 · Test data, users, and exceptions: `DealControllerTest`

The code for **Apex from Zero #15**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`DealControllerTest`**, which tests `DealController.getDeals(Id accountId)` across two separate shops to verify account filtering and sort order, tests the positive path of `createQuickDeal`, and verifies the negative `AuraHandledException` path using `try` / `Assert.fail(...)` / `catch (AuraHandledException e)`:

**`force-app/main/default/classes/DealControllerTest.cls`**

```apex
@IsTest
private class DealControllerTest {
    @IsTest
    static void getDealsReturnsOnlyThatAccountsDeals() {
        Account verma = new Account(Name = 'Verma Logistics');
        Account gupta = new Account(Name = 'Gupta Stores');
        insert new List<Account>{ verma, gupta };
        insert new List<Opportunity>{
            new Opportunity(
                Name = 'Warehouse racks',
                AccountId = verma.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount = 180000
            ),
            new Opportunity(
                Name = 'Packing material',
                AccountId = verma.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                Amount = 95000
            ),
            new Opportunity(
                Name = 'Shop shelving',
                AccountId = gupta.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                Amount = 60000
            )
        };

        List<Opportunity> deals = DealController.getDeals(verma.Id);

        Assert.areEqual(2, deals.size());
        Assert.areEqual('Packing material', deals[0].Name, 'sorted by close date');
    }

    @IsTest
    static void createQuickDealSavesValidDealAndRejectsInvalidInput() {
        Account verma = new Account(Name = 'Verma Logistics');
        insert verma;

        Opportunity created = DealController.createQuickDeal(
            verma.Id,
            'Diwali gift hampers',
            120000
        );
        Assert.isNotNull(created.Id);
        Assert.areEqual('Prospecting', created.StageName);

        try {
            DealController.createQuickDeal(verma.Id, '', -500);
            Assert.fail('Expected AuraHandledException for invalid deal input');
        } catch (AuraHandledException e) {
            Assert.areEqual(
                'Account, deal name, and a positive amount are required.',
                e.getMessage()
            );
        }
    }
}
```

## Deploy and run the test suite

1. **Deploy `DealControllerTest.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/DealControllerTest.cls --target-org desk-org
   ```

2. **Run both controller test classes with coverage:**

   ```bash
   sf apex run test --class-names ContactControllerTest,DealControllerTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

All test methods in `ContactControllerTest` and `DealControllerTest` pass with `100%` coverage on `ContactController` and `DealController`.

**Your small task:** add a negative assertion calling `DealController.createQuickDeal(null, 'Valid Name', 50000)` inside a `try` / `catch (AuraHandledException e)` block to verify that a `null` `accountId` is also rejected.
