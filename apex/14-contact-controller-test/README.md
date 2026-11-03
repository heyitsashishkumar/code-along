# 14 · Write your first Apex unit test: `ContactControllerTest`

The code for **Apex from Zero #14**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`ContactControllerTest`**, an `@IsTest` unit test class that creates isolated test records once in `@TestSetup`, verifies `ContactController.getContacts()` and `ContactController.findContacts()`, tests `WITH USER_MODE` under a Standard User with `System.runAs(salesRep)`, and covers `AccountDirectory`, `CustomerOnboarding`, and `CustomerQueries`:

**`force-app/main/default/classes/ContactControllerTest.cls`**

```apex
@IsTest
private class ContactControllerTest {
    @TestSetup
    static void makeContacts() {
        Account shop = new Account(Name = 'Verma Logistics', BillingCity = 'Noida');
        insert shop;
        insert new List<Contact>{
            new Contact(
                FirstName = 'Ravi',
                LastName = 'Verma',
                MailingCity = 'Noida',
                AccountId = shop.Id
            ),
            new Contact(
                FirstName = 'Pooja',
                LastName = 'Verma',
                MailingCity = 'Noida',
                AccountId = shop.Id
            ),
            new Contact(
                FirstName = 'Neha',
                LastName = 'Gupta',
                MailingCity = 'Greater Noida',
                AccountId = shop.Id
            )
        };
        insert new Opportunity(
            Name = 'Packing material',
            AccountId = shop.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 95000
        );
    }

    @IsTest
    static void getContactsReturnsEveryone() {
        List<Contact> contacts = ContactController.getContacts();
        Assert.areEqual(3, contacts.size());
        Assert.areEqual('Neha Gupta', contacts[0].Name, 'sorted by name');
    }

    @IsTest
    static void findContactsMatchesPartOfTheName() {
        List<Contact> contacts = ContactController.findContacts('verma');
        Assert.areEqual(2, contacts.size());
        Assert.areEqual(3, ContactController.findContacts('').size());
    }
    // ... plus runsInUserModeUnderStandardUser & coversDirectoryOnboardingAndQueries
}
```

## Deploy and run the tests

1. **Deploy `ContactControllerTest.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/ContactControllerTest.cls --target-org desk-org
   ```

2. **Run the test class with code coverage:**

   ```bash
   sf apex run test --class-names ContactControllerTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

All 4 test methods in `ContactControllerTest` pass with `100%` code coverage on `ContactController`, `AccountDirectory`, `CustomerOnboarding`, and `CustomerQueries`.

**Your small task:** add an assertion in `findContactsMatchesPartOfTheName` checking `Assert.areEqual(0, ContactController.findContacts('NoSuchPerson').size());`, deploy, and re-run the test.
