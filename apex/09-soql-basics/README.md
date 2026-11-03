# 09 · SOQL: querying your org's database

The code for **Apex from Zero #9**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

Part 1 of **`CustomerQueries`** (`getContactsByCity`), which queries Sharma Traders' `Contact` records by city using a `:city` bind variable, `WITH USER_MODE`, `ORDER BY`, and `LIMIT`:

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
}
```

## Load the seed data, deploy, and run it

1. **Load Sharma Traders' sample accounts, contacts, and deals** (once per org):

   ```bash
   sf data import tree --plan data/plan.json --target-org desk-org
   ```

2. **Deploy `CustomerQueries.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/CustomerQueries.cls --target-org desk-org
   ```

3. **Try it in anonymous Apex:**

   ```apex
   List<Contact> noida = CustomerQueries.getContactsByCity('Noida');
   System.debug('Noida count: ' + noida.size());
   for (Contact c : noida) {
       System.debug(c.FirstName + ' ' + c.LastName + ' ' + c.Email);
   }
   ```

## What you should see

Your Noida contacts printed in alphabetical order by `LastName, FirstName`, and an empty list `()` of size `0` (no exception!) when you pass a city with no matching contacts.

**Your small task:** in `scripts/apex/hello.apex`, write a SOQL query that returns a `List<Opportunity>` of up to `10` deals where `Amount >= 100000`, ordered by `Amount DESC`, and print each deal's `Name` and `Amount`.
