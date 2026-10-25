# Troubleshooting · 03 · Your first component

These are all the errors we hit while making **LWC from Zero #3**, each with its exact message, copied from our own screen while recording, never from memory. We re-ran each one in an org with this video's `customerCard`.

The video was recorded on a Mac. Nothing was tested on Windows, so if a Windows message differs, it's described here, never quoted. If your error isn't listed, paste its exact text in the video's comments.

## VS Code refuses the name `customer-card`

In `SFDX: Create Lightning Web Component`, typing `customer-card` shows this in red under the box, before anything runs:

```
Component name must start with a lowercase letter and contain only alphanumeric characters and underscores
```

- **Why:** a component's folder name can't have hyphens. In HTML the name becomes `c-customer-card` by itself.
- **Fix:** select it all and type `customerCard`, in camel case.
- If you use the CLI instead (`sf lightning generate component --name customer-card`), it says `Name must contain only alphanumeric characters.`

## The component isn't under Custom in App Builder

App Builder's Components panel shows **Custom (0)** and "No components available."

- **Why:** a new component's `.js-meta.xml` starts with `<isExposed>false</isExposed>`, and `false` means the page builders can't see it.
- **Fix:** set `isExposed` to `true` **and** add at least one target, then save and deploy again:

  ```xml
  <isExposed>true</isExposed>
  <targets>
      <target>lightning__AppPage</target>
  </targets>
  ```

## Still not there after deploying again

You exposed it and deployed, and App Builder still shows Custom (0).

- **Why:** App Builder loaded its list of components before you deployed.
- **Fix:** **Save** the page (click **Not Yet** in the "Page Saved" prompt), then reload the browser page once. `customerCard` appears under Custom.
- **Don't reload before the first save.** The browser asks "Leave site? Changes you made may not be saved." If you leave, the "Create a new Lightning page" wizard starts over and your new page is gone.

## `LWC1075: Multiple roots found` (or `LWC1079`)

The deploy fails with:

```
LWC1075: Multiple roots found (2:1)
```

With a single line and no `<template>`, the message is `LWC1079: Expected root tag to be template, found h1 (1:1)` instead.

- **Why:** everything a component shows must sit inside one `<template>` tag.
- **Fix:** put your lines back inside `<template>` … `</template>`.

## `LWC1078: <p> has no matching closing tag`

The deploy fails with:

```
LWC1078: <p> has no matching closing tag. (3:5)
```

- **Why:** a tag was left open. `(3:5)` is line 3, column 5: where the `<p>` starts.
- **Fix:** add the closing `</p>`.

## `Invalid reference LWC of type module`

The deploy fails with:

```
Invalid reference LWC of type module in file customerCard.js
```

- **Why:** module names are case-sensitive, and the import says `'LWC'`.
- **Fix:** write it in small letters: `import { LightningElement } from 'lwc';`

## It deploys, but the page shows "A Component Error has occurred!"

The deploy succeeds. When the page opens, it shows **A Component Error has occurred!** with this message:

```
[object Object] is not a valid component, or does not extends LightningElement from "lwc". You probably forgot to add the extend clause on the class declaration.
```

- **Why (in our case):** the word `default` was dropped: `export class CustomerCard …`.
- **Fix:** `export default class CustomerCard extends LightningElement {}`.

## A closing tag twice

The VS Code we recorded with doesn't type closing tags for you. Yours probably does: type `<h1>` and it adds `</h1>` by itself. If you type the closing tag too, you get it twice, `</h1></h1>`. Delete one.

## Deployed a change, but the page shows the old text

Refresh the tab. If the old text is still there, do a hard refresh: hold **Shift** and click reload. Salesforce's guide says to hard refresh after you deploy. In the video, a normal refresh was enough.

## Conflicts when you deploy into an org you've used before

Say you deployed a component from one project, deleted it from the org, and then deployed it again from a fresh project (for example, this folder). Every file is marked Conflict, and the deploy stops with:

```
Error (1): There are changes in the org that conflict with the local changes you're trying to deploy.
```

- **Why:** the org tracks every deploy, and the fresh project doesn't know that history. We saw it in a scratch org, which tracks changes. If you use a scratch org or a sandbox for the playlist, you may see it too.
- **Fix:** reset the tracking, then deploy again:

  ```bash
  sf project reset tracking --target-org desk-org --no-prompt
  ```

## Things you'll see that aren't errors

- `SFDX: Create Lightning Web Component` first asks **"Select template type"**: pick **default**, a standard component in JavaScript. Then it asks for the name, then for the folder: accept `force-app/main/default/lwc`.
- VS Code opens `customerCard.js` by itself and creates a `__tests__` folder. The tests come in video 24. A `.css` file is optional.
- After a deploy, the Output panel doesn't open by itself. The details (`=== Deployed Source (3) ===`, `Created LightningComponentBundle …`) are in its **Salesforce Metadata** channel.
- On the page, `<h1>` looks the same size as `<p>`, because Salesforce's styles reset headings.
