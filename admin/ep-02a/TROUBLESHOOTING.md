# Troubleshooting · ep-02a · Manchester wants pounds

The traps in episode 2, part 1 come first, then the errors from moving an org you already have to this folder. Below them are episode 1's traps and the setup video's errors, because a new org from this folder runs the same steps. The setup video's messages were copied from a real terminal (Salesforce CLI 2.158.7); the ones new in this folder were copied from a real terminal too (Salesforce CLI 2.138.6), when this folder was tested in fresh scratch orgs. The video was made on a Mac. Nothing was tested on Windows, so a Windows message is described here, never quoted. If yours isn't listed, paste the exact error in the video's comments and say whether you're on Windows or Mac.

## My deal says pounds now (or my $ turned into £)

You changed **Currency Locale** on Company Information to **English (United Kingdom) - GBP**, as Owen does by mistake. Salesforce asked you to confirm with: "Changing your corporate currency changes only the currency symbol on all of your existing records; no conversion rates are applied."

- **Why:** in an org with one currency, the Currency Locale only decides the symbol and the format. Nothing is converted: $50,000.00 becomes £50,000.00.
- **Fix:** Setup, Quick Find `company`, Company Information, Edit, Currency Locale **English (United States) - USD**, Save. Do it **before** you tick Activate Multiple Currencies. That part of the video is watch-only.

## I ticked Activate Multiple Currencies while the locale said pounds

Every record you already had now starts in GBP, and GBP is your corporate currency, not USD.

- **Why:** when you turn on multiple currencies, the Currency Locale becomes the corporate currency, and every existing record gets it.
- **Fix:** multiple currencies can never be switched off, so start clean: delete this org (`sf org delete scratch --target-org kestrel --no-prompt`) and build a fresh one from this folder, which ends with USD as the corporate currency. At work this is why you test in a sandbox first.

## There's no Opportunity Currency field

The **New Opportunity** form has no **Opportunity Currency**, and amounts still show a $ sign instead of **USD**.

- **Why:** multiple currencies aren't on yet. The tick didn't save, or you didn't deploy this folder.
- **Fix:** Setup, Quick Find `company`, Company Information, Edit, tick **Activate Multiple Currencies**, Save. Or deploy this folder (`sf project deploy start`, or with `--ignore-conflicts` for the org you already have). Then reload the page.

## British Pound isn't in the Opportunity Currency list

The field is there, but it only offers **USD - U.S. Dollar**.

- **Why:** a currency is only offered once it's added and active in Manage Currencies.
- **Fix:** Setup, Quick Find `currencies`, Manage Currencies, New, Currency Type **GBP - British Pound**, Conversion Rate **0.79**, Save. Or deploy this folder: it adds GBP and EUR.

## I added the wrong currency and there's no Delete

Manage Currencies has no Delete for a currency.

- **Why:** the New Currency page says so: "Note that you cannot delete a currency once you activate it."
- **Fix:** click **Deactivate** next to it (in the Action column, beside Edit). It stays in the org, inactive, and nobody can pick it for a new record. Check the Currency Type before you save a new one.

## The number in brackets is wrong

Pennine Pumps shows something other than **GBP 10,000.00 (USD 12,658.23)**.

- **Why:** the rate was typed differently, for example **7.9** instead of **0.79**. The bracket is 10,000 divided by the GBP rate.
- **Fix:** Manage Currencies, click **Edit** next to GBP, set Conversion Rate to **0.79**, Save. The bracket changes at once, on every deal: a plain rate has no memory.

## "Invalid field CurrencyIsoCode for Opportunity"

The deals script fails with:

```
Error (executeRuntimeFailure): Execution failed at this code:

System.SObjectException: Invalid field CurrencyIsoCode for Opportunity
```

- **Why:** you ran it before `sf project deploy start`. A deal's currency field exists only once multiple currencies are on, and the deploy turns them on.
- **Fix:** run `sf project deploy start` (with `--ignore-conflicts` in the org you already have), then the script again. The failed run saved nothing.

## "No account called Brookfield Water"

Running the deals script fails with:

```
Error (executeRuntimeFailure): Execution failed at this code:

System.IllegalArgumentException: No account called Brookfield Water. Load it first: sf data import tree --plan data/plan.json
```

- **Why:** the two deals belong to Brookfield Water, and your org doesn't have an account with that name. In a new org you skipped the load step, or ran the script before it.
- **Fix:** run `sf data import tree --plan data/plan.json` once, then the script again. In the org you already have, check the account's name in **Accounts**: it must be exactly **Brookfield Water**.

