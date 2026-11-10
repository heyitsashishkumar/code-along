@IsTest
private class WelcomeEmailJobTest {
    @IsTest
    static void queueableCreatesWelcomeTasksAndFutureStampsDescription() {
        Account shop = CustomerOnboarding.onboardShopWithContacts(
            'Mehta Electricals',
            new List<String>{ 'Mehta', 'Kapoor' }
        );
        List<Contact> onboarded = [
            SELECT Id, LastName
            FROM Contact
            WHERE AccountId = :shop.Id
            ORDER BY LastName
        ];

        Test.startTest();
        Id jobId = System.enqueueJob(new WelcomeEmailJob(onboarded));
        WelcomeEmailJob.stampOnboardingNoteAsync(
            new Map<Id, Contact>(onboarded).keySet()
        );
        Test.stopTest();

        Assert.isNotNull(jobId);
        List<Task> tasks = [
            SELECT WhoId, Subject, Status
            FROM Task
            WHERE WhoId IN :onboarded
            ORDER BY Subject
        ];
        Assert.areEqual(2, tasks.size());
        Assert.areEqual('Welcome call for Kapoor', tasks[0].Subject);
        Assert.areEqual('Welcome call for Mehta', tasks[1].Subject);

        List<Contact> stamped = [
            SELECT Description
            FROM Contact
            WHERE Id IN :onboarded
        ];
        Assert.areEqual('Onboarded by Sharma Traders async desk', stamped[0].Description);
    }

    @IsTest
    static void handlesEmptyAndNullInputsGracefully() {
        Test.startTest();
        System.enqueueJob(new WelcomeEmailJob(null));
        WelcomeEmailJob.stampOnboardingNoteAsync(new Set<Id>());
        Test.stopTest();

        Assert.areEqual(0, [SELECT COUNT() FROM Task]);
    }
}
