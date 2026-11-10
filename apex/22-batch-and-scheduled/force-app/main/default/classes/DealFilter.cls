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
