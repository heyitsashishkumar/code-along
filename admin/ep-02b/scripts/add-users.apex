// Episode 2 part 2's people, as records (users aren't metadata):
//   1. Your own time zone (the user running this script, Owen Hartley) becomes Chicago.
//   2. Two new users, each with a Salesforce user license and the Standard User profile:
//      Tom Ashworth  London (Europe/London), English (United Kingdom) locale, English, GBP
//      Lena Vogel    Berlin (Europe/Berlin), German (Germany) locale, English, EUR
// A username must be unique across every Salesforce org in the world, so the script makes one up:
// tom.ashworth.<a random number>@kestrel.example (and the same number for Lena). It tries a new
// number if one is taken. Their emails, tom.ashworth@example.com and lena.vogel@example.com, are
// made up: example.com is reserved for examples, so no mail reaches a real person, and the script
// sends no welcome email anyway.
// A user who already exists (same first and last name) is skipped, so running it twice is safe.
// Run it from the ep-02b folder:
//   sf apex run --file scripts/add-users.apex

// 1. Your own time zone
User me = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
me.TimeZoneSidKey = 'America/Chicago';
update me;
System.debug('Your time zone: America/Chicago');

// 2. Tom and Lena
List<Map<String, String>> people = new List<Map<String, String>>{
    new Map<String, String>{ 'first' => 'Tom', 'last' => 'Ashworth', 'alias' => 'tashw',
        'tz' => 'Europe/London', 'locale' => 'en_GB', 'currency' => 'GBP' },
    new Map<String, String>{ 'first' => 'Lena', 'last' => 'Vogel', 'alias' => 'lvoge',
        'tz' => 'Europe/Berlin', 'locale' => 'de_DE', 'currency' => 'EUR' }
};
List<Map<String, String>> toAdd = new List<Map<String, String>>();
for (Map<String, String> p : people) {
    Integer found = [SELECT COUNT() FROM User WHERE FirstName = :p.get('first') AND LastName = :p.get('last')];
    if (found > 0) {
        System.debug('Already there, skipped: ' + p.get('first') + ' ' + p.get('last'));
    } else {
        toAdd.add(p);
    }
}
if (toAdd.isEmpty()) {
    return;
}

UserLicense sf = [SELECT TotalLicenses, UsedLicenses FROM UserLicense WHERE Name = 'Salesforce'];
if (sf.TotalLicenses - sf.UsedLicenses < toAdd.size()) {
    throw new IllegalArgumentException('Not enough Salesforce licenses: ' + (sf.TotalLicenses - sf.UsedLicenses)
        + ' left, ' + toAdd.size() + ' needed. Setup, Company Information, User Licenses shows them.');
}
Id standardUser = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id;

Database.DMLOptions noEmail = new Database.DMLOptions();
noEmail.EmailHeader.triggerUserEmail = false;

for (Integer attempt = 1; attempt <= 3; attempt++) {
    String n = String.valueOf(Math.abs(Crypto.getRandomLong())).left(8);
    List<User> users = new List<User>();
    for (Map<String, String> p : toAdd) {
        String name = p.get('first').toLowerCase() + '.' + p.get('last').toLowerCase();
        User u = new User(
            FirstName = p.get('first'),
            LastName = p.get('last'),
            Email = name + '@example.com',
            Username = name + '.' + n + '@kestrel.example',
            Alias = p.get('alias'),
            CommunityNickname = name + '.' + n,
            ProfileId = standardUser,
            TimeZoneSidKey = p.get('tz'),
            LocaleSidKey = p.get('locale'),
            LanguageLocaleKey = 'en_US',
            EmailEncodingKey = 'UTF-8'
        );
        // Multiple currencies are on since part 1: the user's own currency, and the user record's.
        u.put('DefaultCurrencyIsoCode', p.get('currency'));
        u.put('CurrencyIsoCode', p.get('currency'));
        u.setOptions(noEmail);
        users.add(u);
    }
    try {
        insert users;
        for (User u : users) {
            System.debug('Added ' + u.FirstName + ' ' + u.LastName + ', username ' + u.Username);
        }
        return;
    } catch (DmlException e) {
        if (e.getDmlType(0) != StatusCode.DUPLICATE_USERNAME || attempt == 3) {
            throw e;
        }
        System.debug('Username taken, trying another number');
    }
}
