# 04 · Variables, types, dates, and `null`

The code for **Apex from Zero #4**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`DealCalculator`**, which calculates 18% GST (`Decimal`), festival discounts (`Boolean`), 30-day follow-up dates (`Date`), and safely reads a customer's city (`?.` safe navigation):

**`force-app/main/default/classes/DealCalculator.cls`**

```apex
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
```

## Deploy and run it

1. **Deploy `DealCalculator.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/DealCalculator.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   System.debug('With GST: ' + DealCalculator.addGst(100000));
   System.debug('Festival price: ' + DealCalculator.applyDiscount(120000, true));
   System.debug('Follow-up date: ' + DealCalculator.nextFollowUpDate());
   System.debug('City when null: ' + DealCalculator.safeCustomerCity(null));
   ```

## What you should see

```
|USER_DEBUG|[1]|DEBUG|With GST: 118000.00
|USER_DEBUG|[2]|DEBUG|Festival price: 108000.00
|USER_DEBUG|[3]|DEBUG|Follow-up date: 2026-11-25 00:00:00
|USER_DEBUG|[4]|DEBUG|City when null: Noida
```

**Your small task:** add a method `public static Decimal gstAmountOnly(Decimal baseAmount)` that returns just the 18% tax (`(safeAmount * GST_RATE).setScale(2)`), deploy, and test it with `100000`.
