public with sharing class WelcomeEmailJob implements Queueable {
    private final List<Contact> contacts;

    public WelcomeEmailJob(List<Contact> contacts) {
        this.contacts = contacts != null ? contacts : new List<Contact>();
    }

    public void execute(QueueableContext context) {
        if (this.contacts.isEmpty()) {
            return;
        }
        List<Task> tasks = new List<Task>();
        for (Contact c : this.contacts) {
            if (c.Id != null) {
                tasks.add(
                    new Task(
                        WhoId = c.Id,
                        Subject = 'Welcome call for ' + c.LastName,
                        Status = 'Not Started',
                        Priority = 'Normal',
                        ActivityDate = Date.today().addDays(2)
                    )
                );
            }
        }
        if (!tasks.isEmpty()) {
            insert as user tasks;
        }
    }

    @future
    public static void stampOnboardingNoteAsync(Set<Id> contactIds) {
        if (contactIds == null || contactIds.isEmpty()) {
            return;
        }
        List<Contact> toUpdate = [
            SELECT Id, Description
            FROM Contact
            WHERE Id IN :contactIds
            WITH USER_MODE
        ];
        for (Contact c : toUpdate) {
            c.Description = 'Onboarded by Sharma Traders async desk';
        }
        update as user toUpdate;
    }
}
