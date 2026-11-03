# Troubleshooting · 12 · Event Bubbling, `@api` Setters, and Calling a Child (`lwc:ref`)

These are all the errors we hit while making **LWC from Zero #12**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## Moving `onselect={handleSelect}` to the `<div>` stops tile clicks from working

If you move `onselect={handleSelect}` from `<c-contact-tile>` up to the surrounding `<div class="slds-p-horizontal_small" onselect={handleSelect}>` in `contactList.html` without adding `bubbles: true` in `contactTile.js`, clicking a tile shows no `Selected:` line and no error.

- **Why:** by default (`bubbles: false`), a custom event only fires on the `<c-contact-tile>` tag that dispatched it; it does not travel up to the parent `<div>`.
- **Fix:** add `bubbles: true` to `new CustomEvent('select', { detail: this.contact.Id, bubbles: true })` in `contactTile.js`.

## `LWC1503: "contact" has already been declared as a public property. (12:5)`

Putting `@api` on **both** `get contact()` and `set contact(value)` (or leaving the old `@api contact;` field in the class alongside `get contact()`) fails to deploy with:

```
LWC1503: "contact" has already been declared as a public property. (12:5)
```

- **Why:** a getter and setter pair defines a single property; LWC wants `@api` on only one of them (by convention, on `get contact()`), and the backing value stored in a private field with a different name (`_contact`).
- **Fix:** remove `@api contact;`, store the value in `_contact`, and put `@api` only above `get contact()`.

## Clicking "Clear selection" does nothing (`Script error. null` in the console)

If `Selected: Ravi Verma, +91 90000 00109` stays on screen when you click **Clear selection**, check two things:

1. **Did you forget `@api` above `clearSelection()` in `contactList.js`?**
   - **Why:** methods on a child component are private by default, just like properties. Without `@api`, `this.refs.contactList.clearSelection` is not exposed to `customerDesk`, and clicking the button logs `Script error. null` in the browser console.
   - **Fix:** import `api` in `contactList.js` and add `@api` right above `clearSelection()`.

2. **Does `this.refs.contactList` match `lwc:ref="contactList"` with the exact same casing?**
   - **Why:** `this.refs` is case-sensitive. Writing `this.refs.contactlist.clearSelection()` (lowercase `l`) when the template says `lwc:ref="contactList"` evaluates `this.refs.contactlist` to `undefined` and logs `Script error. null`.
   - **Fix:** match the exact spelling and capital letters of `lwc:ref="contactList"`.
