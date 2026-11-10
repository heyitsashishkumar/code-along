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
