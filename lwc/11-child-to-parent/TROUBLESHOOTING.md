# Troubleshooting · 11 · Send a Message Up: Child to Parent (`CustomEvent`)

These are all the traps we hit while making **LWC from Zero #11**, tested on our own org (`lwc-long` and `lwc-rehearse` at API `68.0`). Notice that event mistakes in JavaScript almost never fail to deploy — they fail silently when you click.

## Clicking a tile does nothing, with no error in VS Code or the browser

Check these four spots in order:

1. **Did you write `new CustomEvent('onselect', ...)` instead of `new CustomEvent('select', ...)`?**
   - **Why:** LWC automatically puts `on` in front of your event name when the parent listens in HTML. An event named `'select'` is listened to with `onselect={handleSelect}`. If you name the event `'onselect'`, the parent would have to write `ononselect={handleSelect}` — so `onselect={handleSelect}` never hears it.
   - **Fix:** name the event `'select'` (no `on` prefix) inside `new CustomEvent('select', ...)`.

2. **Did you use a capital letter in the event name (such as `'Select'` or `'contactSelect'`)?**
   - **Why:** HTML attributes are lowercased by the browser, so `onContactSelect` in a template won't match a mixed-case event name the way you expect.
   - **Fix:** keep custom event names all lowercase (`'select'`).

3. **Did you create `selectEvent` but forget `this.dispatchEvent(selectEvent)`?**
   - **Why:** `new CustomEvent(...)` only builds the message object in memory; `this.dispatchEvent(selectEvent)` is what actually sends it up to the parent.

4. **Did you write `event.detail.Id` in `handleSelect` when `detail` is already `this.contact.Id`?**
   - **Why:** in `contactTile.js`, we passed `{ detail: this.contact.Id }` — a string like `'1'`, not the whole contact object. On a string, `.Id` is `undefined`, so `this.contacts.find(...)` never finds a match.
   - **Fix:** read `this.selectedId = event.detail;` in `contactList.js`.
