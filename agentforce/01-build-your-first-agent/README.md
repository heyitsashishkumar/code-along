# 01 · Build your first Agentforce agent

The finished agent for **Agentforce from Zero, video 1**. The video builds it by clicking, and **following the clicks is the lesson**. This folder holds the finished agent, so you can check your work against it, or deploy it as a shortcut. Stuck on an error? See [Troubleshooting](#troubleshooting).

## What you build

You build **Bit**, an Agentforce agent, in a free org of your own. Bit is an **Employee agent**: a helper for your own staff, and it runs as whoever is logged in. It starts from Salesforce's **Agentforce Employee Agent** template, which comes with three subagents, the jobs it can do (the exam still calls them topics): **General FAQ**, **Off Topic** and **Ambiguous Question**. You look inside Bit in Agentforce Builder, and you test it in Preview. Then you break it on purpose with one line that says "always", see why every answer goes wrong, and fix it with one honest line. That line is the only change from the template.

## What you need

- **A free Developer Edition org with Agentforce and Data 360.** Sign up at [developer.salesforce.com/signup](https://developer.salesforce.com/signup). Step 1 below goes through the form.
- **A new practice org, never your company's.** You'll break things on purpose.
- **A browser.** That's all the video uses: no VS Code, no command line.
- **Only for the shortcut:** the Salesforce CLI (`sf`). LWC from Zero video 2 installs it: see [lwc/02-setup](../../lwc/02-setup/).

## What's in this folder

```
01-build-your-first-agent/
  sfdx-project.json
  force-app/main/default/aiAuthoringBundles/Bit_1/
    Bit_1.agent              Bit, written in Agent Script
    Bit_1.bundle-meta.xml    tells Salesforce what this folder is
  README.md
```

`Bit_1` is Bit's version 1, the draft the video saves. `Bit_1.agent` is plain text. It's the same text you see in the builder's **Script** view. There are no records, flows or permission sets: video 1 doesn't need any.

The only line that differs from the template is the second line of the system instructions, the rules that go with every message:

```
system:
    instructions: |
        You are an AI Agent.
        Never promise a date, a price or a task you can't do. If you don't know, say so.
        ...
```

That's shortened. In the file, a blank line follows, then `The user's current context is:` and four lines about the user's current app, object, page and record. They're the template's.

Everything else is the template's, unchanged. The welcome message still says "Hi, I'm Agentforce!" That's the template's too, and the video leaves it alone.

## What an agent is made of

Before the build, the video draws an agent out of shapes. In words:

- **The model** (a large language model, an LLM) does the thinking: it reads, it reasons, and it writes the reply. On its own, it knows language, not your company.
- **A subagent is a job** the agent can do. For a cycle shop, Repair Status could be one job and Opening Hours another. Each subagent has a name and a description, which say when it's used. The exam calls a subagent a **topic**.
- **An action is a tool** for a job: look up a record, run a flow, search your documents. Actions are how an agent does things, not just says things.
- **An instruction is a rule.** Some belong to one job, for example "ask for the order number before looking anything up". Some sit on top, for every message, for example "answer in the customer's language". The ones on top are the **system instructions**.

**One message's trip through the agent:**

1. A message comes in.
2. The **Agent Router** compares it with each subagent's name and description, and picks the best job. That's why descriptions matter: if two of them sound alike, the router can send a question to the wrong job.
3. A **prompt** is built. It's the text the model is given: the rules for every message, the chosen job's own rules, the recent chat, and the tools it may use. Only the chosen job's rules go in. The other jobs stay out, which keeps the prompt short.
4. The **model** reasons. It can answer, ask you a question, or run a tool and check what comes back.

The video's key line: **A subagent is a job. An action is a tool. An instruction is a rule. And the model does the thinking.**

## Build it, step by step

The steps have the same labels as the video. Type each value exactly as shown.

### Step 1: a free org

1. Open [developer.salesforce.com/signup](https://developer.salesforce.com/signup). It's the Developer Edition with Agentforce and Data 360.
2. Fill in your first name, last name, job title, company and country.
3. Fill in an email address you can open. The form calls it the work email.
4. Accept the agreement and click **Sign me up**.
5. Open the email from Salesforce, verify your account, and set a password. You're in.

Salesforce makes a **username** for you and sends it in that email. It looks like an email address, but it isn't your inbox. Log in with the username.

> **One warning:** Salesforce may close an org that nobody logs into for 45 days. Log in now and then.

### Step 2: switched on?

Einstein is the switch for Salesforce's generative AI. Agentforce is the part that runs agents on top of it. In a new org, both are already on. **You change nothing in this step.**

1. Click the gear at the top right, then **Setup**. Setup opens in a new browser tab.
2. In **Quick Find**, type `Einstein Setup`, and click **Einstein Setup**. The **Turn on Einstein** switch should say **On**. Don't touch it.
3. In **Quick Find**, type `Agent`, and click **Agentforce Agents**. It's lower down the results, under **Einstein Generative AI › Agentforce Studio**: scroll down, or type `Agentforce Agents`. You see a **New Agent** button and no switch.

Older orgs had a **Turn on Agentforce** switch on that page. New orgs have none, because Agentforce is already on. There's nothing to click here. You build agents in Agentforce Studio, in Step 3.

### Step 3: Agentforce Studio

You build agents outside Setup now. So a company can let someone build agents without making them a full admin. That person needs one permission: **Manage AI Agents**. In your own free org you're the admin, so you can build already.

1. Click the **App Launcher** (the grid of dots at the top left).
2. Type `Agent`, and under **Apps** choose **Agentforce Studio**.
3. You're on the **Agents** page. In a new org it says **0 items** and **No agents**.

Look at the menu on the left:

- **Build:** among others, **Agents** and **Tests**. Tests is for checking an agent before anyone uses it.
- **Observe & Optimize:** **Analytics** and **Sessions & Intents** (and **Alerts**). They show what an agent did once people use it.

### Step 4: a new agent

1. Click **New Agent**. **Agentforce Builder** opens in a new tab. It asks "What do you want your agent to do?"

The exam calls the builder **Agentforce Agent Builder**. On screen, it's **Agentforce Builder**. Same thing.

Before you pick a template, two things the video explains:

- **Why a template?** It's the quicker start: it comes with subagents, actions and settings already made, and you change them later.
- **Why an Employee agent?** Employee agents help your own people, and they run as whoever is logged in. So the agent can only see and do what that person is allowed to. Service agents talk to customers. A helper for your own staff, like Bit, is an Employee agent. A cycle shop's customers asking "is my bike ready?" would need a Service agent: that's [video 2](../02-is-my-bike-ready/).

2. Under **Or, start with a template**, find the **Agentforce Employee Agent** card and click **Details**. It lists three subagents:
   - **General FAQ** answers from your knowledge: your own documents.
   - **Off Topic** steers the chat back when a question strays. Ask about something Bit has no job for, and Off Topic steers you back.
   - **Ambiguous Question** asks what you mean when a question is too vague. Type just `help`, and it asks what you need help with.
3. Click **Select Template**. A box opens: **Name your agent**.
4. In **Agent Name**, type `Bit`.
5. Click anywhere outside the Agent Name box. **Developer Name** fills itself with `Bit`.
6. Click **Let's Go**.

### Step 5: look inside

There's nothing to type in this step. Look at each part:

1. The top bar says **Bit · Version 1 (Draft)**.
2. On the left is the **Explorer**: settings, subagents, variables, connections and data.
3. The builder opens on the **Agent Summary**: **Bit**, then the **Agent Router**, then the three subagents under it. Every message goes to the Agent Router first. It compares the message with each subagent's name and description, and picks the best one.
4. The **General FAQ** card shows **Actions (1)**: **Answer Questions with Knowledge**. That's its tool for searching your documents.
5. In the Explorer, click **Settings**, then **Agent-Level Instructions**. The **System Instructions** box says `You are an AI Agent.` Under it are the line `The user's current context is:` and four lines about the user's current app, object, page and record. Leave them. Rules written here go with every message: the agent's tone, its limits, and anything it must never do.
6. Switch from **Canvas** to **Script**. It's the same agent, written in Agent Script. Change one view, and the other follows.
7. In the script, find `start_agent agent_router:`. Every message starts there.
8. At the top, find the `system:` block. It holds `instructions:` (rules for every message) and `messages:` (the welcome and error messages).

Your script now matches [`Bit_1.agent`](force-app/main/default/aiAuthoringBundles/Bit_1/Bit_1.agent), except for one line. You add that line in [The fix](#the-fix).

### Step 6: test

1. Click **Preview**. Talk to Bit the way a user would.
2. Type `What can you help me with?` and press Enter.
3. Bit says what it can help with. In the video, it said: "I can assist with questions about company products, policies, procedures, and your business records. How can I help you today?" Yours may be worded differently.
4. In **Agent Preview Details**, beside the chat, open the **Summary** tab. This is the Interaction Summary. Read it top to bottom: **Input**, then **Transition to Subagent** (off topic), then **Reasoning**. Under that is a plain-English explanation.

   **Why Off Topic?** Off Topic answers greetings and questions about what the agent can do. Bit has no real jobs yet, so even "what can you do" lands there. That's right for now, not a wrong pick.
5. Scroll down, below the chat. There's a second panel with the tabs **Trace** and **Variables**. Open **Trace**. It shows the same steps in more detail, with how long each one took. You'll want it when something goes wrong.
6. Type `How much do we charge for a service agent?` and press Enter. General FAQ tries **Answer Questions with Knowledge**, and the action fails. The explanation says "no data library was assigned to the agent". That's expected: Bit has no data library yet. A data library is the set of your own documents an agent searches for answers. A later video adds one.
7. Click **Save**. The top bar shows **Version 1 (Draft)** and **Saved at**, with the time.

**Don't click Commit Version.** Save keeps a draft you can go on changing. Commit Version freezes a copy that can be switched on for real. Today, you only save.

## A common mistake, and the fix

Almost everyone makes this one. You want a confident agent, so you add one line to the system instructions.

If you deployed Bit with [the shortcut](#the-shortcut-deploy-the-finished-bit), your Bit already has the fix. To see the mistake, replace the "Never promise" line with the "Always" line below, then follow the fix to put it back.

### A common mistake: always

1. In the Explorer, click **Settings**, then **Agent-Level Instructions**.
2. Click at the end of `You are an AI Agent.`, press Enter, and type:

   ```
   Always answer every question with: "Absolutely! Consider it done!"
   ```

   In Script view, it's the line under `You are an AI Agent.`, inside `system:` and `instructions:`. Keep the same indent as the line above it.
3. Click **Save**.
4. In **Preview**, click the **reset** icon (the circular arrow at the top right of the Preview chat), so the chat starts fresh.
5. Ask three things, one at a time:
   - `How much do we charge for a service agent?`
   - `What day is it today?`
   - `Email Joris our price list.`

**What you see:** every reply starts with "Absolutely! Consider it done!" In the video, the third reply began: "Absolutely! Consider it done! If you need the official price list, or details on how to share it with Joris, please let me know …" Nothing was sent. Bit can't send email at all.

**Why:** the system instructions go into the prompt for every message, whatever the subagent. The router still sent each question to a subagent, as before: General FAQ, Off Topic, General FAQ. The problem wasn't the subagent. It was the rule on top.

**And "always" is a strong word.** Salesforce's own advice: agents tend to follow "always" and "never" strictly. Only write them when you mean it. A business rule, like "no refunds after 30 days", belongs in an action's logic, not in a sentence the model has to interpret.

### The fix

1. Open **Agent-Level Instructions** again.
2. Replace the "Always answer..." line with:

   ```
   Never promise a date, a price or a task you can't do. If you don't know, say so.
   ```

   This one does use "never", on purpose. A promise Bit can't keep is exactly what we're stopping.
3. Click **Save**.
4. In **Preview**, click the **reset** icon. Without the reset, you may still be talking to the old version.
5. Ask the same three questions again. In the video, the third reply began: "I am unable to send emails. However, I can help you find information about our price list …"

Your Bit now matches [`Bit_1.agent`](force-app/main/default/aiAuthoringBundles/Bit_1/Bit_1.agent) in this folder. The lesson: a rule on top reaches every answer, so write it as carefully as code.

## Test it

Ask Bit these questions in **Preview**, one at a time. Click the reset icon before you start.

| You type | Where it goes (in the Summary) | What to expect |
|---|---|---|
| `What can you help me with?` | **Off Topic** | What Bit can help with, and a question back. |
| `How much do we charge for a service agent?` | **General FAQ**, which runs **Answer Questions with Knowledge** | It can't find the price. The explanation says "no data library was assigned to the agent". |
| `What day is it today?` | **Off Topic** | No date. It steers you back to what it can help with. |
| `Email Joris our price list.` | **General FAQ** | It says it can't send emails. In the video, it began: "I am unable to send emails. However, I can help you find information about our price list …" |

**Replies vary.** The model words its answer afresh every time, even for the same question. What should match is the subagent in the Summary, and the kind of answer. After the fix, Bit should never promise to send an email.

Why the first question goes to Off Topic: see [Step 6](#step-6-test).

## The shortcut: deploy the finished Bit

Do the clicks at least once: they're the lesson. Use this shortcut to start over quickly, or to see the finished agent in your org.

First, get this repo. Either clone it with `git clone` (copy the URL from the green **Code** button on the repo's GitHub page), or click **Code**, then **Download ZIP**, and unzip it.

Then go into this folder. If you used `git clone`:

```bash
cd code-along/agentforce/01-build-your-first-agent
```

If you downloaded the ZIP, the folder is called `code-along-main`:

```bash
cd Downloads/code-along-main/agentforce/01-build-your-first-agent
```

Tip: type `cd` and a space, then drag the `01-build-your-first-agent` folder into the terminal. It types the path for you. On Windows, unzipping can make a folder inside a folder: open them until you see `agentforce`.

Now connect your org, check the file, and deploy it:

```bash
sf org login web --alias <your alias>
sf agent validate authoring-bundle --api-name Bit_1 -o <your alias>
sf project deploy start --source-dir force-app -o <your alias>
```

- Replace `<your alias>` with a short name of your own for the org, for example `agentforce-org`. Use the same name in every command.
- `sf org login web` opens your browser. Log in with your Developer Edition username, then click **Allow**.
- `sf agent validate authoring-bundle` checks that Bit's script compiles. It changes nothing in your org.
- `sf project deploy start` sends Bit to your org.
- **No data to import.** Video 1 has no records.
- **No placeholders to fill in.** Bit is an Employee agent, so it runs as you and needs no agent user.

Then click:

1. **App Launcher**, type `Agent`, and choose **Agentforce Studio**.
2. On the **Agents** page, open **Bit**.
3. Do [Step 6: test](#step-6-test).

**Bit isn't on the Agents page?** Try opening it by its file's name:

```bash
sf org open agent --authoring-bundle Bit_1 -o <your alias>
```

**Already have a Bit?** If your org already has an agent called Bit, the deploy can replace its draft with this file.

**Don't publish it.** `sf agent publish authoring-bundle` is the same as clicking **Commit Version**, which the video doesn't do.

**What we've checked:** Bit's script compiles (`sf agent validate authoring-bundle` succeeded). A check-only deploy also passed in our own org, which already had Bit. In that org, the Bit we made by clicking and saving exists only as this one authoring bundle, and this folder's files are identical to it. So deploying them should give you the same draft the clicks make. We checked the commands with Salesforce CLI 2.138.6. If `sf` says `agent` is not a command, run `sf update`. We haven't yet deployed Bit into a brand-new org, and haven't tried `sf org open agent` there. If neither shows you Bit, build it by clicking (Steps 3 and 4). Then add the line from [The fix](#the-fix). Please tell us in the video's comments what you saw.

## Troubleshooting

These are the problems the video shows, and two we hit while making it. If yours isn't here, paste the exact words you see in the video's comments, and say whether you're on Windows or Mac.

### I can't find Agentforce Agents in Setup

- **Why:** Einstein is probably off.
- **Fix:** in Setup, type `Einstein Setup` in Quick Find and open **Einstein Setup**. Turn **Turn on Einstein** on. Wait a few minutes, then look again.

### A Guidance Center panel covers the New Agent button

- **Why:** a **Guidance Center** panel can open on the right of Agentforce Studio, on top of **New Agent**. Your org may not show it at all.
- **Fix:** click the **X** on the panel to close it.

### Let's Go stays grey

- **Why:** **Developer Name** is empty. It fills only when you leave the Agent Name box.
- **Fix:** click anywhere outside the Agent Name box. Developer Name fills with `Bit`, and **Let's Go** turns blue.

### "Enter a unique developer name"

We hit this while making the video. It's not in the video.

- **Why:** another agent in your org already uses that Developer Name. For example, you already made Bit, or you deployed it with the shortcut.
- **Fix:** open the Bit you already have, from the **Agents** page in Agentforce Studio. Or type a different **Developer Name**, for example `My_Bit`. Changing Agent Name alone may not change it.

### The knowledge action fails: "no data library was assigned to the agent"

You ask about a price. The Summary shows the action **Answer Questions With Knowledge**, and the explanation says "no data library was assigned to the agent".

- **Why:** General FAQ searches a data library for answers, and Bit doesn't have one yet.
- **Fix:** nothing to fix in video 1. It's expected.

### Bit sends a question to the wrong subagent

The video warns about this one. You won't see it with the template's three subagents, but you will once an agent has jobs of its own.

- **Why:** the Agent Router picks a subagent by its name and description. When two descriptions sound alike, it can send a question to the wrong one.
- **Fix:** check the descriptions first. The **Summary** shows which subagent was picked (**Transition to Subagent**). Make the right subagent's description say plainly what it handles. Video 2 does exactly this.

### Every reply starts with "Absolutely! Consider it done!"

- **Why:** that's the mistake the video makes on purpose. The "Always" line in the system instructions reaches every message.
- **Fix:** replace it, as in [The fix](#the-fix).

### I changed the instructions, but Bit's replies didn't change

- **Why:** the Preview chat may still be using the old version.
- **Fix:** click **Save**, then the **reset** icon in Preview, and ask again.

### I clicked Commit Version by mistake

This isn't in the video either.

- **Why:** a committed version is frozen. You can't change it.
- **Fix:** click **New Version** in the top bar. It makes a new draft you can change.

### Errors from the `sf` command

The video doesn't use the command line, so these only happen with the shortcut.

- **`agent` is not a `sf` command.** Your Salesforce CLI is too old. Run `sf update`.
- For `command not found: sf` and other CLI errors, see [the CLI errors in admin/ep-01](../../admin/ep-01/TROUBLESHOOTING.md#command-not-found-sf).

## Exam note

This series follows the **Salesforce Certified Agentforce Specialist** exam. Video 1 covers part of its biggest section, AI Agents: how an agent works and its building blocks, and when to use an Employee agent or a Service agent.

**The exam, as the video gives it** (read in the exam guide on 11 November 2026): 60 scored questions, plus up to 5 that don't count. 105 minutes. 72% to pass. Six sections: AI Agents 35%, Prompt Engineering 20%, Data 360 Fundamentals 20%, Testing, Deployment, and Maintenance 10%, Governance and Observability 10%, and Multi-Agent Orchestration 5%. Check the exam guide before you book: it changes.

**Two names for one thing.** The screen says **subagent**; the exam still says **topic**. The screen says **Agentforce Builder**; the exam says **Agentforce Agent Builder**.

**Remember the video's question:** what decides which subagent handles a message? The **Agent Router**. It compares the message with each subagent's name and description.

**Try this one.** It's our own practice question, written to the exam guide. It's not a real exam question: those are confidential.

> An Employee agent has three subagents: General FAQ, Off Topic and Ambiguous Question. An admin adds this line to its system instructions: `Reply in British English.` A user's question is sent to General FAQ. Which instructions go into the prompt?
>
> - **A.** Only General FAQ's own instructions.
> - **B.** The system instructions and General FAQ's instructions.
> - **C.** The system instructions and the instructions of all three subagents.
> - **D.** Only the system instructions, because they replace the subagent's instructions.

<details>
<summary>Answer</summary>

**B.** The system instructions go into the prompt for every message. Only the chosen subagent's instructions join them.

- **Not A:** the system instructions reach every message, whatever the subagent.
- **Not C:** only the chosen subagent's instructions go in. The other subagents stay out, which keeps the prompt short.
- **Not D:** they add to the subagent's instructions; they don't replace them. That's what the "always" mistake showed: the line was added on top of the subagent's answer. In two of the three replies, the line came first and the subagent's real answer followed.

</details>

## Versions in the video

Recorded on 12 and 13 November 2026, in a free Developer Edition org on the Winter '27 release. The agent file was retrieved at API version `68.0`. Agentforce changes quickly. If a screen looks different, the steps are usually the same. Paste what you see in the video's comments.

Bit, Joris, Meera and Lucas are made up.
