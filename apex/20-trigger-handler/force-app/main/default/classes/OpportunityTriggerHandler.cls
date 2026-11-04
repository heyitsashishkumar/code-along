public with sharing class OpportunityTriggerHandler {
    public static void beforeSave(List<Opportunity> newDeals) {
        for (Opportunity deal : newDeals) {
            if (deal.Amount != null && deal.Amount < 0) {
                deal.Amount.addError('Deal amount cannot be negative.');
            }
            if (deal.CloseDate == null) {
                deal.CloseDate = Date.today().addDays(30);
            }
            if (String.isBlank(deal.StageName)) {
                deal.StageName = 'Prospecting';
            }
        }
    }

    public static void afterChange(List<Opportunity> newDeals, List<Opportunity> oldDeals) {
        Set<Id> accountIds = new Set<Id>();
        if (newDeals != null) {
            for (Opportunity deal : newDeals) {
                if (deal.AccountId != null) {
                    accountIds.add(deal.AccountId);
                }
            }
        }
        if (oldDeals != null) {
            for (Opportunity deal : oldDeals) {
                if (deal.AccountId != null) {
                    accountIds.add(deal.AccountId);
                }
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
