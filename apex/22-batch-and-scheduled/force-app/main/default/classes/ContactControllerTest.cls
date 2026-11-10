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

    @IsTest
    static void runsInUserModeUnderStandardUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User salesRep = new User(
            Alias = 'rverma',
            Email = 'ravi.rep@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Verma',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'Asia/Kolkata',
            UserName = 'ravi.rep.' + System.currentTimeMillis() + '@example.com'
        );
        insert salesRep;

        System.runAs(salesRep) {
            List<Contact> visibleContacts = ContactController.getContacts();
            Assert.areEqual(3, visibleContacts.size());
        }
    }

    @IsTest
    static void coversDirectoryOnboardingAndQueries() {
        List<Contact> contacts = [SELECT Id, LastName, AccountId FROM Contact];
        Set<Id> accountIds = AccountDirectory.collectAccountIds(contacts);
        Assert.areEqual(1, accountIds.size());
        Assert.areEqual(0, AccountDirectory.collectAccountIds(null).size());

        List<Account> accounts = [SELECT Id, Name FROM Account];
        Map<Id, Account> directory = AccountDirectory.buildDirectory(accounts);
        Assert.areEqual(0, AccountDirectory.buildDirectory(null).size());
        Assert.areEqual(
            'Verma Logistics',
            AccountDirectory.findAccountName(directory, accounts[0].Id)
        );
        Assert.areEqual('Unassigned', AccountDirectory.findAccountName(directory, null));

        Account onboarded = CustomerOnboarding.onboardShopWithContacts(
            'Das Sweets',
            new List<String>{ 'Das', 'Sen' }
        );
        Assert.isNotNull(onboarded.Id);

        Integer partialCount = CustomerOnboarding.insertContactsAllowingPartialSuccess(
            new List<Contact>{
                new Contact(LastName = 'Patel'),
                new Contact(FirstName = 'MissingLastNameOnly')
            }
        );
        Assert.areEqual(1, partialCount);

        Assert.isTrue(
            CustomerOnboarding.onboardWithRollbackOnError(
                'Khan Electricals',
                new Contact(LastName = 'Khan')
            )
        );
        Assert.isFalse(
            CustomerOnboarding.onboardWithRollbackOnError(
                'RolledBack Shop',
                new Contact(FirstName = 'NoLastName')
            )
        );
        Assert.areEqual(
            0,
            [SELECT COUNT() FROM Account WHERE Name = 'RolledBack Shop']
        );

        Assert.areEqual(4, CustomerQueries.getContactsByCity('Noida').size());
        Assert.areEqual(0, CustomerQueries.getContactsByCity('').size());
        Assert.areEqual(1, CustomerQueries.getShopsWithContacts('Verma').size());
        Assert.areEqual(95000, CustomerQueries.getTotalWonDealAmount(accounts[0].Id));
        Assert.areEqual(0, CustomerQueries.getTotalWonDealAmount(onboarded.Id));
        Assert.areEqual(0, CustomerQueries.getTotalWonDealAmount(null));
    }
}
