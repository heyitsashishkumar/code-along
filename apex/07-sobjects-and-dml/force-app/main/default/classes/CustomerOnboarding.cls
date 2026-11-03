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
}
