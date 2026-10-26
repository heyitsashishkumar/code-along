# Troubleshooting · 06 · Show or hide parts of the page

These are all the errors we hit while making **LWC from Zero #6**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse-05` at API `68.0`), never from memory.

The video was recorded on a Mac. Nothing was tested on Windows, so if a Windows message differs, it's described here, never quoted. If your error isn't listed, paste its exact text in the video's comments.

## `LWC1058: Invalid HTML syntax: unexpected-character-in-attribute-name`

Writing a comparison with `<` directly inside the directive without quotes — for example, `<template lwc:elseif={orderCount < 10}>` — underlines the line in red in VS Code right away, and the deploy fails with:

```
LWC1058: Invalid HTML syntax: unexpected-character-in-attribute-name. For more information, please visit https://html.spec.whatwg.org/multipage/parsing.html#parse-error-unexpected-character-in-attribute-name (6:38)
```

Without spaces (`lwc:elseif={orderCount<10}`), it gives:

```
LWC1058: Invalid HTML syntax: unexpected-character-in-unquoted-attribute-value. For more information, please visit https://html.spec.whatwg.org/multipage/parsing.html#parse-error-unexpected-character-in-unquoted-attribute-value (6:37)
```

With `===` (`lwc:if={orderCount === 0}`), it gives:

```
LWC1058: Invalid HTML syntax: unexpected-equals-sign-before-attribute-name. For more information, please visit https://html.spec.whatwg.org/multipage/parsing.html#parse-error-unexpected-equals-sign-before-attribute-name (3:34)
```

And with `>` (`lwc:if={orderCount > 10}`), the `>` closes the `<template>` tag early, so the deploy fails with:

```
LWC1159: lwc:if directive value should be an expression (3:15)
```

- **Why:** in HTML, `<`, `>` and `=` have special meaning inside an unquoted attribute value, so the HTML parser breaks before the LWC compiler even sees the expression.
- **What happens if you add double quotes (`lwc:elseif="{orderCount < 10}"`):** in projects at API version `66.0` and later, the org accepts quoted complex template expressions as an experimental feature, and the component deploys and works. However, VS Code's LWC extension (`68.4.0`) still underlines it in red in the Problems panel with:

  ```
  LWC1034: Ambiguous attribute value lwc:elseif="{orderCount < 10}". If you want to make it a valid identifier you should remove the surrounding quotes
  ```

  And Salesforce's *HTML Template Directives* guide still recommends putting the comparison in a getter.
- **Fix:** put the comparison in a getter (`get isRegularCustomer() { return this.orderCount < 10; }`) and pass the getter's name to the directive (`lwc:elseif={isRegularCustomer}`). It has a clear name, works in every project, and produces no editor warnings.

## `LWC1165: 'lwc:elseif' directive must be used immediately after an element with 'lwc:if' or 'lwc:elseif'`

The deploy fails with:

```
LWC1165: 'lwc:elseif' directive must be used immediately after an element with 'lwc:if' or 'lwc:elseif'. No such element found. (6:5)
```

(Or the same message for `'lwc:else'`.)

- **Why:** one of three things happened:
  1. You mixed the old `if:true` directive with `lwc:elseif` or `lwc:else` (`<template if:true={isNewCustomer}>` followed by `<template lwc:elseif={isRegularCustomer}>`).
  2. You put another tag (such as `<p>Thank you!</p>`) between the `<template lwc:if={...}>` block and the `<template lwc:elseif={...}>` or `<template lwc:else>` block.
  3. You started with `lwc:elseif` without an `lwc:if` right before it.
- **Fix:** use `lwc:if`, `lwc:elseif` and `lwc:else` as one unbroken chain of sibling `<template>` tags, with no other tags between them.

## `LWC1166: 'if:false' directive cannot be used with 'lwc:if', 'lwc:elseif', or 'lwc:else directives on the same element`

Putting both the old and new directives on the same `<template>` tag fails to deploy with:

```
LWC1166: 'if:false' directive cannot be used with 'lwc:if', 'lwc:elseif', or 'lwc:else directives on the same element. (3:5)
```

- **Fix:** use only `lwc:if` / `lwc:elseif` / `lwc:else` in new code.

## `LWC1080: Root template has unknown or disallowed attributes: lwc:if`

Putting `lwc:if` on the outer `<template>` tag (line 1 of the HTML file) fails to deploy with:

```
LWC1080: Root template has unknown or disallowed attributes: lwc:if (1:1)
```

- **Why:** the root `<template>` is the component's shell and cannot have conditional directives on it.
- **Fix:** keep the outer `<template>` plain, and put `lwc:if` on a nested `<template>` inside it.

## `LWC1161: lwc:else directive cannot have a value`

Writing `<template lwc:else={isTopCustomer}>` fails to deploy with:

```
LWC1161: lwc:else directive cannot have a value (9:5)
```

- **Why:** `lwc:else` is the catch-all branch ("otherwise") when neither `lwc:if` nor `lwc:elseif` was true, so it doesn't ask a question of its own.
- **Fix:** write `<template lwc:else>` with no `={...}`.

## Typing `0` shows "Regular customer: thank them for coming back." instead of "New customer"

The component deploys with no error, `5` shows Regular customer, `12` shows Top customer, and then typing `0` still shows **Regular customer: thank them for coming back.**

- **Why:** `event.target.value` from `lightning-input` is always a string (text), even when `type="number"`. If your handler wrote `this.orderCount = event.target.value;` without `Number(...)`, then typing `0` sets `this.orderCount` to the string `'0'`. In JavaScript, `'0' === 0` is `false` (a string is not strictly equal to a number), while `'0' < 10` is `true`, so `isNewCustomer` is `false` and `isRegularCustomer` wins.
- **Fix:** convert the input value to a number in the handler:

  ```js
  handleOrderCountChange(event) {
      this.orderCount = Number(event.target.value);
  }
  ```

## A long line in the template runs off the right side of VS Code

Line 2 (`<lightning-input type="number" ...>`) is 131 characters long and scrolls horizontally past the edge of a narrow editor window.

- **Fix:** turn on word wrap in VS Code with `⌥Z` on a Mac, `Alt+Z` on Windows, or **View: Toggle Word Wrap** in the command palette.
