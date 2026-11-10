public with sharing class DeskEventService {
    public static final Decimal DEFAULT_HIGH_VALUE_THRESHOLD = 100000;

    @TestVisible
    private static Decimal testThresholdOverride;

    public static Decimal getHighValueThreshold() {
        if (testThresholdOverride != null) {
            return testThresholdOverride;
        }
        // When a Custom Metadata Type (e.g. Desk_Rule__mdt) is defined,
        // Desk_Rule__mdt.getInstance('Default')?.High_Value_Threshold__c
        // reads from the application cache using 0 SOQL queries!
        return DEFAULT_HIGH_VALUE_THRESHOLD;
    }

    public static List<Task> publishHighValueAlerts(List<Opportunity> deals) {
        List<Task> alerts = new List<Task>();
        if (deals == null || deals.isEmpty()) {
            return alerts;
        }
        Decimal threshold = getHighValueThreshold();
        for (Opportunity deal : deals) {
            if (
                deal.StageName == 'Closed Won' &&
                deal.Amount != null &&
                deal.Amount >= threshold &&
                deal.AccountId != null
            ) {
                alerts.add(
                    new Task(
                        WhatId = deal.AccountId,
                        Subject = 'High-value deal won: ' + deal.Name,
                        Description = 'Amount: INR ' + deal.Amount,
                        Status = 'Not Started',
                        Priority = 'High',
                        ActivityDate = Date.today()
                    )
                );
            }
        }
        if (!alerts.isEmpty()) {
            insert as user alerts;
        }
        return alerts;
    }
}
