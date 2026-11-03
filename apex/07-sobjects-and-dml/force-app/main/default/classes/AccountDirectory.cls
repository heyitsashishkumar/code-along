public with sharing class AccountDirectory {
    public static Set<Id> collectAccountIds(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        if (contacts == null) {
            return accountIds;
        }
        for (Contact c : contacts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        return accountIds;
    }

    public static Map<Id, Account> buildDirectory(List<Account> accounts) {
        if (accounts == null) {
            return new Map<Id, Account>();
        }
        return new Map<Id, Account>(accounts);
    }

    public static String findAccountName(Map<Id, Account> directory, Id accountId) {
        if (directory != null && accountId != null && directory.containsKey(accountId)) {
            return directory.get(accountId).Name;
        }
        return 'Unassigned';
    }
}
