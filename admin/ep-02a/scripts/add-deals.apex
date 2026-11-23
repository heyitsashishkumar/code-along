// Adds episode 2 part 1's two deals (opportunities) to the account Brookfield Water:
//   Brookfield Water - pumps     USD 50,000.00   Danny's deal
//   Pennine Pumps - Manchester   GBP 10,000.00   Tom's team's deal
// Both: Stage Prospecting, Close Date 15 December 2026.
// It needs multiple currencies on and GBP active, so deploy this folder first.
// It finds Brookfield Water by name, so it works in an org that already has it.
// A deal that already exists (same name) is skipped, so running it twice is safe.
// Run it from the ep-02a folder:
//   sf apex run --file scripts/add-deals.apex
List<Account> brookfield = [SELECT Id FROM Account WHERE Name = 'Brookfield Water' ORDER BY CreatedDate LIMIT 1];
if (brookfield.isEmpty()) {
    throw new IllegalArgumentException('No account called Brookfield Water. Load it first: sf data import tree --plan data/plan.json');
}
Map<String, Object[]> deals = new Map<String, Object[]>{
    'Brookfield Water - pumps' => new Object[]{ 'USD', 50000 },
    'Pennine Pumps - Manchester' => new Object[]{ 'GBP', 10000 }
};
Set<String> existing = new Set<String>();
for (Opportunity o : [SELECT Name FROM Opportunity WHERE Name IN :deals.keySet()]) {
    existing.add(o.Name);
}
List<Opportunity> toAdd = new List<Opportunity>();
for (String name : deals.keySet()) {
    if (existing.contains(name)) {
        System.debug('Already there, skipped: ' + name);
        continue;
    }
    Opportunity o = new Opportunity(
        Name = name,
        AccountId = brookfield[0].Id,
        StageName = 'Prospecting',
        CloseDate = Date.newInstance(2026, 12, 15),
        Amount = (Integer) deals.get(name)[1]
    );
    o.put('CurrencyIsoCode', (String) deals.get(name)[0]);
    toAdd.add(o);
}
insert toAdd;
System.debug('Added ' + toAdd.size() + ' deal(s)');
