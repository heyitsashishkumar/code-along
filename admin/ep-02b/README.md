# ep-02b · While you're in there

The finished org for **The Accidental Admin, episode 2, part 2**. Start the episode from [`ep-02a`](../ep-02a/); this folder is what your org looks like at the end of episode 2. Episode 3 (*Where does a pump live?*) starts from here. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

> **Edition note:** the video's org and yours are both **Enterprise Edition**, with **5 Salesforce licenses**. After this episode **3 are used**: you (Owen), Tom and Lena. The other two are for Danny and Diane, later.

> **One way only:** like `ep-02a`, this folder turns on **multiple currencies**, which can never be switched off. That's fine in a scratch org. Never deploy this folder to a work org.

> **Sharing, set off screen:** in this folder, the organization-wide defaults for **Account** and **Opportunity** are **Public Read Only** (Setup, Quick Find `sharing`, Sharing Settings). A new Enterprise Edition org starts them at **Private**, and then Tom, logged in as himself, can't open Danny's deal, because he doesn't own it. So we changed them in our org before recording, off screen, and this folder carries the change. Both, because Salesforce won't make Opportunity Public Read Only while Account is still Private. The default for external users stays **Private**. The video doesn't explain sharing: a later episode teaches it properly.

## What's in this folder

```
ep-02b/
  sfdx-project.json
  config/project-scratch-def.json      the same blueprint as ep-01
  force-app/main/default/
    permissionsets/Kestrel_Practice.permissionset-meta.xml
    settings/Currency.settings-meta.xml       from ep-02a
    settings/Company.settings-meta.xml        fiscal year from April
    settings/Security.settings-meta.xml       admins can log in as any user
    settings/BusinessHours.settings-meta.xml  Manchester Support Hours and a holiday
    objects/Account/Account.object-meta.xml   sharing: Public Read Only
    objects/Opportunity/Opportunity.object-meta.xml   sharing: Public Read Only
  data/plan.json  data/Account.json    Kestrel's first customer (from ep-01)
  scripts/rename-admin-user.apex       renames you to Owen Hartley (from ep-01)
  scripts/add-deals.apex               the two deals (from ep-02a)
  scripts/add-users.apex               Tom and Lena, and your own time zone
  README.md  TROUBLESHOOTING.md
```

## What changed in EP 2 part 2

- **The company's default time zone is Chicago** (Setup, Quick Find `company`, Company Information, Edit, Default Time Zone: **(GMT-06:00) Central Standard Time (America/Chicago)**). It was Los Angeles. **This one isn't in the folder:** no metadata type holds it, and the scratch org definition can't set it. One CLI command changes it instead (below), or do the clicks.
- **Your own time zone is Chicago too** (your picture, Settings, Advanced User Details, Edit, Time Zone). Changing the company's default doesn't move users who already exist. `scripts/add-users.apex` sets yours.
- **Two new users** (Setup, Quick Find `users`, Users, New User), both with User License **Salesforce** and Profile **Standard User**, each with their own Locale Settings:
  - **Tom Ashworth**: Time Zone **(GMT+00:00) Greenwich Mean Time (Europe/London)**, Locale **English (United Kingdom)**, Language **English**, Currency **GBP - British Pound**.
  - **Lena Vogel**: Time Zone **(GMT+01:00) Central European Standard Time (Europe/Berlin)**, Locale **German (Germany)**, Language **English**, Currency **EUR - Euro**.
