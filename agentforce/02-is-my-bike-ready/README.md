# 02 · Is my bike ready? A custom subagent and a flow action

The finished build for **Agentforce from Zero, video 2**. The video builds everything by clicking, and **following the clicks is the lesson**. This folder holds the finished pieces, so you can check your work against them, or deploy them as a shortcut. Stuck on an error? See [Troubleshooting](#troubleshooting).

## What you build

You build **Spoke**, a **Service agent** for a cycle-repair shop. A customer asks "Is my bike ready?" and gives the number on their ticket. Spoke looks the repair up and tells them the bike, its status and when it will be ready. First you make the data: a **Repair Order** object with four records. Then a small **flow** that finds one repair order by its number. Then the agent, from the **Agentforce Service Agent** template. You add your own **custom subagent**, **Repair Status** (the exam still calls a subagent a topic). Inside it goes a **custom action**, **Get Repair Status**, that runs the flow. The first test fails for real, because Spoke runs as its own user, and that user can't read repair orders. You fix it with a read-only permission set. Then one wording sends a question to the wrong subagent, and you fix that with one sentence in a description.

## What you need

- **A free Developer Edition org with Agentforce.** Sign up at [developer.salesforce.com/signup](https://developer.salesforce.com/signup). Video 1 goes through the form ([agentforce/01-build-your-first-agent](../01-build-your-first-agent/)).
- **A practice org, never your company's.** You'll break things on purpose.
- **A browser.** That's all the video uses.
- **Only for the shortcut:** the Salesforce CLI (`sf`). LWC from Zero video 2 installs it: see [lwc/02-setup](../../lwc/02-setup/).

You don't need Bit from video 1. Spoke is a new agent.

## What's in this folder

```
02-is-my-bike-ready/
  sfdx-project.json
  manifest/
    repair-orders.xml     Steps 1 and 2: the object, its tab, layout and list, the flow, and your own access
    spoke.xml             Steps 3 to 5 and the fix: the agent, and the permission set for its user
  force-app/main/default/
    objects/Repair_Order__c/
      Repair_Order__c.object-meta.xml       the Repair Order object (numbers like RO-0001)
      fields/                               Customer Name, Bike, Status, Ready Time
      listViews/All.listView-meta.xml       the All list
    tabs/Repair_Order__c.tab-meta.xml
    layouts/Repair_Order__c-Repair Order Layout.layout-meta.xml
    flows/Get_Repair_Status.flow-meta.xml   the flow the action runs
    permissionsets/
      Repair_Orders_Agent_Read.permissionset-meta.xml   the fix: read access for Spoke's user
      Repair_Orders_Access.permissionset-meta.xml       full access for you (shortcut only)
    aiAuthoringBundles/Spoke_1/
      Spoke_1.agent              Spoke, written in Agent Script
      Spoke_1.bundle-meta.xml    tells Salesforce what this folder is
  data/
    plan.json  Repair_Order__c.json   the four repair orders
  README.md
```

`Spoke_1` is Spoke's version 1, the draft the video saves. `Spoke_1.agent` is plain text. It's the same text you see in the builder's **Script** view. The ten subagents from the template are unchanged. Your work is at the end of the file:

```
subagent Repair_Status:
    label: "Repair Status"
    description: "Answers a customer's questions about their bike repair: whether the bike is ready, what's being done, and when it will be ready to collect. Use it for any repair order number that starts with RO-, including questions about order status."
    reasoning:
        instructions: ->
            |Ask the customer for the repair order number on their ticket, like RO-0001, if they haven't given it. Use Get Repair Status to look it up. Tell them the bike, its status, and when it will be ready. If no repair order is found, say so and ask them to check the number. Never guess a status.
        actions:
            Get_Repair_Status: @actions.Get_Repair_Status
                with repairOrderNumber = ...
    actions:
        Get_Repair_Status:
            label: "Get Repair Status"
            description: "Looks up a repair order by its number and returns the bike, its status, and when it will be ready."
            target: "flow://Get_Repair_Status"
```

The description already has its second sentence, the one you add at the very end, in [The wrong job](#the-wrong-job-and-its-fix). The builder also added one line to the Agent Router for you: `go_to_Repair_Status: @utils.transition to @subagent.Repair_Status`.

**One placeholder.** Line 15 says `default_agent_user: "YOUR_AGENT_USER_USERNAME"`. Every org's agent user has a different username, so it isn't in this file. The shortcut shows what to put there.

**Two permission sets.** `Repair_Orders_Agent_Read` is the video's fix. `Repair_Orders_Access` isn't in the video. You need it only for the shortcut: fields deployed from files aren't visible to anyone until a permission set says so. When you make the fields by clicking, Salesforce makes them visible to you itself.

## Build it, step by step

The steps have the same labels as the video. Type each value exactly as shown. The flow and the agent find things by their API names, so keep the API names that fill themselves in.

### Step 1: the data

The agent can only look up what exists, so you start with the repair orders. An object is a table. This one holds one row per repair.

1. Click the gear at the top right, then **Setup**. Open **Object Manager**, click **Create**, then **Custom Object**. Not **Custom Object from Spreadsheet**: that one opens another site.
2. Fill in the form:

   | Box | Type or choose |
   |---|---|
   | Label | `Repair Order` |
   | Plural Label | `Repair Orders` |
   | Record Name | `Repair Order Number` |
   | Data Type | **Auto Number** |
   | Display Format | `RO-{0000}` |
   | Starting Number | `1` |

   **Display Format** and **Starting Number** appear once you choose Auto Number. The API name fills itself: `Repair_Order__c`.
3. Tick **Launch New Custom Tab Wizard after saving this custom object**. Click **Save**.
4. The tab wizard opens. Pick any tab style: it's only the tab's icon. The video says there's a bicycle. If you can't find one, pick the **Motorcycle**. Click **Next**, **Next**, then **Save**.
5. On the object, open **Fields & Relationships** and click **New**. Make four fields, one at a time:

   | Field Label | Data Type | Length | Field Name (fills itself) |
   |---|---|---|---|
   | `Customer Name` | **Text** | `80` | `Customer_Name` |
   | `Bike` | **Text** | `80` | `Bike` |
   | `Status` | **Picklist** | | `Status` |
   | `Ready Time` | **Text** | `40` | `Ready_Time` |

   For **Status**, choose **Enter values, with each value separated by a new line**, and type these four lines:

   ```
   Received
   In Repair
   Waiting for Parts
   Ready for Pickup
   ```

   For each field, click **Next** until you reach the page layouts page, then click **Save**. Leave the ticks on those pages as they are, so you can see the field.

   Why is **Ready Time** text, not a date? So it can say `Tomorrow, 5 pm`, or `Not set yet`.
6. Open the **Repair Orders** tab. Click **New** four times and make these four repair orders, in this order:

   | Customer Name | Bike | Status | Ready Time |
   |---|---|---|---|
   | `Sam Visser` | `Blue city bike` | Ready for Pickup | `Today, 10 am` |
   | `Sam Bakker` | `Red road bike` | In Repair | `Tomorrow, 5 pm` |
   | `Anouk de Jong` | `Cargo bike with a child seat` | Waiting for Parts | `Friday` |
   | `Daan Smit` | `Black folding bike` | Received | `Not set yet` |

   Salesforce numbers them **RO-0001** to **RO-0004**. Two of the customers are called Sam, on purpose. Two customers can share a name, but never a repair number. The second one, **RO-0002**, is Sam Bakker's red road bike, In Repair, ready tomorrow at 5 pm. You'll ask about it in Step 6.

Can't see the tab? Open the **App Launcher** and search for `Repair Orders`.

### Step 2: the flow

A flow is a small program you build in Salesforce by clicking, with no code. This one only looks one thing up, and that's what the action will run.

1. In Setup, type `Flows` in Quick Find and open **Flows**. Click **New Flow**.
2. In the **New Automation** window, under **Frequently Used**, pick **Autolaunched Flow (No Trigger)**. Autolaunched means no screens. No Trigger means it runs only when something calls it. Here, the agent calls it.
3. **The input.** In the **Toolbox**, click **New Resource**. Fill in:

   | Box | Type or choose |
   |---|---|
   | Resource Type | **Variable** |
   | API Name | `repairOrderNumber` |
   | Description | `The repair order number on the customer's ticket, like RO-0001.` |
   | Data Type | **Text** |
   | Availability Outside the Flow | tick **Available for input** |

   Click **Done**. That tick is what lets the agent hand the number to the flow.
4. **The output.** Click **New Resource** again:

   | Box | Type or choose |
   |---|---|
   | Resource Type | **Variable** |
   | API Name | `repairOrder` |
   | Description | `The repair order that was found: the bike, its status and when it will be ready. Empty if no repair order has that number.` |
   | Data Type | **Record** |
   | Object | **Repair Order** |
   | Availability Outside the Flow | tick **Available for output** |

   Click **Done**. The action copies the flow's inputs and outputs, so these two ticks decide what the agent can send, and what it gets back. The agent reads the two descriptions too, to know what to send and what it gets back.
5. **The lookup.** On the canvas, click the **+** and add **Get Records**. Get Records searches an object, and brings back the records that match.
   - **Label:** `Get Repair Order` (the API Name fills itself: `Get_Repair_Order`)
   - **Object:** **Repair Order**
   - **Filter Repair Order Records:** Field **Repair Order Number**, Operator **Equals**, Value `repairOrderNumber` (pick the variable from the list)
   - **How Many Records to Store:** **Only the first record**

   Flow Builder now warns: "If you store only the first record, filter by a unique field, such as ID." That's fine here: the repair number is unique.
6. **Where it goes.** Under **How to Store Record Data**, pick **Choose fields and assign variables (advanced)**. Then pick **Together in a record variable**, and choose `repairOrder`, your output. Add five fields: **Repair Order Number** (`Name`), **Customer Name**, **Bike**, **Status** and **Ready Time**.
7. Click **Save**. **Flow Label:** `Get Repair Status`. The API name fills itself: `Get_Repair_Status`. **Description:** `Finds a repair order by its number (RO-0001 and so on) and returns it: the bike, its status and when it will be ready.` Click **Save**, then **Activate**. The badge says **Active**.
8. **Test it before you go on.** Click **Debug**. Under Input Variables, set `repairOrderNumber` to `RO-0002`. Click **Run**. You should see "One or more Repair_Order__c records were retrieved." It's much easier to fix a flow here than inside an agent.

Two variables and one element. That's the whole back office.

### Step 3: the agent

1. Open the **App Launcher**, type `Agent`, and choose **Agentforce Studio**.
2. Click **New Agent**. Agentforce Builder opens in a new tab. Find the **Agentforce Service Agent** card and click **Select**.
3. In **Agent Name**, type `Spoke`. Click anywhere outside the box. **Developer Name** fills itself with `Spoke`.
4. Under **Assign user record**, leave **New User** selected. Salesforce makes a user for the agent to run as. The line under it says: "New User creates a new user record for this agent. Manage this user's permissions in Setup." Remember that line.
5. Click **Let's Go**. The top bar says **Spoke · Version 1 (Draft)**.

The template brings ten subagents: **Service Customer Verification**, **General FAQ**, **Case Management**, **Account Management**, **Reservation Management**, **Delivery Issues**, **Order Inquiries**, **Escalation**, **Off Topic** and **Ambiguous Question**. They're standard subagents: ready-made jobs (the exam says standard topics). Ten jobs before it's answered a single question.

Five of them handle customer data, so they stay locked until the customer is verified: Case Management, Account Management, Reservation Management, Delivery Issues and Order Inquiries. In **Script** view, each one's line in the Agent Router says `available when @variables.isVerified == True`. Questions about orders go to Verification first. Remember that in [The wrong job](#the-wrong-job-and-its-fix).

**Why a Service agent?** Joris's customers are outside the company. Bit, in video 1, was an Employee agent, for staff, and it ran as whoever was logged in. Spoke's customers have no login, so Spoke needs a user of its own.

### Step 4: the subagent

1. In the **Explorer**, hover over **Subagents** and click the **+** (Add subagent). Choose **Create subagent**.
2. In the **Add Subagent** window:
   - **Subagent Name:** `Repair Status`
   - **Description:** `Answers a customer's questions about their bike repair: whether the bike is ready, what's being done, and when it will be ready to collect.`

   The description is the most important sentence you'll write today. The Agent Router reads every subagent's name and description, and picks one. So this sentence is how a question gets here.
3. Click **Create and Open**. Under **Reasoning Instructions**, tell it how to do the job. Type:

   ```
   Ask the customer for the repair order number on their ticket, like RO-0001, if they haven't given it. Use Get Repair Status to look it up. Tell them the bike, its status, and when it will be ready. If no repair order is found, say so and ask them to check the number. Never guess a status.
   ```

   The last line is: never guess a status. Agents follow "always" and "never" strictly (video 1). Here, that's what you want: a wrong "ready" is the one answer you can't afford.
4. Click **Save**. You see "Your changes were saved."

A subagent made here belongs to this agent only. To share one between agents, make it in the asset library.

### Step 5: the action

1. In the Explorer, hover over **Repair Status** and click the **+** (Add action to subagent). Choose **New Action**.
2. In the **Add Action** window:
   - **Action Name:** `Get Repair Status`
   - **Description:** `Looks up a repair order by its number and returns the bike, its status, and when it will be ready.`
   - **Reference Action Type:** **Flow**
   - **Reference Action:** **Get Repair Status**

   The description is how the agent knows what this tool is for.
3. Click **Create and Open**. Under **Inputs** is `repairOrderNumber`, and under **Outputs** is `repairOrder`. Their descriptions came straight from the flow's variables. That's why you wrote them.
4. Leave three settings off. The input has **Require Input to execute action**. The output has **Filter from agent context** and **Show in conversation**.
   - **Require Input** means the action can't run until it has that value.
   - **Filter from agent context** would hide the output from the agent.
   - **Show in conversation** would paste the raw output into the reply, instead of Spoke putting it in words.
5. Click **Save**. In **Script** view, the action sits under `subagent Repair_Status:`, pointing at the flow: `target: "flow://Get_Repair_Status"`.

A standard action comes ready-made from Salesforce. A custom action is one you build yourself, like this one.

### Step 6: test

1. Open **Preview**. Its menu offers two modes: **Simulate Mode** and **Live Test Mode**.
2. Choose **Live Test Mode**. Simulate Mode uses mock data. Live Test Mode runs the real flow on real records. Our flow only reads, so it changes nothing.
3. Type `Is my bike ready? My ticket says RO-0002.` and press Enter.

In the video, the first real answer blames a system issue. The ticket is fine. Welcome to testing. That's the next section.

## A common mistake, and the fix

This is the mistake the video makes for real, in Step 6. If you took Part 2 of [the shortcut](#the-shortcut-deploy-the-finished-build), your Spoke may already have the fix. The shortcut says how to see the mistake first.

### A common mistake: who runs it?

**What you see.** Spoke says something like: "It looks like I was unable to retrieve the status for repair order RO-0002 due to a system issue. Could you please double-check the repair order number on your ticket and confirm it here? I'll try again as soon as you provide it."

1. Look at the **Summary**. The router did its job: **Transition to Subagent: Repair Status**, then **Action: Get Repair Status**. But the action has a **red cross**: it failed. The explanation says the action "failed with a flow execution error".
2. It still says **Output Evaluation: GROUNDED**. That only means the reply didn't make anything up. It doesn't mean the action worked.
3. Open the **Trace** and click **Action: Get Repair Status**. Open the **Errors** tab. It says "Error encountered during Get Repair Status", then the reason, `INVALID_TYPE`: "An unhandled fault has occurred in this flow".

**Why.** The flow worked when you debugged it. So what's different? Who's running it. You tested the flow as yourself, the admin, who can see everything. The agent runs it as its own user, and that user can't see Repair Orders. It's a new employee on day one: the shop's records exist, but their login can't open them yet.

This is the **security context**, and the exam asks about it: an action runs with the access of the user the agent runs as. (Unless the flow is set to run in system context. Ours isn't.)

### The fix

A permission set is a bundle of access you hand to a user. You make one that opens Repair Orders, and give it to the agent's user.

1. In Setup, type `Permission Sets` in Quick Find and open **Permission Sets**. Click **New**.
2. **Label:** `Repair Orders Agent Read`. The API Name fills itself: `Repair_Orders_Agent_Read`. **Description** is optional: `Lets an agent's user read repair orders, so the Get Repair Status action can find them.` Leave **License** as **--None--**. Click **Save**.
3. Click **Object Settings**, then **Repair Orders** (it's far down the list), then **Edit**.
4. Under **Object Permissions**, tick **Read**. Under **Field Permissions**, tick the box in the **Read Access** header. It ticks Bike, Customer Name, Ready Time and Status at once. Click **Save**.
5. Click **Manage Assignments**, then **Add Assignment**. Tick **EinsteinServiceAgent User**. That's the user Salesforce made in Step 3.
6. Click **Next**. Leave **No expiration date** as it is. Click **Assign**. You see "1 assignments were successful." Click **Done**.
7. Back in Agentforce Builder, click the reset icon in Preview, and ask again: `Is my bike ready? My ticket says RO-0002.`

Read only, not edit. The agent only looks things up, so it gets only what it needs.

**Still failing?** Salesforce Help says the agent's user also needs the **Run Flows** permission. In our org it already had it, from its profile, **Einstein Agent User**.

**Help's own way:** add the access to the permission set Salesforce made for the agent's user, called "[agent name] Permissions". A separate permission set, as in the video, worked in our org.

## Test it

Ask Spoke these in **Preview**, in **Live Test Mode**. Click the reset icon before each question, except the one that starts with "then": that one goes in the same chat.

| You type | Where it goes (in the Summary) | What to expect |
|---|---|---|
| `Is my bike ready? My ticket says RO-0002.` | **Repair Status**, which runs **Get Repair Status** (green tick) | Sam Bakker's red road bike: in repair, ready tomorrow at 5 pm. In the video: "Your red road bike with ticket RO-0002 is currently still in repair. It will be ready for pickup tomorrow at 5 pm." |
| `Is my bike ready?` | **Repair Status** | It asks for the number. In the video: "Could you please provide the repair order number from your ticket? It should look something like RO-0001. I'll check the status for you." That's your instruction working. |
| then `RO-0001` | **Repair Status**, **Get Repair Status** | The blue city bike, ready for pickup today at 10 am. In the video: "Your bike, a Blue city bike, is ready for pickup. It was completed today at 10 am." |
| `Is my bike ready? Ticket RO-0099.` | **Repair Status**, **Get Repair Status** | No such repair order. It says so, and asks you to check the number. In the video: "I could not find a repair order with the number RO-0099. Please check your ticket and confirm the repair order number." |
| `Can you check my order status? It's RO-0003.` | With Step 4's description: **Service Customer Verification**. After the fix below: **Repair Status** | Before the fix, it asks you to verify who you are. After it, the cargo bike with a child seat, waiting for parts, ready by Friday. |

**Replies vary.** The model words its answer afresh every time, even for the same question. What should match is the subagent in the Summary, and the facts: the bike, the status and the ready time.

**Your numbers are different?** If you made extra repair orders, the numbers move on. Ask about the numbers your list shows.

### The wrong job, and its fix

Real customers don't all write "is my bike ready". Ask `Can you check my order status? It's RO-0003.` In the video, Spoke said: "To check your order status, I need to verify your identity. Please enter your username or email address to receive a verification code."

**Why:** wrong job. The words "order status" matched the template's **Service Customer Verification**, whose description claims questions about orders. The router reads descriptions, not minds. When two of them sound alike, they compete for the same question.

**The fix:** make your description say it out loud.

1. In the Explorer, click **Repair Status**.
2. At the end of its **Description**, add this sentence:

   ```
   Use it for any repair order number that starts with RO-, including questions about order status.
   ```

3. Click **Save**. Click the reset icon in Preview, and ask the same question.

In the video, it then went to Repair Status and said: "Your repair order RO-0003 is for a cargo bike with a child seat. The status is "Waiting for Parts." It is expected to be ready by Friday."

Another way is to remove template subagents the shop doesn't use. But Verification protects customer data, so think before you delete it.

Your Spoke now matches [`Spoke_1.agent`](force-app/main/default/aiAuthoringBundles/Spoke_1/Spoke_1.agent) in this folder, apart from its agent user on line 15.

## The shortcut: deploy the finished build

Do the clicks at least once: they're the lesson. Use the shortcut to start over quickly, or to skip ahead. There are two parts. Part 1 skips Steps 1 and 2. Part 2 also skips Steps 3 to 5 and the fix.

### Part 1: the data and the flow

In a terminal, go into this folder, connect your org, and run:

```bash
cd code-along/agentforce/02-is-my-bike-ready
sf org login web --alias <your alias>
sf project deploy start --manifest manifest/repair-orders.xml -o <your alias>
sf org assign permset --name Repair_Orders_Access -o <your alias>
sf data import tree --plan data/plan.json -o <your alias>
```

- Replace `<your alias>` with a short name of your own for the org, for example `agentforce-org`. Use the same name in every command.
- `sf org login web` opens your browser. Log in with your Developer Edition username, then click **Allow**.
- `sf project deploy start` sends the Repair Order object, its fields, tab, layout and **All** list, the flow, and the `Repair_Orders_Access` permission set.
- `sf org assign permset` gives you that permission set, so you can see the tab and the fields. Run it **before** the import.
- `sf data import tree` loads the four repair orders. A new org numbers them RO-0001 to RO-0004. Run it **only once**, and only if you didn't make the records by hand.

Then click: in Setup, open **Flows**. **Get Repair Status** should say **Active**. If it doesn't, open it and click **Activate**.

Now go on from [Step 3: the agent](#step-3-the-agent). The tab's icon is a laptop, not a bicycle. It's only an icon.

### Part 2: the finished agent too

Do Part 1 first. Use an org that has no agent called Spoke yet. If your org already has one, the deploy can replace its draft with this file.

1. **Make the agent's user.** In the video, Salesforce makes it when you pick **New User**. Here, the CLI makes it:

   ```bash
   sf org create agent-user -o <your alias>
   ```

   It prints the new user's **username**. Copy it.
2. **Put the username in the file.** Open `force-app/main/default/aiAuthoringBundles/Spoke_1/Spoke_1.agent` in a text editor. On line 15, replace `YOUR_AGENT_USER_USERNAME` with the username. Keep the quotes. Save the file.

   ```
   access:
       default_agent_user: "YOUR_AGENT_USER_USERNAME"
   ```

   The file now holds a username from your org. Don't push it to a public repo.
3. **Check, deploy, and give the user access:**

   ```bash
   sf agent validate authoring-bundle --api-name Spoke_1 -o <your alias>
   sf project deploy start --manifest manifest/spoke.xml -o <your alias>
   sf org assign permset --name Repair_Orders_Agent_Read --on-behalf-of <agent user username> -o <your alias>
   ```

   - `sf agent validate authoring-bundle` checks that Spoke's script compiles. It changes nothing in your org.
   - `sf project deploy start` sends Spoke and the `Repair_Orders_Agent_Read` permission set.
   - `sf org assign permset ... --on-behalf-of` gives that permission set to Spoke's user. That's [The fix](#the-fix). **Want to see the mistake first?** Test before you run this last command.
4. **Then click:** **App Launcher**, type `Agent`, choose **Agentforce Studio**, and open **Spoke** on the **Agents** page. Open **Preview**, choose **Live Test Mode**, and do [Test it](#test-it).

Spoke's description already has the fix for [The wrong job](#the-wrong-job-and-its-fix). To see that mistake, delete the description's second sentence and save.

**Don't publish it.** `sf agent publish authoring-bundle` is the same as clicking **Commit Version**, which the video doesn't do.

**What we've checked:** Part 1's files passed a check-only deploy in our own org. Spoke's script compiles (`sf agent validate authoring-bundle` succeeded). We checked the commands with Salesforce CLI 2.138.6. We haven't yet run the shortcut in a brand-new org: not the deploy, the import, or `sf org create agent-user`. If Spoke isn't on the Agents page after Part 2, build it by clicking (Steps 3 to 5). Please tell us in the video's comments what you saw.

## Troubleshooting

These are the problems the video shows, and a few we hit while making it. If yours isn't here, paste the exact words you see in the video's comments, and say whether you're on Windows or Mac.

### Spoke blames "a system issue", and the action has a red cross

Spoke says: "It looks like I was unable to retrieve the status for repair order RO-0002 due to a system issue. Could you please double-check the repair order number on your ticket and confirm it here? I'll try again as soon as you provide it." The Summary shows **Action: Get Repair Status** with a red cross. The explanation says the action "failed with a flow execution error". In the Trace, **Action: Get Repair Status**, the **Errors** tab says:

```
Error encountered during Get Repair Status

Execution Error: [{"statusCode":"INVALID_TYPE","message":"An unhandled fault has occurred in this flow
An unhandled fault has occurred while processing the flow. Please contact your system administrator for more information.","fields":null}]
```

- **Why:** the agent runs the flow as its own user, **EinsteinServiceAgent User**. That user can't read Repair Orders.
- **Fix:** give that user read access, as in [The fix](#the-fix). Then reset the preview and ask again.

### It says GROUNDED, but the action failed

- **Why:** **GROUNDED** only means the reply didn't make anything up. It doesn't mean the action worked.
- **Fix:** look for the red cross on the action, and open the Trace's **Errors** tab.

### "To check your order status, I need to verify your identity."

The full reply: "To check your order status, I need to verify your identity. Please enter your username or email address to receive a verification code."

- **Why:** wrong job. The question went to **Service Customer Verification**, whose description claims questions about orders.
- **Fix:** add the sentence from [The wrong job](#the-wrong-job-and-its-fix) to Repair Status's description. Save, reset, and ask again.

### It still fails after the permission set

- **Check the user.** The permission set must go to **EinsteinServiceAgent User**, not to you. In Setup, open the permission set, then **Manage Assignments**.
- **Check Run Flows.** Salesforce Help says the agent's user also needs the **Run Flows** permission. In our org it came from the user's profile, **Einstein Agent User**.
- **Reset the preview.** Without the reset, you may still be in the old conversation.
- **Check the flow.** In Setup, **Flows**, **Get Repair Status** must say **Active**.

### The replies don't match my repair orders

- **Why:** you may be in **Simulate Mode**. It uses mock data, so the real flow never runs.
- **Fix:** open the mode menu in Preview and choose **Live Test Mode**.

### I can't see the Repair Orders tab

- **Fix:** open the **App Launcher** and search for `Repair Orders`.
- **Took the shortcut?** Give yourself the `Repair_Orders_Access` permission set (Part 1 of the shortcut). It makes the tab and the fields visible.

### Let's Go stays grey

- **Why:** **Developer Name** is empty. It fills only when you leave the Agent Name box.
- **Fix:** click anywhere outside the Agent Name box. Developer Name fills with `Spoke`, and **Let's Go** turns blue.

### "Enter a unique developer name"

We hit this while making video 1. It's not in this video.

- **Why:** another agent in your org already uses that Developer Name. For example, you already made Spoke, or you deployed it with the shortcut.
- **Fix:** open the Spoke you already have, from the **Agents** page in Agentforce Studio. Or give the new agent another name.

### "If you store only the first record, filter by a unique field, such as ID."

- **Why:** Flow Builder shows this warning when you pick **Only the first record**.
- **Fix:** nothing. It isn't an error. The repair order number is unique, so the first record is the only one.

### "Cannot read properties of undefined (reading 'upsertContentFromAfscriptList')"

We saw this once while making the video. It's not in the video. We had made a copy of the flow without **Available for input** ticked. That flow was still listed under **Reference Action**, but **Create and Open** showed only this error and made no action.

- **Why:** most likely the flow's input isn't available for input, so the action has nothing to copy.
- **Fix:** open the flow, open `repairOrderNumber`, and tick **Available for input**. Check that `repairOrder` has **Available for output**. Save the flow, activate the new version, and make the action again.

### I have eight repair orders, or my numbers start at RO-0005

- **Why:** you made the records by hand and also ran the import, or ran the import twice. An auto number never goes back, even when you delete records.
- **Fix:** delete the extra records. When you test, ask about the numbers your list shows.

### The Repair Orders tab shows no records

- **Why:** the tab opens on **Recently Viewed**. Records loaded by the import aren't recently viewed yet.
- **Fix:** click the list name and choose **All**.

### Errors from the `sf` command

The video doesn't use the command line, so these only happen with the shortcut.

- **The import says a field doesn't exist.** Run `sf org assign permset --name Repair_Orders_Access -o <your alias>` first, then the import again.
- **The Spoke deploy fails and mentions the user.** Check line 15 of `Spoke_1.agent`: it must hold your agent user's username, in quotes.
- For `command not found: sf` and other CLI errors, see [the CLI errors in admin/ep-01](../../admin/ep-01/TROUBLESHOOTING.md#command-not-found-sf).

## Exam note

This series follows the **Salesforce Certified Agentforce Specialist** exam. Video 2 is in its biggest section, **AI Agents** (35%). It covers three of its objectives: choosing standard or custom topics and actions; the security context an agent runs in, and how it affects its actions; and when to use an Employee or a Service agent.

**Two names for one thing.** The screen says **subagent**; the exam still says **topic**. So a custom subagent is a custom topic, and the template's ready-made subagents are standard topics. The screen says **Agentforce Builder**; the exam says **Agentforce Agent Builder**.

**Remember the video's question:** a custom action runs a flow that works for the admin, but fails in the agent. What do you do first? Give the agent's user access to the object the flow reads. Working for the admin doesn't mean working for the agent. Test as the agent, in Live Test Mode.

**Try this one.** It's our own practice question, written to the exam guide. It's not a real exam question: those are confidential.

> A cycle shop's Service agent has the template's subagents and a custom subagent, Repair Status. A customer who writes "Is my bike ready? RO-0003" gets the bike's status. A customer who writes "Can you check my order status? It's RO-0003." is asked to verify their identity. What should the admin change first?
>
> - **A.** Give the agent's user Edit access to Repair Orders.
> - **B.** Add to Repair Status's description that it handles repair order numbers, including questions about order status.
> - **C.** Turn on Show in conversation for the action's output.
> - **D.** Add "Always use Repair Status" to the agent-level instructions.

<details>
<summary>Answer</summary>

**B.** The Agent Router picks a subagent by its name and description. "Order status" matched Verification's description better, so the question never reached Repair Status.

- **Not A:** access isn't the problem. The other wording works, so the action can already read the records. And the agent only needs Read.
- **Not C:** that only changes how an output is shown. The action never ran.
- **Not D:** agent-level instructions reach every message, whatever the subagent. Video 1 showed what an "always" line does. The router chooses from descriptions, so fix the description.

</details>

## Versions in the video

Recorded on 13 and 14 November 2026, in a free Developer Edition org on the Winter '27 release. The files were retrieved at API version `68.0`. Agentforce changes quickly. If a screen looks different, the steps are usually the same. Paste what you see in the video's comments.

Spoke, Joris, Lucas and the customers on the repair orders are made up.
