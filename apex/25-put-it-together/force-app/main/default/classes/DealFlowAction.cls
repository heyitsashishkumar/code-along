public with sharing class DealFlowAction {
    public class Request {
        @InvocableVariable(label='Account ID' required=true)
        public Id accountId;

        @InvocableVariable(label='Deal Name' required=true)
        public String dealName;

        @InvocableVariable(label='Amount (INR)' required=true)
        public Decimal amount;
    }

    public class Result {
        @InvocableVariable(label='Created Opportunity ID')
        public Id dealId;
    }

    @InvocableMethod(
        label='Create Quick Deal'
        description='Creates a Prospecting Opportunity for each Flow request'
    )
    public static List<Result> createQuickDeals(List<Request> requests) {
        List<Result> results = new List<Result>();
        if (requests == null || requests.isEmpty()) {
            return results;
        }
        List<Opportunity> toInsert = new List<Opportunity>();
        for (Request req : requests) {
            toInsert.add(
                new Opportunity(
                    AccountId = req.accountId,
                    Name = req.dealName,
                    StageName = 'Prospecting',
                    CloseDate = Date.today().addDays(30),
                    Amount = req.amount
                )
            );
        }
        insert as user toInsert;
        for (Opportunity deal : toInsert) {
            Result r = new Result();
            r.dealId = deal.Id;
            results.add(r);
        }
        return results;
    }
}
