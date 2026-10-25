# 02 · Set up everything, free

The code for **LWC from Zero #2**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

- Your own free Salesforce **Developer Edition** org.
- **VS Code**, with the **Salesforce Extension Pack** (publisher: Salesforce).
- The **Salesforce CLI**. `sf --version` prints its version.
- **Java 21** (JDK 21 from adoptium.net). The Apex extension needs it.
- An empty Salesforce DX project called **`customer-desk`**, made with `SFDX: Create Project` and the Standard template, and connected to your org under the alias `desk-org`.

This folder is that project, as VS Code makes it. There's no code in it yet: video 3 adds the first component.

## Check yours against this folder

Your `customer-desk` folder should have the same files:

```
customer-desk/
  .husky/  .vscode/  config/  scripts/
  .forceignore  .gitignore  .prettierignore  .prettierrc
  eslint.config.js  jest.config.js  package.json  sfdx-project.json  README.md
  force-app/main/default/   (empty folders: aura, classes, lwc, objects, …)
```

Three differences are normal:

- **No `force-app` here.** Git doesn't keep empty folders, so this folder has none. Yours has `force-app/main/default/` with empty folders inside. That's right.
- **`config/project-scratch-def.json`** says `"orgName": "<your user name> company"` in yours, and `"Sharma Traders"` here. It's only used to create scratch orgs, which this playlist doesn't need.
- **`.sf/` and `.sfdx/`** appear in yours once you connect the org. They hold your login details. Never copy them, share them or commit them (the project's `.gitignore` already leaves them out).

## Connect the project to your org

Open the project folder itself in VS Code, not the folder above it: File, Open Folder, `customer-desk`. Then either:

- **In VS Code:** open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Authorize an Org`. Choose **Project Default**, type the alias `desk-org`, log in to your org in the browser, and click **Allow**.
- **Or in the terminal**, from inside the project folder:

  ```bash
  sf org login web --alias desk-org --set-default
  ```

Want to start from this folder instead of your own? Copy `lwc/02-setup` to a folder of your own and rename the copy `customer-desk`. Open it in VS Code, then connect it as above.

## What you should see

- VS Code's status bar shows **`desk-org`** (it said "No Default Org Set" before you connected).
- `sf org list` in the terminal shows a table with `desk-org` and the status **Connected**.
- `sf org open` opens your org in the browser, already logged in. Your small task from the video: find **Setup**, under the gear.

## Versions in the video

Recorded on a Mac with Salesforce CLI `2.155.7` and the Salesforce Extension Pack `68.4.0`. The project's `sourceApiVersion` is `68.0`. Newer versions should work the same way. If a step looks different on your screen, paste what you see in the video's comments.
