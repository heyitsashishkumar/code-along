# Troubleshooting · 23 · Modals, Alerts, Labels and Static Resources

These are all the errors and traps we hit while making **LWC from Zero #23**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## Clicking "Cancel" (or the `X` button) on `NoteModal` still tries to save or shows the "Nothing to save" alert

- **Why:** when the user clicks the `X` close icon in the modal header or `this.close()` is called with no argument (`handleCancel()`), `await NoteModal.open(...)` resolves to `undefined`. If you check `if (!note)` instead of `if (note === undefined)` first, cancelling and saving an empty string `''` get mixed up.
- **Fix:** check `if (note === undefined) { return; }` first (user cancelled), and then check `if (!note.trim())` for an empty note when the user clicked **Save**.

## `NoteModal` doesn't receive `customerName`

- **Why:** any property passed inside `NoteModal.open({ size: 'small', customerName: this.name })` must be decorated with `@api` inside `NoteModal` (`@api customerName;`).
- **Fix:** declare `@api customerName;` inside `noteModal.js`.

## Static resource logo doesn't appear (`404` or broken image icon)

- **Why:** the static resource requires both the file (`force-app/main/default/staticresources/sharmaTradersLogo.svg`) and its metadata file (`sharmaTradersLogo.resource-meta.xml`), and the import path `@salesforce/resourceUrl/sharmaTradersLogo` is case-sensitive.
- **Fix:** ensure both files are in `force-app/main/default/staticresources/` and deployed to your org.