- **Why a script for the users:** users are records, not metadata, so `scripts/add-users.apex` makes them. A username must be unique across every Salesforce org in the world, so the script makes one up for each, like the video's: `tom.ashworth.` plus a random number, then `@kestrel.example` (Lena gets the same number). It prints both usernames. Their emails, `tom.ashworth@example.com` and `lena.vogel@example.com`, are made up: `example.com` is reserved for examples, so no mail reaches anyone, and the script sends no welcome email. You never need their passwords: you log in as them from the Users list. Marketing User stays unticked.
- **Login Access Policies:** **Administrators Can Log in as Any User** is ticked (Setup, Quick Find `login access`). It's `settings/Security.settings-meta.xml`. That's what puts a **Login** link next to Tom and Lena in the Users list.
- **Fiscal year:** a **Standard Fiscal Year** that starts in **April**, named by **the ending month** (Setup, Quick Find `fiscal`, Fiscal Year). It's `settings/Company.settings-meta.xml`. April 2026 to March 2027 is FY 2027.
- **Business hours:** **Manchester Support Hours**, active, Time Zone **Europe/London**, Monday to Friday **8:00 AM to 6:00 PM**, Saturday and Sunday closed (Setup, Quick Find `business hours`). The org's **Default** business hours don't change: 24 hours a day, every day, on Los Angeles time. Both are in `settings/BusinessHours.settings-meta.xml`, because Salesforce wants the default listed there too.
- **A holiday:** **Spring Bank Holiday**, **31 May 2027**, all day, linked to Manchester Support Hours (Setup, Quick Find `holidays`). The same settings file holds it.
- **Sharing:** Account and Opportunity default internal access **Public Read Only**, default external access **Private** (`objects/Account/` and `objects/Opportunity/`). Set off screen: see the note at the top.
- **Not changed:** the currencies, the deals and Brookfield Water from part 1, and `Kestrel_Practice` (no new permissions).

Two of these can't be undone: business hours can't be deleted (only deactivated), and multiple currencies stay on. Both are fine in a scratch org.

## See the changes on GitHub

