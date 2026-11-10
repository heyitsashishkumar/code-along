@IsTest
private class StaleDealBatchTest {
    @IsTest
    static void flagsOpenDealsPastCloseDateAndPreservesStatefulCount() {
        Account shop = new Account(Name = 'Verma Logistics');
        insert shop;

        insert new List<Opportunity>{
            new Opportunity(
                Name = 'Overdue Crate Order',
                AccountId = shop.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(-10),
                Amount = 60000
            ),
            new Opportunity(
                Name = 'Future Rack Order',
                AccountId = shop.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(20),
                Amount = 120000
            )
        };

        StaleDealBatch batch = new StaleDealBatch();
        Test.startTest();
        Id batchId = Database.executeBatch(batch, 200);
        Test.stopTest();

        Assert.isNotNull(batchId);
        Opportunity overdue = [
            SELECT Description
            FROM Opportunity
            WHERE Name = 'Overdue Crate Order'
        ];
        Opportunity futureDeal = [
            SELECT Description
            FROM Opportunity
            WHERE Name = 'Future Rack Order'
        ];
        Assert.areEqual('Stale deal: past close date', overdue.Description);
        Assert.isNull(futureDeal.Description);
    }

    @IsTest
    static void schedulesNightlyBatchAt2Am() {
        Test.startTest();
        String jobId = System.schedule(
            'Nightly Stale Deal Check',
            StaleDealScheduler.CRON_NIGHTLY_2AM,
            new StaleDealScheduler()
        );
        Test.stopTest();

        CronTrigger ct = [
            SELECT CronExpression, TimesTriggered
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        Assert.areEqual('0 0 2 * * ?', ct.CronExpression);
        Assert.areEqual(0, ct.TimesTriggered);
    }
}
