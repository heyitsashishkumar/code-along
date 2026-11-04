public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WITH USER_MODE
            ORDER BY Name
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
            SELECT Id, Name, Title, Phone, Email, AccountId
            FROM Contact
            WHERE Name LIKE :key
            WITH USER_MODE
            ORDER BY Name
            LIMIT 10
        ];
    }
}
