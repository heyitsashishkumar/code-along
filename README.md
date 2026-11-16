# code-along

The code from the **Freestyle Cyber Hub** code-along playlists. **One folder per video, named by its number:** `006-lwc-first-component` is video 6. Each folder holds the code exactly as it is at the end of its video.

## LWC & Apex from Zero: Code Along

One playlist that builds Sharma Traders' **Customer Desk** from zero: the screens in LWC, and the Apex behind them. Videos with no code have no folder. More rows appear here as each video is published.

| Video | Title | Folder |
|---|---|---|
| 1 | What Salesforce Is, and What You'll Build | no code |
| 2 | How This Playlist Works | no code |
| 3 | Your Own Free Salesforce Org | no code |
| 4 | VS Code, the Terminal and the Salesforce CLI | no code |
| 5 | The Extension Pack, Your Project, and Connecting Your Org | [005-lwc-your-project](005-lwc-your-project/) |
| 6 | Your First Component | [006-lwc-first-component](006-lwc-first-component/) |
| 7 | Put Your Component on a Real Salesforce Page | [007-lwc-on-a-real-page](007-lwc-on-a-real-page/) |
| 8 | Show Data from JavaScript | [008-lwc-show-data](008-lwc-show-data/) |
| 31 | Load Your Sample Customers into Your Org | [031-lwc-sample-customers](031-lwc-sample-customers/) |
| 42 | The Lead Source Dropdown | [042-lwc-lead-source-dropdown](042-lwc-lead-source-dropdown/) |
| 47 | Your First Apex Class | [047-apex-first-class](047-apex-first-class/) |
| 48 | static or new? Two Ways to Call a Method | [048-apex-static-or-new](048-apex-static-or-new/) |
| 62 | Open ContactController to the Page | [062-apex-contact-controller](062-apex-contact-controller/) |

## How to use it with the playlist

1. **Pause and type.** Type the code yourself first. That's what makes it stick.
2. **Compare with the folder.** When your screen doesn't match the video, read your file beside the same file in that video's folder, line by line.
3. **Read the error.** Its code, its words, and where. Still stuck? Paste the exact message in a comment under the video, with the video number, and Windows or Mac.
4. **Want every folder on your laptop?** Click the green **Code** button, then **Download ZIP**, and unpack it.

Each folder is a complete Salesforce DX project that opens and deploys on its own. Its README says what's in it and how to deploy it.

Looking for the code of the first *LWC from Zero* and *Apex from Zero* videos (the `lwc/` and `apex/` folders)? It's kept on the `v1` tag.

## The Accidental Admin (`admin/`)

Each folder is Kestrel Industrial's practice org **at the end of one episode**, as a complete Salesforce DX project. Episode N starts from the folder of episode N-1. More rows appear here as each episode is recorded. See [admin/README.md](admin/README.md).

| Video | What it holds | Folder |
|---|---|---|
| Before episode 1 | Set up your own free practice org: Dev Hub, the Salesforce CLI, a scratch org from `config/project-scratch-def.json`, and the `Kestrel_Practice` permission set | [admin/ep-00](admin/ep-00/) |
| Episode 1: You're the Salesforce guy now. Same metadata as `ep-00`, plus the account Brookfield Water and a script that renames you to Owen Hartley | [admin/ep-01](admin/ep-01/) |

## Agentforce from Zero (`agentforce/`)

**Agentforce from Zero: Build Along (Specialist Exam Prep)** builds one Agentforce agent per video, by clicking along in your own free Developer Edition org, and covers the Salesforce Certified Agentforce Specialist exam as it goes. Each folder is what its video builds, as a complete Salesforce DX project, with a shortcut to deploy it. More rows appear here as each video is published. See [agentforce/README.md](agentforce/README.md).

| Video | What you build | Folder |
|---|---|---|
| 1 | Build your first Agentforce agent: **Bit**, an Employee agent from the Agentforce Employee Agent template. A look inside Agentforce Builder, a test in Preview, and an "always" line in the system instructions that breaks every answer, then the fix (`Bit_1.agent`) | [agentforce/01-build-your-first-agent](agentforce/01-build-your-first-agent/) |

## Before you start

Use a free practice org, never a work org. A Developer Edition org is free: sign up at `developer.salesforce.com/signup` (video 3). Videos 4 and 5 set up VS Code, the Salesforce CLI and the Salesforce Extension Pack.

The videos are recorded on a Mac with Salesforce CLI 2.155.7 and the Salesforce Extension Pack 68.4.0, at API version 68.0. On Windows, the steps are the same unless a folder's README says otherwise.

## Where the topics come from

The LWC and Apex topics follow Salesforce's own sample galleries, [trailheadapps/lwc-recipes](https://github.com/trailheadapps/lwc-recipes) and [trailheadapps/apex-recipes](https://github.com/trailheadapps/apex-recipes) (both CC0-1.0). Agentforce from Zero follows the exam guide for the Salesforce Certified Agentforce Specialist exam; its practice questions are our own, not real exam questions. The classes, components, agents, the app and the explanations here are our own.

## Licence

[MIT](LICENSE): fork it, use it, change it, share it. Keep the licence notice.

---

Salesforce, Lightning, Apex and Agentforce are trademarks of Salesforce, Inc. This repo and the channel are not affiliated with, sponsored or endorsed by Salesforce. Sharma Traders, Joris's cycle shop and their customers are made up.
