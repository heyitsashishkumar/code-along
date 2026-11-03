public with sharing class DeskGreeter {
    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Namaste, friend! Welcome to Sharma Traders.';
        }
        return 'Namaste, ' + customerName.trim() + '! Welcome to Sharma Traders.';
    }
}
