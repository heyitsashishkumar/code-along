@IsTest
private class DealCalculatorTest {
    @IsTest
    static void addsEighteenPercentGstAndHandlesNull() {
        Assert.areEqual(118000.00, DealCalculator.addGst(100000));
        Assert.areEqual(0.00, DealCalculator.addGst(null));
    }

    @IsTest
    static void appliesFestivalDiscountOnlyAboveThreshold() {
        Assert.areEqual(108000.00, DealCalculator.applyDiscount(120000, true));
        Assert.areEqual(60000.00, DealCalculator.applyDiscount(60000, true));
        Assert.areEqual(120000.00, DealCalculator.applyDiscount(120000, false));
        Assert.areEqual(0.00, DealCalculator.applyDiscount(null, true));
    }

    @IsTest
    static void calculatesFollowUpDateAndSafeCustomerCity() {
        Assert.areEqual(Date.today().addDays(30), DealCalculator.nextFollowUpDate());
        Assert.areEqual('Noida', DealCalculator.safeCustomerCity(null));
        Assert.areEqual('Noida', DealCalculator.safeCustomerCity(new Contact(LastName = 'Verma')));
        Assert.areEqual(
            'Lucknow',
            DealCalculator.safeCustomerCity(
                new Contact(LastName = 'Khan', MailingCity = 'Lucknow')
            )
        );
    }

    @IsTest
    static void filtersAndSumsDealAmounts() {
        List<Decimal> amounts = new List<Decimal>{ 180000, 45000, null, 95000, 120000 };
        List<Decimal> filtered = DealFilter.filterHighValueAmounts(amounts, 90000);
        Assert.areEqual(new List<Decimal>{ 95000, 120000, 180000 }, filtered);
        Assert.areEqual(0, DealFilter.filterHighValueAmounts(null, null).size());
        Assert.areEqual(440000, DealFilter.sumAmounts(amounts));
        Assert.areEqual(0, DealFilter.sumAmounts(null));
    }
}
