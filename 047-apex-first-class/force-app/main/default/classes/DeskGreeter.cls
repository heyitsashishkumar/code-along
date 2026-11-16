public with sharing class DeskGreeter {
    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Hello, friend!';
        }
        return 'Hello, ' + customerName + '!';
    }
}