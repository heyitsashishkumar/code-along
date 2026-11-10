trigger OpportunityTrigger on Opportunity (
    before insert,
    before update,
    after insert,
    after update,
    after delete,
    after undelete
) {
    if (Trigger.isBefore) {
        OpportunityTriggerHandler.beforeSave(Trigger.new);
    }
    if (Trigger.isAfter) {
        OpportunityTriggerHandler.afterChange(Trigger.new, Trigger.old);
    }
}
