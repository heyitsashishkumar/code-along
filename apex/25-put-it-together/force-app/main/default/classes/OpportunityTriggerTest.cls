@IsTest
private class OpportunityTriggerTest {
    @TestSetup
    static void makeAccounts() {
        insert new List<Account>{
            new Account(Name = 'Sharma Traders'),
            new Account(Name = 'Gupta Stores')
        };
    }

    @IsTest
    static void contactTriggerFillsDefaultLeadSourceAndCountry() {
        Contact c = new Contact(FirstName = 'Ravi', LastName = 'Verma');
        insert c;
        Contact saved = [
            SELECT LeadSource, MailingCountry
            FROM Contact
            WHERE Id = :c.Id
        ];
        Assert.areEqual('Web', saved.LeadSource);
        Assert.areEqual('India', saved.MailingCountry);
    }

    @IsTest
    static void rollsUp200WonOpportunitiesInBulk() {
        Account sharma = [SELECT Id FROM Account WHERE Name = 'Sharma Traders'];
        List<Opportunity> deals = new List<Opportunity>();
        for (Integer i = 1; i <= 200; i++) {
            deals.add(
                new Opportunity(
                    Name = 'Bulk Deal ' + i,
                    AccountId = sharma.Id,
                    StageName = 'Closed Won',
                    CloseDate = Date.today(),
                    Amount = 1000
                )
            );
        }
        insert deals;

        Account updated = [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id];
        Assert.areEqual(200000, updated.AnnualRevenue);
    }

    @IsTest
    static void updatesBothAccountsOnReparentDeleteAndUndelete() {
        Account sharma = [SELECT Id FROM Account WHERE Name = 'Sharma Traders'];
        Account gupta = [SELECT Id FROM Account WHERE Name = 'Gupta Stores'];

        Opportunity racks = new Opportunity(
            Name = 'Warehouse racks',
            AccountId = sharma.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 50000
        );
        Opportunity packing = new Opportunity(
            Name = 'Packing material',
            AccountId = sharma.Id,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 30000
        );
        insert new List<Opportunity>{ racks, packing };

        packing.AccountId = gupta.Id;
        update packing;

        Assert.areEqual(
            50000,
            [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue
        );
        Assert.areEqual(
            30000,
            [SELECT AnnualRevenue FROM Account WHERE Id = :gupta.Id].AnnualRevenue
        );

        delete racks;
        Assert.areEqual(
            0,
            [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue
        );

        undelete racks;
        Assert.areEqual(
            50000,
            [SELECT AnnualRevenue FROM Account WHERE Id = :sharma.Id].AnnualRevenue
        );
    }

    @IsTest
    static void defaultsMissingFieldsRejectsNegativeAmountAndIgnoresNoAccount() {
        Opportunity noAccountDeal = new Opportunity(
            Name = 'Walk-in Quote',
            Amount = 15000
        );
        insert noAccountDeal;
        Opportunity saved = [
            SELECT StageName, CloseDate
            FROM Opportunity
            WHERE Id = :noAccountDeal.Id
        ];
        Assert.areEqual('Prospecting', saved.StageName);
        Assert.areEqual(Date.today().addDays(30), saved.CloseDate);

        Database.SaveResult badResult = Database.insert(
            new Opportunity(
                Name = 'Negative Deal',
                StageName = 'Prospecting',
                CloseDate = Date.today(),
                Amount = -100
            ),
            false
        );
        Assert.isFalse(badResult.isSuccess());
        Assert.areEqual(
            'Deal amount cannot be negative.',
            badResult.getErrors()[0].getMessage()
        );
    }
}
