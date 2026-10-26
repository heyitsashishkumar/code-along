# 05 · Lists and loops

The code for **Apex from Zero #5**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`DealFilter`**, which loops through a `List<Decimal>` of Sharma Traders' deal amounts, keeps only high-value deals in sorted order, and sums total deal value:

**`force-app/main/default/classes/DealFilter.cls`**

```apex
public with sharing class DealFilter {
    public static List<Decimal> filterHighValueAmounts(List<Decimal> amounts, Decimal minimumAmount) {
        List<Decimal> result = new List<Decimal>();
        Decimal threshold = minimumAmount != null ? minimumAmount : 0;
        if (amounts == null) {
            return result;
        }
        for (Decimal amount : amounts) {
            if (amount != null && amount >= threshold) {
                result.add(amount);
            }
        }
        result.sort();
        return result;
    }

    public static Decimal sumAmounts(List<Decimal> amounts) {
        Decimal total = 0;
        if (amounts == null) {
            return total;
        }
        for (Decimal amount : amounts) {
            if (amount != null) {
                total += amount;
            }
        }
        return total;
    }
}
```

## Deploy and run it

1. **Deploy `DealFilter.cls`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/DealFilter.cls --target-org desk-org
   ```

2. **Try it in anonymous Apex:**

   ```apex
   List<Decimal> deals = new List<Decimal>{ 180000, 45000, 95000, 120000 };
   System.debug('High-value deals: ' + DealFilter.filterHighValueAmounts(deals, 90000));
   System.debug('Total value: ' + DealFilter.sumAmounts(deals));
   ```

## What you should see

```
|USER_DEBUG|[2]|DEBUG|High-value deals: (95000, 120000, 180000)
|USER_DEBUG|[3]|DEBUG|Total value: 440000
```

**Your small task:** write a method `public static Integer countDealsAbove(List<Decimal> amounts, Decimal minimumAmount)` that returns how many deals meet the threshold (`filterHighValueAmounts(amounts, minimumAmount).size()`).
