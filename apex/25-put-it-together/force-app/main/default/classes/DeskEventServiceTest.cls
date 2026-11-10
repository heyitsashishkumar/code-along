@IsTest
private class DeskEventServiceTest {
    @IsTest
    static void readsThresholdWithZeroSoqlAndCreatesHighValueAlerts() {
        Integer queriesBefore = Limits.getQueries();
        Decimal defaultThreshold = DeskEventService.getHighValueThreshold();
        Integer queriesAfter = Limits.getQueries();

        Assert.areEqual(100000, defaultThreshold);
        Assert.areEqual(0, queriesAfter - queriesBefore, '0 SOQL queries used');

        Account shop = new Account(Name = 'Verma Logistics');
        insert shop;

        DeskEventService.testThresholdOverride = 50000;
        List<Opportunity> deals = new List<Opportunity>{
            new Opportunity(
                Name = 'Big Warehouse Deal',
                AccountId = shop.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                Amount = 75000
            ),
            new Opportunity(
                Name = 'Small Tape Order',
                AccountId = shop.Id,
                StageName = 'Closed Won',
                CloseDate = Date.today(),
                Amount = 10000
            )
        };

        List<Task> alerts = DeskEventService.publishHighValueAlerts(deals);
        Assert.areEqual(1, alerts.size());
        Assert.areEqual('High-value deal won: Big Warehouse Deal', alerts[0].Subject);
        Assert.areEqual(0, DeskEventService.publishHighValueAlerts(null).size());
    }
}
