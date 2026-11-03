# Troubleshooting · 13 · Build a Working Contact Search (Part 1 Capstone)

These are all the traps we hit while making **LWC from Zero #13**, tested on our own org (`lwc-long` and `lwc-rehearse` at API `68.0`).

## Typing in the search box never filters the list, and nothing is logged (`setTimeout(function () { ... })`)

If you write a regular `function () { ... }` inside `setTimeout` instead of an arrow function `() => { ... }`:

```js
// Broken:
this.delayTimeout = setTimeout(function () {
    this.searchKey = searchKey;
}, DELAY);
```

the deploy succeeds, and when you type in the search box nothing updates on the page and no error appears in the console.

- **Why:** inside `function () { ... }`, `this` is not your `ContactSearch` component instance, so `this.searchKey = searchKey` never updates the component's `searchKey` property. An arrow function `() => { ... }` keeps `this` bound to the component.
- **Fix:** always use an arrow function inside `setTimeout`:

  ```js
  this.delayTimeout = setTimeout(() => {
      this.searchKey = searchKey;
  }, DELAY);
  ```

## Typing lowercase `ravi` or `gupta` finds zero customers

- **Why:** JavaScript's `.includes()` is case-sensitive (`'Ravi Verma'.includes('ravi')` is `false`).
- **Fix:** call `.toLowerCase()` on **both** `this.searchKey` and `contact.Name`:

  ```js
  const key = this.searchKey.toLowerCase();
  return this.contacts.filter((contact) => contact.Name.toLowerCase().includes(key));
  ```

## The list still updates on every single keystroke

- **Why:** if you leave out `window.clearTimeout(this.delayTimeout);` before `this.delayTimeout = setTimeout(...)` (or forget to assign the return value of `setTimeout` to `this.delayTimeout`), earlier timers aren't cancelled when the next key is pressed, so every keystroke fires 300 ms later.
- **Fix:** keep both lines together in `handleSearchChange`:

  ```js
  window.clearTimeout(this.delayTimeout);
  const searchKey = event.target.value;
  this.delayTimeout = setTimeout(() => {
      this.searchKey = searchKey;
  }, DELAY);
  ```
