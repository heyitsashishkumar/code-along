# Troubleshooting · ep-01 · You're the Salesforce guy now

The traps in episode 1 come first. Below them are the setup video's errors, with the exact messages, copied from a real terminal (Salesforce CLI 2.138.6). The video was made on a Mac. Nothing was tested on Windows, so a Windows message is described here, never quoted. If yours isn't listed, paste the exact error in the video's comments and say whether you're on Windows or Mac.

## My screen doesn't look like the video's tabs

The tabs along the top change with the **app**. The video uses an app whose name is at the **top left**, next to the grid icon. If your tabs differ, click the grid icon (the App Launcher) and pick the same app, or search for what you need, for example **Accounts**.

## Setup opened in a new tab

Clicking the gear, then **Setup**, opens Setup in a **new browser tab**. That's normal. Your first tab is still there. Close the Setup tab, or click back to the first one.

## My user is called "User User"

A new scratch org names its first user **User User**. Episode 1 renames you to **Owen Hartley** (Setup, Quick Find `Users`, Users, Edit). In a hurry, run the script: from this folder, `sf apex run --file scripts/rename-admin-user.apex`. It renames whoever runs it, so it needs no username.

## Accounts also shows "Sample Account for Entitlements"

Salesforce makes that account itself in every new org, even with sample data off. It's not yours and it's not a mistake. Leave it alone.

## The license numbers don't match the video

The video shows **Salesforce: 2 total, 1 used** (Setup, Company Information, User Licenses). You'll see that in a fresh scratch org from this definition file. The used count goes up when you add users, and the totals differ in another edition.

## The Users list has four users, not just me

Setup, then Users, lists **Chatter Expert**, **Integration User**, **Security User** and you. The other three are made by Salesforce, and none of them uses one of your two Salesforce licenses. Don't deactivate them.

## I have two Brookfield Water accounts

You created Brookfield Water by hand and then ran `sf data import tree --plan data/plan.json`, or you ran the import twice. Open **Accounts**, open the extra one, and delete it (the arrow next to Edit, then Delete). Load it only once.

## "command not found: sf"

You type `sf --version` and get:

```
zsh: command not found: sf
```

- **Why:** the terminal was opened before you installed the Salesforce CLI. It still has the old list of places to look for programs (the PATH), so it doesn't know `sf` yet.
- **Fix:** close that terminal and open a new one, then run `sf --version` again. It prints a version, for example `@salesforce/cli/2.138.6 darwin-arm64 node-v20.20.2`. Yours may be newer.
- **On Windows** you'll see a similar message (a "not recognized" error). The fix is the same: close every PowerShell window, Command Prompt and VS Code, then open them again.
- Still not found? Install the CLI one way only. Installing it with the installer **and** with npm leads to confusing path problems.

## "The specified org ... is not a Dev Hub."

Creating the scratch org fails with a message that ends: `is not a Dev Hub.`

- **Why:** the org you logged in to isn't a Dev Hub. Either you haven't turned Dev Hub on (Setup, Quick Find, **Dev Hub**, turn on **Enable Dev Hub**), or you logged in to a different org.
- **Fix:** turn Dev Hub on in your free Developer Edition org, then log in again from your home folder: `sf org login web --set-default-dev-hub --alias my-devhub`.
- No **Dev Hub** in Quick Find? Then you're not in your free Developer Edition org. Salesforce's guide says Dev Hub can't be turned on in a sandbox.
- Once Dev Hub is on, it can't be turned off. That's fine in a practice org. At work, ask first.

## "No default dev hub found"

Creating the scratch org fails with:

```
Error (NoDefaultDevHubError): No default dev hub found. Use -v or --target-dev-hub to specify an environment.
```

- **Why:** the CLI doesn't know which org is your Dev Hub. You haven't logged in with `--set-default-dev-hub`, or you did it inside a project folder, where it's saved for that one folder only.
- **Fix:** go back to your home folder and connect again: `sf org login web --set-default-dev-hub --alias my-devhub`. Then go into the episode's folder and run the create command again.

## "No file found at config/project-scratch-def.json"

Creating the scratch org fails with:

```
Error (2): Parsing --definition-file
	No file found at config/project-scratch-def.json
```

- **Why:** you're not inside the episode's folder, so there's no `config/` here. (This one fails before any org is made.)
- **Fix:** `cd` into the folder, for example `cd code-along/admin/ep-00`, then run the command again. `ls` (or `dir` on Windows) should list `config`, `force-app` and `sfdx-project.json`.

## "No default environment found"

`sf project deploy start`, `sf org assign permset` or `sf org open` fails with:

```
Error (NoDefaultEnvError): No default environment found. Use -o or --target-org to specify an environment.
```

- **Why:** you're outside the episode's folder. `--set-default` saved your scratch org as the default for **that folder only**, so everywhere else the CLI has no default org.
- **Fix:** go back into the episode's folder and run it again. Or name the org: `sf project deploy start --target-org kestrel`.
- `sf org open --target-org kestrel` works from any folder.

## "reached its active scratch org limit"

Creating the scratch org fails with a message like:

```
The signup request failed because this organization has reached its active scratch org limit
```

- **Why:** a free Developer Edition Dev Hub keeps only a few scratch orgs at a time (Salesforce's guide says a maximum of three active; yours may allow more). An old org of yours is still counting.
- **Fix:** run `sf org list`, then delete one you don't need: `sf org delete scratch --target-org <alias> --no-prompt`. An org that has expired can keep counting for a while. If it still fails, wait a day: the daily allowance is a rolling 24 hours.

## "Duplicate PermissionSetAssignment"

Running `sf org assign permset --name Kestrel_Practice` a second time prints a table called **Failures** with `Duplicate PermissionSetAssignment`.

- **Why:** you already have that permission set. It isn't a problem.
- **Fix:** nothing to do. Carry on.

## "No file found at data/plan.json"

Running `sf data import tree --plan data/plan.json` fails with `No file found at data/plan.json`.

- **Why:** the folder has no records to load. `ep-00` has none. Skip that step.
- **Fix:** none needed. If a later folder does have `data/` and you still see it, you're not in that folder (see "No file found" above).

## Other things that aren't errors

- **"Warning: @salesforce/cli update available"** is only a hint that a newer CLI exists. Nothing breaks.
- **"No changes to deploy"** means the org already has everything in the folder. Running `sf project deploy start` twice is safe.
- **`sf org open`** prints "Waiting to resolve the Lightning Experience-enabled custom domain..." for a few seconds before the browser opens.
- A new scratch org's first user is named **User User**, and its time zone may say Los Angeles. Both are normal.

## Behind a college or office network

If the browser login never comes back to the terminal on a college or office network, a proxy may be blocking it. Salesforce's install guide says to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables to your proxy's address. We haven't reproduced this one ourselves. Ask your network admin for the proxy address.

## Sign-up: the username isn't your email

- The free Developer Edition sign-up asks for your name, job title, company, country and **your email**. You can't choose a username. Salesforce makes one for you and shows it in the welcome email.
- The username **looks like an email address, but it isn't your inbox**. Log in with that username, not with your own email.
- Open the welcome email, click its button and set a password. Write down the username and the password in a password manager, never on a sticky note.
- Can't find the email? Check spam, and check that you typed an address you can open.

## Your free org can be deleted after 45 days

Salesforce deletes a free Developer Edition org that nobody has logged into for **45 days**. It emails you first. Logging in during the first 14 days after the warning brings the org back. Your Dev Hub is that free org, so log in at least once a month. If it's gone, sign up for a new one and do steps two to four of the setup video again.