## "No default environment found" in the org you already have

In this folder, `sf project deploy start --ignore-conflicts` (or any other command) fails with:

```
Error (NoDefaultEnvError): No default environment found. Use -o or --target-org to specify an environment.
```

- **Why:** `--set-default` saved your `kestrel` org as the default for the folder you created it from (`ep-01`, for example), and for that folder only. This folder has no default yet.
- **Fix:** in this folder, run `sf config set target-org kestrel` once. Every command here then uses that org.

## My screen doesn't look like the video's tabs

The tabs along the top change with the **app**. The video uses an app whose name is at the **top left**, next to the grid icon. If your tabs differ, click the grid icon (the App Launcher) and pick the same app, or search for what you need, for example **Accounts**.

## Setup opened in a new tab

Clicking the gear, then **Setup**, opens Setup in a **new browser tab**. That's normal. Your first tab is still there. Close the Setup tab, or click back to the first one.

## My user is called "User User"

A new scratch org names its first user **User User**. Episode 1 renames you to **Owen Hartley** (Setup, Quick Find `Users`, Users, Edit). In a hurry, run the script: from this folder, `sf apex run --file scripts/rename-admin-user.apex`. It renames whoever runs it, so it needs no username.

## Accounts also shows "Sample Account for Entitlements"

Salesforce makes that account itself in every new org, even with sample data off. It's not yours and it's not a mistake. Leave it alone.

## The license numbers don't match the video

The video shows **Developer Edition** and **Salesforce: 2 total, 1 used** (Setup, Company Information, User Licenses). Your org is **Enterprise Edition** from this definition file, so it shows **Salesforce: 5 total, 1 used**. That's expected: we switched so more full users fit later. The used count goes up when you add users.

## The Users list has four users, not just me

Setup, then Users, lists **Chatter Expert**, **Integration User**, **Security User** and you. The other three are made by Salesforce, and none of them uses one of your Salesforce licenses. Don't deactivate them.

## "There are changes in the org that conflict with the local changes you're trying to deploy"

Deploying a folder into an org you already deployed an **earlier folder** into fails with a table whose State says `Conflict` (for example for `Kestrel_Practice`), then:

```
Error (1): There are changes in the org that conflict with the local changes you're trying to deploy.
```

- **Why:** the CLI tracks changes per folder. This folder has never seen your org, and the org already holds a `Kestrel_Practice` that another folder put there.
- **Fix:** run `sf project deploy start --ignore-conflicts`, which tells the CLI to send this folder's files anyway. In `ep-02a` that's how the currency settings reach the org you already have.
- A **fresh** scratch org made from this folder doesn't hit this.

## I have two Brookfield Water accounts

You created Brookfield Water by hand and then ran `sf data import tree --plan data/plan.json`, or you ran the import twice. Open **Accounts**, open the extra one, and delete it (the arrow next to Edit, then Delete). Load it only once.

## "command not found: sf"

You type `sf --version` and get:

```
zsh: command not found: sf
```

- **Why:** the terminal was opened before you installed the Salesforce CLI. It still has the old list of places to look for programs (the PATH), so it doesn't know `sf` yet.
- **Fix:** close that terminal and open a new one, then run `sf --version` again. It prints a version, for example `@salesforce/cli/2.158.7 darwin-arm64 node-v26.0.0`. Yours may be newer, and the `node` part may differ.
- **On Windows** you'll see a similar message (a "not recognized" error). The fix is the same: close every PowerShell window, Command Prompt and VS Code, then open them again.
- Still not found? Install the CLI one way only. Installing it with the installer **and** with npm leads to confusing path problems.
- Installed it with npm? The CLI needs **Node.js 22 or newer**. Check with `node --version`, and update Node.js first if it's older.

## The login asks for a verification code

You run `sf org login web --set-default-dev-hub --alias my-devhub`, type the username and password on Salesforce's login page, and instead of the **Allow** page it asks for a **verification code**.

- **Why:** Salesforce checks it's really you when you log in from a browser or network it hasn't seen with that user before. It sends the code by email.
- **Fix:** open the email sent to your org user's address (for a hands-on org, the same address your password-reset email went to), type the code, and verify. Then click **Allow**. The terminal says `Successfully authorized`, with your username and org ID.
- No email? Check spam, and give it a minute before asking for a new code.

## "The specified org ... is not a Dev Hub."

Creating the scratch org fails with a message that ends: `is not a Dev Hub.`

