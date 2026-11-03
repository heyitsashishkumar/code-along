# 10 · Parent-to-child, child-to-parent, and aggregates

The code for **Apex from Zero #10**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

The completed **`CustomerQueries`** class, adding `getShopsWithContacts` (parent-to-child subquery `(SELECT ... FROM Contacts)`) and `getTotalWonDealAmount` (`SUM(Amount)` with `AggregateResult` and a `null`-to-`0` fallback):

**`force-app/main/default/classes/CustomerQueries.cls`**

```apex
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
```

## Deploy and run it

1. **Deploy `CustomerQueries.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/CustomerQueries.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   List<Account> shops = CustomerQueries.getShopsWithContacts('Verma');
   for (Account shop : shops) {
       System.debug(shop.Name + ': ' + shop.Contacts.size());
       Decimal won = CustomerQueries.getTotalWonDealAmount(shop.Id);
       System.debug('Closed Won total: ' + won);
   }
   ```

## What you should see

```
|USER_DEBUG|[3]|DEBUG|Verma Logistics: 2
|USER_DEBUG|[5]|DEBUG|Closed Won total: 95000.00
```

**Your small task:** in `scripts/apex/hello.apex`, write an `Account` query that includes both `(SELECT Id, FirstName, LastName FROM Contacts)` and `(SELECT Name, Amount FROM Opportunities)` as two sibling subqueries on the same `Account`.
