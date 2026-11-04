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
}
