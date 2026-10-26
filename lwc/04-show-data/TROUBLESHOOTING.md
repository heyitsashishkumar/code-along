# Troubleshooting · 04 · Show data, and react to typing

These are all the errors and silent failures we hit while making **LWC from Zero #4**, each re-run with this video's `customerGreeting` at API version `68.0`. If your error isn't listed, paste its exact text in the video's comments.

## You type in the input box and nothing changes (no error on the page)

The greeting stays `Namaste, friend!` while you type, and the browser console shows only `Script error.`

Check two things:

1. **The handler's name in `.html` matches the method in `.js`, letter for letter.**
   - In the video, Priya wrote `onchange={handleNameChang}` (missing the `e`), while the method was `handleNameChange(event)`.
   - **Fix:** make both names identical (`onchange={handleNameChange}` and `handleNameChange(event)`), save, deploy and refresh.
2. **You wrote `this.` before the field name inside the method.**
   - Writing `customerName = event.target.value;` without `this.` looks for a plain variable instead of this component's field, so the field never changes.
   - **Fix:** write `this.customerName = event.target.value;`.

## The page shows `Namaste, !` from the start and never changes

- **Why:** the property name inside `{...}` in `.html` doesn't match the field name in `.js`, including capitals (for example, `{customername}` with a lowercase `n` instead of `{customerName}`). LWC deploys it without an error and treats the unknown property as empty.
- **Fix:** match the exact spelling and capitals of the field in `.js`: `{customerName}`.

## `LWC1083: Error parsing template expression: expression must end with curly brace`

The deploy fails with:

```
LWC1535: Unexpected plugin compilation error: Plugin - lwc, Hook - transform, Cause - Invalid expression Namaste, {customerName! - LWC1083: Error parsing template expression: expression must end with curly brace. (2:8)
```

- **Why:** `{customerName` was opened with `{` on line 2, column 8, and never closed with `}`.
- **Fix:** add the closing `}`: `<p>Namaste, {customerName}!</p>`.

## Quotes around `{handleNameChange}`

Some tutorials write `onchange="{handleNameChange}"` with quotes around the curly braces. At API `68.0`, both `onchange={handleNameChange}` and `onchange="{handleNameChange}"` work the same way. Salesforce's style guide leaves the quotes out.

## Things you'll see that aren't errors

- Clearing the input box leaves `customerName` as an empty string `""`, so `<p>Namaste, {customerName}!</p>` shows `Namaste, !`.
- If your editor window is narrow or the Explorer sidebar is open, the 89-character `<lightning-input ...>` line may scroll sideways as you type. Press `⌘B` on a Mac (`Ctrl+B` on Windows) to hide or show the Explorer sidebar.
