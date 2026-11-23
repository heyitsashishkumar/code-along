# The Accidental Admin

The code for **The Accidental Admin**, the Salesforce administrator series. You follow Owen Hartley, who is made solely responsible for his company's Salesforce rollout, and you do everything he does in an org of your own. Kestrel Industrial and everyone in it are made up.

## The folders

Each folder is Kestrel's practice org **at the end of one episode**, as a complete Salesforce DX project: `sfdx-project.json`, `config/project-scratch-def.json`, the org's metadata in `force-app/`, a `README.md` (what changed, how to deploy it, what you should see) and a `TROUBLESHOOTING.md`.

| Folder | State of the org | Video |
|---|---|---|
| [ep-00](ep-00/) | Kestrel's empty org: the scratch definition and the `Kestrel_Practice` permission set, nothing an episode adds | The setup video: your own free practice org |
| [ep-01](ep-01/) | Same metadata as `ep-00`, plus the account Brookfield Water (in `data/`) and a script that renames you to Owen Hartley | Episode 1: You're the Salesforce guy now |
| [ep-02a](ep-02a/) | Multiple currencies on (USD corporate, GBP 0.79, EUR 0.92, in `settings/`), plus a script that adds two deals to Brookfield Water | Episode 2, part 1: Manchester wants pounds |

More folders are added as each episode is recorded. Episode 2 comes in two parts, so it has two folders, `ep-02a` and `ep-02b`.

## Start any episode

Episode N starts from the folder of episode N-1. For episode 1, that's `ep-00`.

1. Do the one-time setup from the setup video: a free hands-on org from Trailhead (a Trailhead Playground, which is a Developer Edition) with Dev Hub turned on, the Salesforce CLI, `sf org login web --set-default-dev-hub --alias my-devhub` in your home folder, and this repo.
2. Go into the folder of the episode **before** the one you want, for example `cd code-along/admin/ep-00` to start episode 1.
3. Pick one path. **A new org:** create it from that folder, then deploy, assign, load (only if the folder has `data/`), run any script and open, as that folder's README shows. **The org you already have:** from the new folder, first run `sf config set target-org kestrel` (the default org is saved per folder, so a new folder doesn't know it yet), then `sf project deploy start --ignore-conflicts`, then load and run scripts only if that folder's README says they're new in this episode. Each folder is its own project, so the CLI sees the org's earlier deploy as someone else's change. Without the flag, deploy stops with a `Conflict` error.
4. Do the episode's clicks yourself, in your own scratch org.

Behind, or your org expired? Build a fresh one from the folder of the last episode you finished. Delete the old one first, to free its slot: `sf org delete scratch --target-org kestrel --no-prompt`.

## See what an episode changed

Each folder's README lists every change with its path in Setup. From `ep-01` on, each folder is added to GitHub in two commits, a plain copy of the folder before it and then the episode's changes, so the second commit's page shows exactly what changed: green lines added, red lines removed. On your own computer, `git diff --no-index ep-01 ep-02a` shows the same.

## Stuck?

Every folder has a `TROUBLESHOOTING.md` with each error from its video: the exact message, why it happens, and the fix. If yours isn't there, paste the exact error in the video's comments and say whether you're on Windows or Mac.
