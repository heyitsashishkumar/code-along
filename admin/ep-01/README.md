# ep-01 · You're the Salesforce guy now

The finished org for **The Accidental Admin, episode 1**. Start the episode from [`ep-00`](../ep-00/); this folder is what your org looks like at the end. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

> **Edition note:** the videos show **Developer Edition** and Salesforce licenses **"2 total, 1 used"**. Your org shows **Enterprise Edition** and **5 total**. We switched to Enterprise so Tom, Lena, Danny and Diane can all be full Salesforce users later. Your free org that builds the scratch org is still a Developer Edition. Everything else in EP 1 is the same.

## What's in this folder

```
ep-01/
  sfdx-project.json
  config/project-scratch-def.json     the same blueprint as ep-00
  force-app/main/default/permissionsets/Kestrel_Practice.permissionset-meta.xml
  data/plan.json  data/Account.json   Kestrel's first customer
  scripts/rename-admin-user.apex      renames you to Owen Hartley
  README.md  TROUBLESHOOTING.md
```

## What changed in EP 1

- **No metadata changed.** The episode is a tour of Setup, the app, the Object Manager and the user list, so `force-app/` is identical to `ep-00`.
- **One record:** the account **Brookfield Water**, phone **(312) 555-0142**. In the video you create it by hand (App Launcher, Accounts, New). Here it's in `data/`, so you can load it instead. Find it in the app under **Accounts**.
- **One user change:** your admin user is renamed from **User User** to **Owen Hartley** (Setup, Quick Find `Users`, Users, Edit). It's a record, not metadata, so `scripts/rename-admin-user.apex` does it.

## See the changes on GitHub

This folder was added in two commits: a plain copy of `ep-00` (`copy ep-00 to ep-01`), then the episode's changes. Open EP 1's commit, [EP 1: Brookfield Water in data/, rename-admin-user script, README and troubleshooting](https://github.com/heyitsashishkumar/code-along/commit/043bc321f2cf2162f71012c0fc0a36b135a27efe): its page shows exactly what EP 1 changed, green lines added. (Later commits in the [folder's history](https://github.com/heyitsashishkumar/code-along/commits/main/admin/ep-01) are fixes to the docs and the definition, not the episode.)

To compare on your own computer: `git diff --no-index admin/ep-00 admin/ep-01`.

## Deploy it

Do the one-time setup from the setup video first (Dev Hub, the CLI, `sf org login web --set-default-dev-hub --alias my-devhub` in your home folder, and this repo). Then pick a path.

**Two paths. Pick one.**

- **A new org:** create it from this folder, then deploy, assign, load and rename, as below.
- **The org you already have** (from an earlier folder): go into this folder and run `sf project deploy start --ignore-conflicts`. Then load data and run scripts **only** if this folder's README says they're new in this episode (in `ep-01`, that's the data and the rename script, and they're new). Each folder is its own project, so the CLI sees the org's earlier deploy as someone else's change. Without `--ignore-conflicts`, deploy stops with a `Conflict` error (see TROUBLESHOOTING.md).

For a **new org**, from this folder:

```bash
cd code-along/admin/ep-01
sf org create scratch --definition-file config/project-scratch-def.json --alias kestrel --set-default --duration-days 30
sf project deploy start
sf org assign permset --name Kestrel_Practice
sf data import tree --plan data/plan.json
sf apex run --file scripts/rename-admin-user.apex
sf org open
```

(For a ZIP download the first line is `cd Downloads/code-along-main/admin/ep-01`.) In order: create the org, deploy the permission set, give it to yourself, load Brookfield Water, rename yourself to Owen Hartley, and open the org. The rename script needs no username: it renames whoever runs it. Run `sf data import tree` only once, or you'll get a second Brookfield Water.

Already finished EP 1 in your own org? You don't need to run anything here.

## What you should see

- **Accounts** has **Brookfield Water** (phone (312) 555-0142) and **Sample Account for Entitlements**, which Salesforce makes itself. In a brand-new org there's no **All Accounts** list to choose yet: search for each by name (for example `Sample`).
- **The user menu** says **Owen Hartley**, with the **System Administrator** profile.
- **Setup, Quick Find `Company Information`:** the organization name says **Kestrel Industrial**, and the edition says **Enterprise Edition**. The user licenses show **Salesforce: 5 total, 1 used** (the video says 2 total: see the edition note at the top).
- **Setup, Users:** four users: Chatter Expert, Integration User, Security User, and you.
- The time zone may still say Los Angeles. Episode 2 teaches time zones.