This folder was added in two commits: a plain copy of `ep-02a` (`copy ep-02a to ep-02b`), then the episode's changes. Open EP 2 part 2's commit, **EP 2 part 2: time zones, Tom and Lena, login access, fiscal year, business hours, sharing**, in the [folder's history](https://github.com/heyitsashishkumar/code-along/commits/main/admin/ep-02b): its page shows exactly what part 2 changed, green lines added, red lines removed.

To compare on your own computer: `git diff --no-index admin/ep-02a admin/ep-02b`. To see all of episode 2: `git diff --no-index admin/ep-01 admin/ep-02b`.

## Deploy it

Do the one-time setup from the setup video first (Dev Hub, the CLI, `sf org login web --set-default-dev-hub --alias my-devhub` in your home folder, and this repo). Then pick a path.

**Two paths. Pick one.**

- **A new org:** create it from this folder, then deploy, assign, load, run the three scripts and set the time zone, as below.
- **The org you already have** (your `kestrel` org from `ep-02a`): see "The org you already have", further down.

For a **new org**, from this folder:

```bash
cd code-along/admin/ep-02b
sf org create scratch --definition-file config/project-scratch-def.json --alias kestrel --set-default --duration-days 30
sf project deploy start
sf org assign permset --name Kestrel_Practice
sf data import tree --plan data/plan.json
sf apex run --file scripts/rename-admin-user.apex
sf apex run --file scripts/add-deals.apex
sf apex run --file scripts/add-users.apex
sf data update record --sobject Organization --where "Name='Kestrel Industrial'" --values "TimeZoneSidKey=America/Chicago"
sf org open
```

(For a ZIP download the first line is `cd Downloads/code-along-main/admin/ep-02b`.) In order:

1. **Create** the org.
2. **Deploy** everything in `force-app/`: the permission set, multiple currencies with GBP and EUR, the fiscal year, the login policy, the business hours and holiday, and the sharing. The table lists 7 rows.
3. **Assign** the permission set to yourself.
4. **Load** Brookfield Water. Only once, or you'll get a second one.
5. **Rename** yourself to Owen Hartley.
6. **Add the deals**: Brookfield Water - pumps and Pennine Pumps - Manchester. They need the deploy and Brookfield Water first.
7. **Add the users**: Tom and Lena, and your own time zone. Among the lines it prints are `Added Tom Ashworth, username tom.ashworth.` followed by your number and `@kestrel.example`, and the same for Lena.
8. **Set the company's default time zone** to Chicago. `sf data update record` changes one record, here the one Organization record that holds Company Information, found by its name, Kestrel Industrial. It prints `Successfully updated record:` and your org's ID. Prefer clicking? Setup, Quick Find `company`, Company Information, Edit, Default Time Zone **(GMT-06:00) Central Standard Time (America/Chicago)**, Save.
9. **Open** the org.

Already have a `kestrel` org? A new one with the same alias takes over the name. Delete the old one first if you don't need it: `sf org delete scratch --target-org kestrel --no-prompt`.

### The org you already have

Your `kestrel` org is at the end of part 1 (`ep-02a`). From **this** folder:

```bash
cd code-along/admin/ep-02b
sf config set target-org kestrel
sf project deploy start --ignore-conflicts
sf apex run --file scripts/add-users.apex
sf data update record --sobject Organization --where "Name='Kestrel Industrial'" --values "TimeZoneSidKey=America/Chicago"
```

- **`sf config set target-org kestrel`** tells the CLI which org to use **in this folder**. Without it every command here stops with `No default environment found`. Do it once per folder.
- **Deploy** with `--ignore-conflicts`, because each folder is its own project (without it, deploy stops with a `Conflict` error). It brings the fiscal year, the login policy, the business hours and holiday, and the sharing.
- **The users script** and **the time zone command** are new in part 2, so run them. Don't run `sf data import tree`, the rename script or the deals script: your org already has those from EP 1 and part 1.

Did part 2 by hand, with the video? Still run the deploy: it carries the **sharing** change the video doesn't show, so Tom can open Danny's deal. Everything else you did by hand stays as it is: the deploy finds Manchester Support Hours and Spring Bank Holiday by name, and the users script skips Tom and Lena if they're already there. Your own Tom and Lena keep the usernames you gave them.

## What you should see

- **Setup, Company Information:** Default Time Zone **(GMT-06:00) Central Standard Time (America/Chicago)** (in summer it says Central Daylight Time). Under User Licenses, the **Salesforce** row: Total Licenses **5**, Used Licenses **3**, Remaining Licenses **2**.
- **Your picture, Settings, Advanced User Details:** Time Zone **(GMT-06:00) Central Standard Time (America/Chicago)**, Currency **USD - U.S. Dollar**.
- **Setup, Users:** **Tom Ashworth** and **Lena Vogel** among the users, each with a **Login** link next to their name. Open one to see their Locale Settings, as listed above.
- **Login, next to Tom Ashworth:** a banner says **Logged in as Tom Ashworth**. Open **Brookfield Water - pumps** (search for `Brookfield` if the list is empty): Amount **USD 50,000.00 (GBP 39,500.00)**, and the Close Date written day first, **15/12/2026**. Click **New**: Opportunity Currency already says **GBP - British Pound**. Cancel, then **Log out as Tom Ashworth** at the top.
- **Setup, Fiscal Year:** Standard Fiscal Year, Fiscal Year Start Month **April**, Fiscal Year is Based On **The ending month**.
- **Setup, Business Hours:** two rows: **Default**, (GMT-08:00) Pacific Standard Time (America/Los_Angeles), and **Manchester Support Hours**, (GMT+00:00) Greenwich Mean Time (Europe/London). Open Manchester's: Monday to Friday 8:00 AM to 6:00 PM, nothing on Saturday and Sunday.
- **Setup, Holidays:** **Spring Bank Holiday** on **5/31/2027** (your locale writes the month first), All Day, with **Manchester Support Hours** in its Business Hours list.
- **Setup, Sharing Settings:** Account and Opportunity: Default Internal Access **Public Read Only**, Default External Access **Private**.
