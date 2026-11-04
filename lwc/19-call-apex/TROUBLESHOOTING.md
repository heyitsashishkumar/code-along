# Troubleshooting · 19 · Call Apex on a Click (`async`/`await`, `lightning-spinner` and `try`/`catch`/`finally`)

These are all the errors and traps we hit while making **LWC from Zero #19**, each checked against our own org (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

## `LWC1503: Parsing error: Unexpected reserved word 'await'. (12:24)` (`T27`)

Using `await getDeals({ accountId: this.recordId })` inside `handleLoad()` without writing `async` before `handleLoad()` fails at deploy time with:

```
LWC1503: Parsing error: Unexpected reserved word 'await'. (12:24)
```

- **Why:** JavaScript only allows `await` inside a function or method marked `async`.
- **Fix:** declare `async handleLoad()`.

## Clicking "Show deals" returns no deals (or an invalid ID error) when passing `'$recordId'`

If you write `await getDeals({ accountId: '$recordId' })` with quotes and a `$` prefix inside `handleLoad()`:

- **Why:** the quoted `'$recordId'` reactive syntax only belongs inside `@wire(...)` configuration objects. In an imperative function call, JavaScript passes the literal 9-character string `'$recordId'` as `accountId` instead of the Account's 18-character ID.
- **Fix:** pass the property value directly without quotes or `$`:

  ```js
  this.deals = await getDeals({ accountId: this.recordId });
  ```

## `lightning-spinner` covers the entire browser page instead of just the Deals card

- **Why:** `lightning-spinner` uses `position: absolute` and sizes itself to its nearest ancestor that has `position: relative`. If no container inside your component has `position: relative`, the spinner stretches across the whole Lightning page.
- **Fix:** add `.deals { position: relative; min-height: 2rem; }` in `customerDeals.css`.

## The spinner stays spinning forever when `getDeals` throws an error

- **Why:** if `this.isLoading = false;` is placed at the bottom of the `try` block instead of inside `finally`, any error thrown by `await getDeals(...)` jumps straight to `catch` and skips `this.isLoading = false;`.
- **Fix:** always put `this.isLoading = false;` inside `finally { ... }`, which runs whether the Promise resolves or rejects.
