public with sharing class DeskGreeter {
    String shopName;

    public DeskGreeter(String shopName) {
        this.shopName = shopName;
    }

    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Namaste, friend!';
        }
        return 'Namaste, ' + customerName + '!';
    }

    public String welcome(String customerName) {
        return 'Namaste, ' + customerName
            + '! Welcome to ' + shopName + '.';
    }
}