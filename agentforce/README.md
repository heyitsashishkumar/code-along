# Agentforce from Zero: Build Along (Specialist Exam Prep)

The code for **Agentforce from Zero**, the Agentforce series. Each video builds an agent by clicking, in a free org of your own, and covers part of the **Salesforce Certified Agentforce Specialist** exam as it goes. The agents and their uses come from everyday work: a helper for your own staff, and a cycle shop whose customers ask "is my bike ready?". Joris, his shops, his customers and everyone else in the videos are made up.

## The folders

Each folder is what one video builds, **at the end of that video**, as a complete Salesforce DX project: `sfdx-project.json`, the metadata in `force-app/` (the agent, written in Agent Script, and anything it uses), any records in `data/`, and a `README.md`. The README has the video's steps with the same labels, the tests to run and what to expect, the video's mistake and its fix, a **Troubleshooting** section, and an exam note with a practice question of our own.

| Folder | What it holds | Video |
|---|---|---|
| [01-build-your-first-agent](01-build-your-first-agent/) | **Bit**, an Employee agent from the Agentforce Employee Agent template, with one line added to its system instructions | Video 1: Build your first Agentforce agent |

More folders are added as each video is published.

**Each video stands on its own.** Unlike The Accidental Admin, video N doesn't start from folder N-1: the next video makes a new agent and doesn't need Bit. The steps in each video build everything that video needs.

## What you need

- **A free Developer Edition org with Agentforce and Data 360.** Sign up at [developer.salesforce.com/signup](https://developer.salesforce.com/signup). Video 1 goes through the form. Use a practice org, never your company's: the videos break things on purpose.
- **A browser.** That's all the videos use.
- **Only for the shortcut:** the Salesforce CLI (`sf`), and this repo. LWC from Zero video 2 installs the CLI: see [lwc/02-setup](../lwc/02-setup/). The shortcuts were checked with Salesforce CLI 2.138.6. If `sf` says `agent` is not a command, run `sf update`.

## Deploy any folder (the shortcut)

Do the clicks at least once: they're the lesson. The shortcut is for starting over quickly, skipping ahead, or seeing the finished agent in your org.

1. **Get this repo.** Either clone it with `git clone` (copy the URL from the green **Code** button on the repo's GitHub page), or click **Code**, then **Download ZIP**, and unzip it. A ZIP unzips to a folder called `code-along-main`.
2. **Go into the video's folder,** for example `cd code-along/agentforce/01-build-your-first-agent`, or `cd Downloads/code-along-main/agentforce/01-build-your-first-agent` from a ZIP.
3. **Connect your org once,** with a short name of your own for it, for example `agentforce-org`:

   ```bash
   sf org login web --alias <your alias>
   ```

4. **Run the commands in the folder's README,** under **The shortcut**, in its order. They follow one pattern:

   ```bash
   sf agent validate authoring-bundle --api-name <the agent's bundle> -o <your alias>
   sf project deploy start --source-dir force-app -o <your alias>
   sf project deploy start --manifest manifest/<file>.xml -o <your alias>
   sf org assign permset --name <permission set> -o <your alias>
   sf data import tree --plan data/plan.json -o <your alias>
   ```

   - **Always pass `-o <your alias>`,** so every command goes to your practice org and nowhere else.
   - **`--source-dir` or `--manifest`?** A folder with a `manifest/` folder is deployed in parts, one manifest at a time, as its README says. Don't deploy its whole `force-app`: it would send the agent before you've filled in its placeholder.
   - **Placeholders.** A Service agent runs as its own user, so its file holds a placeholder, such as `YOUR_AGENT_USER_USERNAME`, where your agent user's username goes. The folder's README says what to put there. Neither the check nor the deploy notices a placeholder you forgot. Once it holds your username, don't push that file to a public repo.
   - **Data** is imported once, and only after the permission set that lets you see its fields.

5. **Open the agent:** **App Launcher**, type `Agent`, choose **Agentforce Studio**, and open it on the **Agents** page. Or open it by its bundle's name: `sf org open agent --authoring-bundle <the agent's bundle> -o <your alias>`.

**Don't publish it.** `sf agent publish authoring-bundle` is the same as clicking **Commit Version**, which the videos don't do.

**What we've checked:** every folder's files compile and pass a check-only deploy in our own org, where the agents already existed. We haven't yet run a shortcut in a brand-new org. Each folder's README says exactly what was checked. If something doesn't match, build it by clicking, and tell us in the video's comments what you saw.

## Stuck?

Each folder's README ends with a **Troubleshooting** section: each error from its video, the exact message, why it happens, and the fix. If yours isn't there, paste the exact error in the video's comments and say whether you're on Windows or Mac.

## The exam

Each README ends with an **Exam note**: which part of the Agentforce Specialist exam the video covers, the names that differ between the screen and the exam (the screen's **subagent** is the exam's **topic**), and one practice question. The questions are our own, written to the exam guide. They're not real exam questions: those are confidential.
