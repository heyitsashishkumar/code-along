# ep-00 · Kestrel's empty org

The starting folder for **The Accidental Admin**, and the one the setup video (*Your Own Free Practice Org, Step by Step*) deploys. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

Every folder in `admin/` is Kestrel Industrial's practice org **at the end of one episode**. `ep-00` is the org before episode 1: nothing has been built yet. Episode 1 starts from here, and episode N starts from `ep-(N-1)`.

> **Edition note:** the videos show **Developer Edition** and Salesforce licenses **"2 total, 1 used"**. Your org shows **Enterprise Edition** and **5 total**. We switched to Enterprise so Tom, Lena, Danny and Diane can all be full Salesforce users later. Your free org that builds the scratch org is still a Developer Edition. Everything else in this folder is the same.

## What's in this folder

```
ep-00/
  sfdx-project.json                  the project file the CLI looks for
  config/project-scratch-def.json    the blueprint for the scratch org
  force-app/main/default/
    permissionsets/Kestrel_Practice.permissionset-meta.xml
  README.md  TROUBLESHOOTING.md
```

- **`config/project-scratch-def.json`** is the blueprint file. It says: an Enterprise Edition org called **Kestrel Industrial**, country US, language English (US), no sample data, and two settings that match the videos' screens. It has no email address in it, so Salesforce sends any verification code to **your** email.
- **`Kestrel_Practice`** is a permission set (label **Kestrel Practice**). A permission set gives access. It's empty today. Each later folder adds access to what that episode builds (objects, fields, tabs, apps), so you can see everything you make.
- There's no `data/` folder yet, because there are no records to load. Brookfield Water, Kestrel's first customer, arrives in `ep-01`.

## What changed in this episode

Nothing. This is the starting point, so there's nothing to compare it with. From `ep-01` on, each folder's README lists every change with its path in Setup, and links to the change on GitHub: green lines were added, red lines were removed.

## See the changes on GitHub

Not for `ep-00` (it's the first folder). From `ep-01` on, each folder is added in two commits: a plain copy of the folder before it, then the episode's changes. The second commit's page on GitHub shows exactly what that episode changed.

## Deploy it

**Two paths. Pick one.**

- **A new org:** create it from this folder, then deploy, assign, load and rename, as below.
- **The org you already have** (from an earlier folder): go into this folder and run `sf project deploy start --ignore-conflicts`. Then load data and run scripts **only** if this folder's README says they're new in this episode. Each folder is its own project, so the CLI sees the org's earlier deploy as someone else's change. Without `--ignore-conflicts`, deploy stops with a `Conflict` error (see TROUBLESHOOTING.md).

Do the one-time steps from the setup video first: a free Developer Edition org with **Dev Hub** turned on, the Salesforce CLI, `sf org login web --set-default-dev-hub --alias my-devhub` (in your home folder), and this repo.

Then go into the folder. If you used `git clone`:

```bash
cd code-along/admin/ep-00
```

If you downloaded the ZIP (Code, then Download ZIP, then unzip), the folder is called `code-along-main`:

```bash
cd Downloads/code-along-main/admin/ep-00
```

Tip: type `cd` and a space, then drag the `ep-00` folder into the terminal. It types the path for you. On Windows, unzipping can make a folder inside a folder: open them until you see `admin`.

Now the five commands, in order:

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias kestrel --set-default --duration-days 30
sf project deploy start
sf org assign permset --name Kestrel_Practice
sf data import tree --plan data/plan.json
sf org open
```

- **Create** takes a minute or so and ends with `Your scratch org is ready.` `--duration-days 30` is the longest allowed. Leave it off and the org is deleted after 7 days.
- **Deploy** sends this folder into your scratch org. You'll see a table called **Deployed Source** with one row, `Kestrel_Practice`.
- **Assign** gives you the permission set. You'll see a table called **Permsets Assigned**.
- **Load: skip it in `ep-00`.** There's no `data/plan.json` here, so the command would say `No file found at data/plan.json`. From `ep-01` on, run it when the folder has a `data/` folder.
- **Open** opens your scratch org in the browser, already logged in.

Run create, deploy, assign and open **inside this folder**. `--set-default` saves your scratch org as the default for this folder only. Later, to get back in from any folder:

```bash
sf org open --target-org kestrel
```

On Windows the commands are the same in PowerShell or Command Prompt.

## What you should see

- **Setup, then Company Information:** the organization name says **Kestrel Industrial**.
- **The user menu** (your picture, top right) says **User User**. That's you: a new scratch org names its first user that. You'll rename yourself in episode 1.
- **Time zone:** Company Information may say **Pacific Time (America/Los_Angeles)**. That's normal. The definition file can't set a time zone, and episode 2 has you change it.
- **Accounts:** one account, **Sample Account for Entitlements**, that Salesforce makes itself. No Brookfield Water yet.
- **Permission sets** (Setup, then Permission Sets): **Kestrel Practice**, assigned to you.

## Start again

When your org expires after 30 days, or you get lost, delete it and build a fresh one from the folder of the last episode you finished:

```bash
sf org delete scratch --target-org kestrel --no-prompt
sf org list
```

`sf org list` shows your orgs and when each one expires.

## Versions

The project's `sourceApiVersion` is `68.0`. Recorded with Salesforce CLI 2.138.6 and later. Newer versions should work the same way. If a step looks different on your screen, paste what you see in the video's comments, and say Mac or Windows.
