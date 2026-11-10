public with sharing class StaleDealScheduler implements Schedulable {
    public static final String CRON_NIGHTLY_2AM = '0 0 2 * * ?';

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new StaleDealBatch(), 200);
    }
}
