public with sharing class DeskGreeter {
    String shopName;

    public DeskGreeter(String shopName) {
        this.shopName = shopName;
    }

    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Hello, friend!';
        }
        return 'Hello, ' + customerName + '!';
    }

    public String welcome(String customerName) {
        return 'Hello, ' + customerName
            + '! Welcome to ' + shopName + '.';
    }
}