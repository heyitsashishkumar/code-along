# Troubleshooting · 08 · Make It Look Like Salesforce

These are all the errors and traps we hit while making **LWC from Zero #8**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## The `lightning-card` has no icon, and there is no error (`icon-name="standard:contacts"`)

If you write a plural or misspelled icon name on `lightning-card` — such as `icon-name="standard:contacts"` instead of `icon-name="standard:contact"` — the deploy succeeds, and the card renders on the page with **no icon**, no error dialog, and no message in the browser console.

- **Why:** `lightning-card` silently ignores unknown icon names.
- **Fix:** use the exact singular SLDS icon name (`standard:contact`, `standard:customers`, `standard:rtc_presence`, `standard:product`) in `category:name` format, all lowercase.

## Writing `.slds-card { background: #fff8ee; }` in `customerCard.css` does nothing

If you try to target `.slds-card` directly inside `customerCard.css`, the card stays white.

- **Why:** Shadow DOM isolates `<lightning-card>`'s internal markup from your component's CSS selectors. Your `.css` file can only style tags in your own `.html` file, plus the component's host element (`:host`).
- **Fix:** set the SLDS styling hook on `:host` so `<lightning-card>` picks it up across the shadow boundary:

  ```css
  :host {
      --slds-c-card-color-background: #fff8ee;
  }
  ```

## The CSS file is ignored completely

- **Check the file name:** the stylesheet inside `force-app/main/default/lwc/customerCard/` must be named `customerCard.css` (matching the folder name with the exact same casing), and the stylesheet inside `productList/` must be `productList.css`.

## Yellow wavy underlines in `.css` from the SLDS Validator

When you type `#fff8ee`, `#2e844a` or `white` in `customerCard.css` or `productList.css`, the Salesforce Extension Pack's **SLDS Validator** may underline the color in yellow and suggest an SLDS styling token.

- **Why:** it's a design recommendation from the VS Code extension, not a compiler error.
- **Fix:** you can safely deploy as-is — yellow SLDS Validator warnings never block `sf project deploy start`.
