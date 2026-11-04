@IsTest
private class ContactControllerTest {
    @TestSetup
    static void makeContacts() {
        Account shop = new Account(Name = 'Verma Logistics');
        insert shop;
        insert new List<Contact>{
            new Contact(FirstName = 'Ravi', LastName = 'Verma', AccountId = shop.Id),
            new Contact(FirstName = 'Pooja', LastName = 'Verma', AccountId = shop.Id),
            new Contact(FirstName = 'Neha', LastName = 'Gupta', AccountId = shop.Id)
        };
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
    }

    @IsTest
    static void findContactsWithAnEmptyKeyReturnsEveryone() {
        Assert.areEqual(3, ContactController.findContacts('').size());
    }
}
