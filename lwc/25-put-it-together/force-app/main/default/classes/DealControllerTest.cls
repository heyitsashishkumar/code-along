@IsTest
private class DealControllerTest {
    @IsTest
    static void getDealsReturnsOnlyThatAccountsDeals() {
        Account verma = new Account(Name = 'Verma Logistics');
        Account gupta = new Account(Name = 'Gupta Stores');
        insert new List<Account>{ verma, gupta };
        insert new List<Opportunity>{
            new Opportunity(Name = 'Warehouse racks', AccountId = verma.Id, StageName = 'Prospecting', CloseDate = Date.today().addDays(30), Amount = 180000),
            new Opportunity(Name = 'Packing material', AccountId = verma.Id, StageName = 'Closed Won', CloseDate = Date.today(), Amount = 95000),
            new Opportunity(Name = 'Shop shelving', AccountId = gupta.Id, StageName = 'Prospecting', CloseDate = Date.today(), Amount = 60000)
        };

        List<Opportunity> deals = DealController.getDeals(verma.Id);

        Assert.areEqual(2, deals.size());
        Assert.areEqual('Packing material', deals[0].Name, 'sorted by close date');
    }
}
