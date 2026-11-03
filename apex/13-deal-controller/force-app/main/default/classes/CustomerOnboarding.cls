public with sharing class CustomerOnboarding {
    public static Account onboardShopWithContacts(String shopName, List<String> contactLastNames) {
        Account shop = new Account(Name = shopName, BillingCity = 'Noida');
        insert shop;

        List<Contact> contacts = new List<Contact>();
        for (String lastName : contactLastNames) {
            contacts.add(
                new Contact(
                    LastName = lastName,
                    AccountId = shop.Id,
                    MailingCity = 'Noida'
                )
            );
        }
        insert contacts;
        return shop;
    }

    public static Integer insertContactsAllowingPartialSuccess(List<Contact> contacts) {
        Database.SaveResult[] results = Database.insert(contacts, false);
        Integer succeeded = 0;
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                succeeded++;
            }
        }
        return succeeded;
    }

    public static Boolean onboardWithRollbackOnError(String shopName, Contact primaryContact) {
        Savepoint sp = Database.setSavepoint();
        try {
            Account shop = new Account(Name = shopName);
            insert shop;
            primaryContact.AccountId = shop.Id;
            insert primaryContact;
            return true;
        } catch (DmlException e) {
            Database.rollback(sp);
            return false;
        }
    }
}
