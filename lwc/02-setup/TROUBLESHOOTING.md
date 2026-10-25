# Troubleshooting · 02 · Set up everything, free

Every error and trap we hit while making **LWC from Zero #2**, with the exact message. We copied each message from our own screen while recording, never from memory.

The video was recorded on a Mac. Nothing was tested on Windows, so a Windows message is described here, never quoted. If yours isn't listed, paste the exact error in the video's comments and say whether you're on Windows or Mac.

## "command not found: sf"

You type `sf --version` in VS Code's terminal and get:

```
zsh: command not found: sf
```

- **Why:** the terminal was opened before you installed the Salesforce CLI. It still has the old list of places to look for programs (the PATH), so it doesn't know `sf` yet.
- **Fix:** close that terminal (the bin icon in the terminal panel), or restart VS Code. Then open a new terminal and run `sf --version` again. It prints the version, for example `@salesforce/cli/2.155.7 darwin-arm64 node-v24.21.0`.
- **On Windows** you'll see a similar message. The fix is the same: close every terminal, PowerShell window and VS Code, then open them again.
- Still not found? Install the CLI one way only. Installing it with the installer **and** with npm leads to confusing path problems.

## The SFDX commands are missing

You type `SFDX` in the command palette, and `SFDX: Authorize an Org`, `SFDX: Create Apex Class` and the other project commands aren't there. Only `SFDX: Create Project` still shows.

- **Why:** you opened the folder above the project (for example `Projects`). The Salesforce extensions only switch on when `sfdx-project.json` is at the top of the folder you opened.
- **Fix:** File, Open Folder, and open `customer-desk` itself.

## "To use this extension, first install the `code-analyzer` Salesforce CLI plugin"

A red notification appears as soon as your first project opens. It's from **Salesforce Code Analyzer**:

```
To use this extension, first install the `code-analyzer` Salesforce CLI plugin. Install the latest `code-analyzer` Salesforce CLI plugin by running `sf plugins install code-analyzer` in the VS Code integrated terminal.
```

- **Why:** the Extension Pack now includes the Code Analyzer extension, which needs a CLI plugin that a new CLI doesn't have.
- **Fix:** run `sf plugins install code-analyzer` in the terminal, or close the notification. Nothing in this playlist needs Code Analyzer. It comes back each time the project opens until the plugin is installed.

## "Agentforce — 1 MCP server failed to start"

A warning can appear next to the Code Analyzer one:

```
Agentforce — 1 MCP server failed to start. Copy Diagnostic Info to share with support.
```

- **Why:** the Extension Pack now includes the Agentforce Vibes extensions, and one of their background servers didn't start on a fresh setup.
- **Fix:** nothing to do for this playlist. Close the notification.

## The login stops working after a logout

A command against your org fails with:

```
Unable to refresh session due to: Error authenticating with the refresh token due to: expired access/refresh token
```

- **When we saw it:** the same user was logged in to the same org twice, under two aliases. Then one of those logins was logged out with `sf org logout`. The other login stopped working too.
- **Fix:** log in again with `SFDX: Authorize an Org`, or `sf org login web --alias desk-org --set-default`.

## Behind a college or office network

If the browser login never comes back to VS Code on a college or office network, a proxy may be blocking it. Salesforce's install guide says to set the `HTTP_PROXY` and `HTTPS_PROXY` environment variables to your proxy's address. We haven't reproduced this one ourselves. Ask your network admin for the proxy address.

## Sign-up: the username isn't your email

- The Developer Edition sign-up asks for a **username** that looks like an email address. It isn't your inbox, and it must be unique across all of Salesforce. Your Gmail address is probably taken already, so make one of your own, like `priya.desk@example.test`.
- Your real email address goes in the **Email** field. That's where the welcome mail arrives: click its link and set a password.
- Write down your username and password. You need them to connect VS Code.

## Things you'll see that aren't errors

- **"Do you trust the publisher "Salesforce"?"** appears when you install the Extension Pack. Check that it says Salesforce, then click **Trust Publisher & Install**. The install takes about a minute and adds about 23 extensions.
- The Marketplace also lists **Salesforce Extension Pack (Expanded)**, with extra community extensions. The video uses the plain **Salesforce Extension Pack**.
- A new project shows a few notifications: "Do you want to install the recommended extensions…" and a usage-data notice. You can close them.
- The status bar says **No Default Org Set** until you connect your org.
- `sf org open` prints "Waiting to resolve the Lightning Experience-enabled custom domain..." for a few seconds before the browser opens.
- `config/project-scratch-def.json` contains your computer's user name ("… company"). It's only used for scratch orgs.
