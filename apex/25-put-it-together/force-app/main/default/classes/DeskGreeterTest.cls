@IsTest
private class DeskGreeterTest {
    @IsTest
    static void greetsNamedCustomer() {
        Assert.areEqual(
            'Namaste, Ravi! Welcome to Sharma Traders.',
            DeskGreeter.greet('Ravi')
        );
    }

    @IsTest
    static void greetsBlankOrNullCustomerAsFriend() {
        Assert.areEqual(
            'Namaste, friend! Welcome to Sharma Traders.',
            DeskGreeter.greet('')
        );
        Assert.areEqual(
            'Namaste, friend! Welcome to Sharma Traders.',
            DeskGreeter.greet(null)
        );
    }
}
