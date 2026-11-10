public with sharing class CustomerQueries {
    public static List<Contact> getContactsByCity(String city) {
        if (String.isBlank(city)) {
            return new List<Contact>();
        }
        return [
            SELECT Id, FirstName, LastName, Email, Phone, Account.Name
            FROM Contact
            WHERE MailingCity = :city
            WITH USER_MODE
            ORDER BY LastName, FirstName
            LIMIT 50
        ];
    }

    public static List<Account> getShopsWithContacts(String nameFilter) {
        String pattern = '%' + (nameFilter != null ? nameFilter.trim() : '') + '%';
        return [
            SELECT Id, Name, BillingCity,
                (SELECT Id, FirstName, LastName, Email FROM Contacts ORDER BY LastName)
            FROM Account
            WHERE Name LIKE :pattern
            WITH USER_MODE
            ORDER BY Name
            LIMIT 25
        ];
    }

    public static Decimal getTotalWonDealAmount(Id accountId) {
        if (accountId == null) {
            return 0;
        }
        AggregateResult[] rows = [
            SELECT SUM(Amount) total
            FROM Opportunity
            WHERE AccountId = :accountId AND StageName = 'Closed Won'
            WITH USER_MODE
        ];
        Decimal sum = (Decimal) rows[0].get('total');
        return sum != null ? sum : 0;
    }
}