- **Why:** the org you logged in to isn't a Dev Hub. Either you haven't turned Dev Hub on (Setup, Quick Find, **Dev Hub**, turn on **Enable Dev Hub**), or you logged in to a different org.
- **Fix:** turn Dev Hub on in your hands-on org (Setup, Quick Find, **Dev Hub**, the **Enable Dev Hub** toggle), then log in again from your home folder: `sf org login web --set-default-dev-hub --alias my-devhub`.
- No **Dev Hub** in Quick Find? Then you're not in your hands-on org. Salesforce's guide says Dev Hub can't be turned on in a sandbox.
- Once Dev Hub is on, it can't be turned off (the page says so: "You can't disable this setting"). That's fine in a practice org. At work, ask first.

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

- **Why:** your free hands-on org, as a Dev Hub, keeps only a few scratch orgs at a time (Salesforce's guide says a maximum of three active; yours may allow more). An old org of yours is still counting.
- **Fix:** run `sf org list`, then delete one you don't need: `sf org delete scratch --target-org <alias> --no-prompt`. An org that has expired can keep counting for a while. If it still fails, wait a day: the daily allowance is a rolling 24 hours.

## "Duplicate PermissionSetAssignment"

Running `sf org assign permset --name Kestrel_Practice` a second time prints a table called **Failures** with `Duplicate PermissionSetAssignment`.

- **Why:** you already have that permission set. It isn't a problem.
- **Fix:** nothing to do. Carry on.

## "No file found at data/plan.json"

Running `sf data import tree --plan data/plan.json` fails with `No file found at data/plan.json`.

- **Why:** the folder has no records to load. `ep-00` has none. Skip that step.
- **Fix:** none needed. If a later folder does have `data/` and you still see it, you're not in that folder (see "No file found" above).

## There's no "All Accounts" list

In a brand-new scratch org, the **Accounts** tab doesn't let you choose an **All Accounts** list yet, so you can't open **Sample Account for Entitlements** from a list.

- **Fix:** search for it. Click the search box at the top, type `Sample`, press Enter, then click **Accounts** in the results. **Sample Account for Entitlements** is there. Salesforce makes it itself.
- The same works for any record: search for it by name.

## Other things that aren't errors

- **"Warning: @salesforce/cli update available"** is only a hint that a newer CLI exists. Nothing breaks.
- **"No changes to deploy"** means the org already has everything in the folder. Running `sf project deploy start` twice is safe.
- **`sf org open`** prints "Waiting to resolve the Lightning Experience-enabled custom domain..." for a few seconds before the browser opens.
- A new scratch org's first user is named **User User**, and its time zone may say Los Angeles. Both are normal.

## Behind a college or office network

If the browser login never comes back to the terminal on a college or office network, a proxy may be blocking it. Salesforce's install guide says to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables to your proxy's address. We haven't reproduced this one ourselves. Ask your network admin for the proxy address.

## Your free org: a hands-on org from Trailhead

- **Make it on Trailhead.** Sign up or log in at [trailhead.com](https://trailhead.com) (free). Open any hands-on challenge (every project is hands-on: Learn, then Projects), click the arrow next to **Launch**, and choose **Create Playground** (it may say **Create a Trailhead Playground**). It takes about 3 to 4 minutes. A Trailhead Playground is a hands-on org, and Salesforce Help says it's "actually a Developer Edition".
- **The username:** launch the org and open the **Get Your Login Credentials** tab. Write down the username shown there. No such tab? Open the App Launcher and choose **Playground Starter**, or go to Setup, Quick Find `Users`, Users, and note your username there.
- **The password:** you need one for the CLI login, and a new playground opens from Trailhead without one. On the same tab, click **Reset My Password**, open the email, click its link and set a password. Do it **before** your first `sf org login web`. (No tab? In Setup, Users, tick your name and click **Reset Password(s)**.)
- The username **looks like an email address, but it isn't your inbox**. Log in with that username, not with your Trailhead email.
- **Never change that username.** Trailhead uses it to check your work in challenges.
- Write the username and the password in a password manager, never on a sticky note. Can't find the reset email? Check spam.

## Your free org can be deleted if nobody logs in

Free orgs that nobody logs into get deleted. Salesforce Help says a Developer Edition org that hasn't been logged into for **45 days** is deleted, and a hands-on org is a Developer Edition. Salesforce emails you first, and logging in during the first 14 days after the warning brings the org back. Your Dev Hub is that free org, so log in at least once a month. If it's gone, make a new hands-on org on Trailhead and do steps two to four of the setup video again.
