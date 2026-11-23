# ep-02a · Manchester wants pounds

The finished org for **The Accidental Admin, episode 2, part 1**. Start the episode from [`ep-01`](../ep-01/); this folder is what your org looks like at the end of part 1. Part 2 (*While you're in there*) starts from here. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

> **Edition note:** your org is **Enterprise Edition** (since `ep-00`), so Tom, Lena, Danny and Diane can all be full Salesforce users later. Part 1's steps are the same in both editions: Company Information, Manage Currencies and the New Opportunity form.

> **One way only:** this folder turns on **multiple currencies**. Once it's on, it can never be switched off, in any org. That's fine in a scratch org, which is made to be thrown away. Never deploy this folder to a work org.

## What's in this folder

```
ep-02a/
  sfdx-project.json
  config/project-scratch-def.json      the same blueprint as ep-01
  force-app/main/default/
    permissionsets/Kestrel_Practice.permissionset-meta.xml
    settings/Currency.settings-meta.xml   multiple currencies, USD, GBP 0.79, EUR 0.92
  data/plan.json  data/Account.json    Kestrel's first customer (from ep-01)
  scripts/rename-admin-user.apex       renames you to Owen Hartley (from ep-01)
  scripts/add-deals.apex               the two deals of part 1
  README.md  TROUBLESHOOTING.md
```

## What changed in EP 2 part 1

- **Multiple currencies are on** (Setup, Quick Find `company`, Company Information, Edit, **Activate Multiple Currencies**). The corporate currency is **USD**, the U.S. dollar. In the video you tick the box. Here it's `settings/Currency.settings-meta.xml`, so deploying the folder turns it on. **It's permanent.**
- **Two more currencies** (Setup, Quick Find `currencies`, Manage Currencies, New): **GBP, British Pound, at 0.79** and **EUR, Euro, at 0.92**, each with 2 decimal places. These are example rates: one dollar buys 0.79 pounds or 0.92 euros. The same settings file adds them, so you don't type them.
- **Advanced currency management stays off** (the Enable button on Manage Currencies). The settings file says so too.
- **Two deals** (Sales app, Opportunities, New), both on the account Brookfield Water, both at Stage **Prospecting** with Close Date **15 December 2026**:
  - **Brookfield Water - pumps**: USD 50,000.00. Danny's deal.
  - **Pennine Pumps - Manchester**: GBP 10,000.00. Tom's team's deal, made in pounds with the new **Opportunity Currency** field.
- **Why a script for the deals:** deals are records, not metadata. They hang off Brookfield Water, an account your org already has, and `sf data import tree` can only link records it loads itself. So `scripts/add-deals.apex` makes them: it finds Brookfield Water by name, and skips a deal that's already there.
- **Not changed:** the Currency Locale on Company Information. In the video Owen switches it to pounds by mistake and straight back. That's watch-only. If you tried it, set it back to **English (United States) - USD**. Your own currency (your picture, Settings, Advanced User Details) stays **USD**. Part 2 sets Tom's and Lena's.
- **No new permissions:** `Kestrel_Practice` is the same as in `ep-01`.

## See the changes on GitHub

This folder was added in two commits: a plain copy of `ep-01` (`copy ep-01 to ep-02a`), then the episode's changes. Open EP 2 part 1's commit, **EP 2 part 1: multiple currencies, GBP and EUR, add-deals script, README and troubleshooting**, in the [folder's history](https://github.com/heyitsashishkumar/code-along/commits/main/admin/ep-02a): its page shows exactly what part 1 changed, green lines added, red lines removed.

To compare on your own computer: `git diff --no-index admin/ep-01 admin/ep-02a`.

## Deploy it

Do the one-time setup from the setup video first (Dev Hub, the CLI, `sf org login web --set-default-dev-hub --alias my-devhub` in your home folder, and this repo). Then pick a path.

**Two paths. Pick one.**

- **A new org:** create it from this folder, then deploy, assign, load, rename and add the deals, as below.
- **The org you already have** (your `kestrel` org from `ep-01`): see "The org you already have", further down.

For a **new org**, from this folder:

```bash
cd code-along/admin/ep-02a
sf org create scratch --definition-file config/project-scratch-def.json --alias kestrel --set-default --duration-days 30
sf project deploy start
sf org assign permset --name Kestrel_Practice
sf data import tree --plan data/plan.json
sf apex run --file scripts/rename-admin-user.apex
sf apex run --file scripts/add-deals.apex
sf org open
```

(For a ZIP download the first line is `cd Downloads/code-along-main/admin/ep-02a`.) In order: create the org, deploy the permission set and the currency settings (this turns on multiple currencies, with GBP and EUR), give yourself the permission set, load Brookfield Water, rename yourself to Owen Hartley, add the two deals, and open the org. Run them in this order: the deals need Brookfield Water and the currencies first. Run `sf data import tree` only once, or you'll get a second Brookfield Water.

Already have a `kestrel` org? A new one with the same alias takes over the name. Delete the old one first if you don't need it: `sf org delete scratch --target-org kestrel --no-prompt`.

### The org you already have

Your `kestrel` org is at the end of EP 1 and you skipped part 1's clicks, or want to check them. From **this** folder:

```bash
cd code-along/admin/ep-02a
sf config set target-org kestrel
sf project deploy start --ignore-conflicts
sf apex run --file scripts/add-deals.apex
```

- **`sf config set target-org kestrel`** tells the CLI which org to use **in this folder**. `--set-default` saved it only in the folder you created the org from, so without this line every command here stops with `No default environment found`. Do it once per folder.
- **Deploy** sends this folder. `--ignore-conflicts` is needed because each folder is its own project, so the CLI sees the org's earlier deploy as someone else's change. Without it, deploy stops with a `Conflict` error (see TROUBLESHOOTING.md). The table shows `Currency` (type `Settings`) as **Changed**: multiple currencies are now on, with GBP and EUR.
- **The deals script** is new in part 1, so run it. Don't run `sf data import tree` or the rename script: your org already has Brookfield Water and Owen Hartley from EP 1.

Already finished part 1 in your own org, by hand? You don't need to run anything here. Running the deploy and the script anyway is safe: they change nothing that's already right, and a deal that's already there is skipped.

## What you should see

- **Setup, Quick Find `currencies`, Manage Currencies:** "Advanced Currency Management is not enabled", and three Active Currencies: **EUR** Euro at **0.920000**, **GBP** British Pound at **0.790000**, and **USD** U.S. Dollar, ticked as Corporate, at **1.000000**, each with 2 decimal places.
- **Opportunities** has **Brookfield Water - pumps**, Amount **USD 50,000.00**, and **Pennine Pumps - Manchester**, Amount **GBP 10,000.00 (USD 12,658.23)**. The brackets are the same deal in your own currency: 10,000 ÷ 0.79. If the list is empty, search for `Brookfield` or `Pennine`: deals a script made aren't in Recently Viewed yet.
- **New opportunity form:** a field **Opportunity Currency** that wasn't there before. It starts at your own currency, USD.
- **Your picture, Settings, Advanced User Details:** Currency **USD - U.S. Dollar**.
- **The account Brookfield Water** and **Owen Hartley** as before. The time zone may still say Los Angeles: part 2 fixes it.
