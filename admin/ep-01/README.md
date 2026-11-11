# ep-01 · You're the Salesforce guy now

The finished org for **The Accidental Admin, episode 1**. Start the episode from [`ep-00`](../ep-00/); this folder is what your org looks like at the end. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

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

This folder was added in two commits: a plain copy of `ep-00` (`copy ep-00 to ep-01`), then the episode's changes (`EP 1: ...`). Open the [history of this folder](https://github.com/heyitsashishkumar/code-along/commits/main/admin/ep-01) and click the newest commit: its page shows exactly what EP 1 changed, green lines added.

To compare on your own computer: `git diff --no-index admin/ep-00 admin/ep-01`.

## Deploy it

Do the one-time setup from the setup video first (Dev Hub, the CLI, `sf org login web --set-default-dev-hub --alias my-devhub` in your home folder, and this repo). Already did the setup video's `ep-00`? Your org is the start of this episode: just do the episode's clicks. Otherwise, from this folder:

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

- **Accounts** lists **Brookfield Water** (phone (312) 555-0142) and **Sample Account for Entitlements**, which Salesforce makes itself.
- **The user menu** says **Owen Hartley**, with the **System Administrator** profile.
- **Setup, Quick Find `Company Information`:** the organization name says **Kestrel Industrial**. The user licenses show **Salesforce: 2 total, 1 used**.
- **Setup, Users:** four users: Chatter Expert, Integration User, Security User, and you.
- The time zone may still say Los Angeles. Episode 2 teaches time zones.
