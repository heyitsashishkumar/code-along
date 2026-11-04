trigger OpportunityTrigger on Opportunity (
    before insert,
    before update,
    after insert,
    after update
) {
    if (Trigger.isBefore) {
        for (Opportunity deal : Trigger.new) {
            if (deal.CloseDate == null) {
                deal.CloseDate = Date.today().addDays(30);
            }
            if (String.isBlank(deal.StageName)) {
                deal.StageName = 'Prospecting';
            }
        }
    }
    if (Trigger.isAfter) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity deal : Trigger.new) {
            if (deal.AccountId != null) {
                accountIds.add(deal.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return;
        }
        Map<Id, Decimal> totalsByAccount = new Map<Id, Decimal>();
        for (AggregateResult row : [
            SELECT AccountId, SUM(Amount) total
            FROM Opportunity
            WHERE AccountId IN :accountIds AND StageName = 'Closed Won'
            GROUP BY AccountId
        ]) {
            Decimal sum = (Decimal) row.get('total');
            totalsByAccount.put((Id) row.get('AccountId'), sum != null ? sum : 0);
        }
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : accountIds) {
            Decimal total = totalsByAccount.containsKey(accountId)
                ? totalsByAccount.get(accountId)
                : 0;
            accountsToUpdate.add(new Account(Id = accountId, AnnualRevenue = total));
        }
        update accountsToUpdate;
    }
}
