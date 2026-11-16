public with sharing class DeskGreeter {
    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Namaste, friend!';
        }
        return 'Namaste, ' + customerName + '!';
    }
}