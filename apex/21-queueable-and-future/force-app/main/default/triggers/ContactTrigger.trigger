trigger ContactTrigger on Contact (before insert, before update) {
    for (Contact customer : Trigger.new) {
        if (String.isBlank(customer.LeadSource)) {
            customer.LeadSource = 'Web';
        }
        if (String.isBlank(customer.MailingCountry)) {
            customer.MailingCountry = 'India';
        }
    }
}
