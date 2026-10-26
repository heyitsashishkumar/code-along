public with sharing class DealCalculator {
    public static final Decimal GST_RATE = 0.18;
    public static final Decimal FESTIVAL_DISCOUNT_RATE = 0.10;
    public static final Decimal DISCOUNT_THRESHOLD = 100000;

    public static Decimal addGst(Decimal baseAmount) {
        Decimal safeAmount = baseAmount != null ? baseAmount : 0;
        return (safeAmount * (1 + GST_RATE)).setScale(2);
    }

    public static Decimal applyDiscount(Decimal amount, Boolean isFestivalOrder) {
        Decimal safeAmount = amount != null ? amount : 0;
        if (isFestivalOrder == true && safeAmount >= DISCOUNT_THRESHOLD) {
            return (safeAmount * (1 - FESTIVAL_DISCOUNT_RATE)).setScale(2);
        }
        return safeAmount.setScale(2);
    }

    public static Date nextFollowUpDate() {
        return Date.today().addDays(30);
    }

    public static String safeCustomerCity(Contact customer) {
        String city = customer?.MailingCity;
        return String.isNotBlank(city) ? city : 'Noida';
    }
}
