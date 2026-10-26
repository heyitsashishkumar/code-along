# code-along

The code from the **Freestyle Cyber Hub** code-along playlists, one folder per video. Each folder holds the project exactly as it is at the end of its video, so you can check your work against it, or start the next video from it.

Today that's **LWC from Zero: Code Along**. Lightning Web Components are taught from zero by building one small app, Sharma Traders' customer desk, a piece at a time. An Apex playlist will follow in `apex/`.

## LWC from Zero

| Video | What you build | Folder |
|---|---|---|
| 1 | Introduction: what you'll build and how to use the playlist | no code |
| 2 | Set up everything, free: your org, VS Code, the Salesforce CLI, Java, the Extension Pack, and the `customer-desk` project | [lwc/02-setup](lwc/02-setup/) |
| 3 | Your first component, on a real Salesforce page: `customerCard`, exposed, deployed and placed with Lightning App Builder | [lwc/03-first-component](lwc/03-first-component/) |
| 4 | Show data, and react to typing: `customerGreeting`, `{customerName}`, `lightning-input`, `onchange` and `this.` | [lwc/04-show-data](lwc/04-show-data/) |
| 5 | Calculated values with getters: `customerName`, `get fullName()`, and template literals | [lwc/05-getters](lwc/05-getters/) |
| 6 | Show or hide parts of the page: `customerStatus`, `lwc:if`, `lwc:elseif`, `lwc:else`, and `Number(event.target.value)` | [lwc/06-conditional](lwc/06-conditional/) |
| 7 | Lists: `productList`, `for:each`, `for:item`, `key`, `iterator:it`, `filter` and `map` | [lwc/07-lists](lwc/07-lists/) |

More folders are added as the videos come out. From video 14 (`lwc/14-record-forms`) on, the components work with records. So every folder from 14 onward also has a `data/` folder with Sharma Traders' made-up customers, companies and deals (standard Account, Contact and Opportunity records). Load them into your org once with:

```bash
sf data import tree --plan data/plan.json
```

## How to use it with the playlist

1. **Code along in your own project.** Pause the video and type it yourself. That's what makes it stick. Video 2 shows how to make the project.
2. **Check against the video's folder.** When your screen doesn't match the video, compare your files with that video's folder here.
3. **Stuck on an error?** Every folder has a `TROUBLESHOOTING.md` with each error from its video: the exact message, why it happens, and the fix. If yours isn't there, paste the exact error in the video's comments, and say whether you're on Windows or Mac.
4. **Lost your project?** Copy the previous video's folder somewhere of your own, open that copy in VS Code (File, Open Folder), connect your org (`SFDX: Authorize an Org`), and carry on from there.

Each folder is a complete Salesforce DX project that opens and deploys on its own. Each folder's README explains how to deploy it and what you should see.

## Before you start

Use a free practice org, never a work org. A Developer Edition org is free: sign up at `developer.salesforce.com/signup`. Video 2 sets up everything else: VS Code, the Salesforce CLI, Java 21 and the Salesforce Extension Pack.

The videos are recorded on a Mac with Salesforce CLI 2.155.7 and the Salesforce Extension Pack 68.4.0, at API version 68.0. On Windows, the steps are the same unless a folder's README says otherwise.

## Where the topics come from

The topics and their order follow Salesforce's own sample gallery, [trailheadapps/lwc-recipes](https://github.com/trailheadapps/lwc-recipes) (CC0-1.0). The components, the app and the explanations here are our own.

## Licence

[MIT](LICENSE): fork it, use it, change it, share it. Keep the licence notice.

---

Salesforce, Lightning and Apex are trademarks of Salesforce, Inc. This repo and the channel are not affiliated with, sponsored or endorsed by Salesforce. Sharma Traders and its customers are made up.
