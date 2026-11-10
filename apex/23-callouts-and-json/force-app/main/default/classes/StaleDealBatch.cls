public with sharing class StaleDealBatch implements Database.Batchable<SObject>, Database.Stateful {
    public Integer dealsFlagged = 0;

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Name, StageName, CloseDate, Description
            FROM Opportunity
            WHERE IsClosed = false AND CloseDate < TODAY
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope) {
        List<Opportunity> toUpdate = new List<Opportunity>();
        for (Opportunity deal : scope) {
            deal.Description = 'Stale deal: past close date';
            toUpdate.add(deal);
            this.dealsFlagged++;
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('StaleDealBatch finished. Flagged deals: ' + this.dealsFlagged);
    }
}
