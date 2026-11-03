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
