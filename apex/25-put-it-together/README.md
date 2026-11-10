# 25 · Put the whole customer-desk backend together, run the full test suite, and ship

The code for **Apex from Zero #25** (the grand finale of **Apex from Zero: Code Along**). Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`ApexDeskTestSuite.cls`**, an end-to-end integration test exercising the complete Sharma Traders Customer Desk backend across all 6 sections—greeting and GST helpers, bulk shop + contact onboarding, `ContactTrigger` defaults, LWC `ContactController` and `DealController` methods, `OpportunityTriggerHandler` `Closed Won` revenue rollups, `WelcomeEmailJob` (`Queueable`), and `DeskEventService` high-value alerts—plus `DeskGreeterTest.cls` and `DealCalculatorTest.cls` for **100% org-wide code coverage** across all 17 production classes and triggers:

**`force-app/main/default/classes/ApexDeskTestSuite.cls`**

```apex
@IsTest
private class ApexDeskTestSuite {
    @IsTest
    static void fullCustomerDeskLifecycleFromOnboardingToAsyncAndRollup() {
        // 1. Greeting & pricing helpers (Section 0 & 1)
        Assert.areEqual(
            'Namaste, Ravi Verma! Welcome to Sharma Traders.',
            DeskGreeter.greet('Ravi Verma')
        );
        Assert.areEqual(118000.00, DealCalculator.addGst(100000));
        Assert.areEqual(
            new List<Decimal>{ 95000, 180000 },
            DealFilter.filterHighValueAmounts(new List<Decimal>{ 180000, 40000, 95000 }, 90000)
        );

        // 2. Onboard shop + contacts (Section 2) & verify ContactTrigger defaults (Section 4)
        Account shop = CustomerOnboarding.onboardShopWithContacts(
            'Verma Logistics',
            new List<String>{ 'Verma', 'Sharma' }
        );
        List<Contact> contacts = ContactController.findContacts('Verma');
        Assert.areEqual(1, contacts.size());

        Contact savedContact = [
            SELECT Id, LastName, LeadSource, MailingCountry, MailingCity
            FROM Contact
            WHERE Id = :contacts[0].Id
        ];
        Assert.areEqual('Web', savedContact.LeadSource);
        Assert.areEqual('India', savedContact.MailingCountry);
        Assert.areEqual('Noida', savedContact.MailingCity);

        // 3. Create quick deal via LWC controller (Section 3) & close it to fire OpportunityTriggerHandler (Section 4)
        Opportunity deal = DealController.createQuickDeal(
            shop.Id,
            'Annual Packaging Supply',
            150000
        );
        Assert.areEqual(1, DealController.getDeals(shop.Id).size());

        deal.StageName = 'Closed Won';
        update deal;

        Account rolledUp = [SELECT AnnualRevenue FROM Account WHERE Id = :shop.Id];
        Assert.areEqual(150000, rolledUp.AnnualRevenue);
        Assert.areEqual(150000, CustomerQueries.getTotalWonDealAmount(shop.Id));

        // 4. Enqueue WelcomeEmailJob & publish high-value alert (Section 5)
        Test.startTest();
        System.enqueueJob(new WelcomeEmailJob(new List<Contact>{ savedContact }));
        List<Task> alerts = DeskEventService.publishHighValueAlerts(
            new List<Opportunity>{ deal }
        );
        Test.stopTest();

        Assert.areEqual(1, alerts.size());
        Assert.areEqual(
            1,
            [SELECT COUNT() FROM Task WHERE WhoId = :contacts[0].Id]
        );
    }
}
```

## Deploy and run the full test suite

1. **Deploy the complete backend** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run all local unit tests with code coverage:**

   ```bash
   sf apex run test --test-level RunLocalTests --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

All 10 test classes (`DeskGreeterTest`, `DealCalculatorTest`, `ContactControllerTest`, `DealControllerTest`, `OpportunityTriggerTest`, `WelcomeEmailJobTest`, `StaleDealBatchTest`, `PincodeLookupServiceTest`, `DeskEventServiceTest`, and `ApexDeskTestSuite`) pass with **100% org-wide code coverage** across every production class and trigger.

**Your final challenge:** deploy both `code-along/apex/25-put-it-together` and `code-along/lwc/25-put-it-together` into your Developer Edition org, add a quick-deal button on the LWC Customer Desk that calls `DealController.createQuickDeal`, and watch your LWC frontend and Apex triggers work together live!
