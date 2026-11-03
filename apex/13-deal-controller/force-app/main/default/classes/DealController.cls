public with sharing class DealController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getDeals(Id accountId) {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE AccountId = :accountId
            WITH USER_MODE
            ORDER BY CloseDate
        ];
    }

    @AuraEnabled
    public static Opportunity createQuickDeal(Id accountId, String dealName, Decimal amount) {
        if (accountId == null || String.isBlank(dealName) || amount == null || amount <= 0) {
            AuraHandledException err = new AuraHandledException(
                'Account, deal name, and a positive amount are required.'
            );
            err.setMessage('Account, deal name, and a positive amount are required.');
            throw err;
        }
        Opportunity deal = new Opportunity(
            AccountId = accountId,
            Name = dealName.trim(),
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = amount
        );
        insert as user deal;
        return deal;
    }
}
