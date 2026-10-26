# Troubleshooting · 07 · Lists

These are all the errors we hit while making **LWC from Zero #7**, each with its exact message copied from our own screen (`lwc-long` and `lwc-rehearse` at API `68.0`), never from memory.

The video was recorded on a Mac. Nothing was tested on Windows, so if a Windows message differs, it's described here, never quoted. If your error isn't listed, paste its exact text in the video's comments.

## `LWC1071: Missing key for element <li> inside of iterator`

If you leave `key` off the repeated `<li>` tag (or put `key` on the `<template for:each={...}>` tag instead of the `<li>`), VS Code underlines `<li` in red as soon as you type it, and the deploy fails with:

```
LWC1071: Missing key for element <li> inside of iterator. Elements within iterators must have a unique, computed key value. (5:13)
```

If you put `key={product.id}` on the `<template>` tag instead of the `<li>`, VS Code also shows a warning:

```
LWC1145: Invalid attributes detected on template. The following attributes are not supported on template tags in LWC: key. For more information, please visit https://sfdc.co/template-directives
```

- **Why:** the first real HTML element inside `<template for:each={...}>` or `<template iterator:it={...}>` must carry a unique `key` attribute so LWC can track each row when the list changes.
- **Fix:** put `key={product.id}` (or `key={it.value.id}` inside `iterator:it`) on the `<li>` tag itself.

## `LWC1055: iterator:myIt={inStockProducts} is not valid attribute for template. All attributes name should be all lowercase.`

Using a capital letter in the iterator's variable name — such as `iterator:myIt={inStockProducts}` — fails to deploy with:

```
LWC1055: iterator:myIt={inStockProducts} is not valid attribute for template. All attributes name should be all lowercase. (10:19)
```

- **Why:** HTML attribute names in LWC templates must be all lowercase, including the name after `iterator:`.
- **Fix:** use lowercase letters only, such as `iterator:it={inStockProducts}` or `iterator:item={inStockProducts}`.

## `LWC1066: Invalid key value for element <li>. Key cannot reference iterator index` (or `LWC1065`)

Using the list position (index) as the `key` inside `iterator:it` (`<li key={it.index}>`) fails to deploy with:

```
LWC1066: Invalid key value for element <li>. Key cannot reference iterator index (11:17)
```

And doing the same with `for:each` and `for:index="index"` (`<li key={index}>`) fails to deploy with:

```
LWC1065: Invalid key value for element <li>. Key cannot reference for:each index index (5:17)
```

- **Why:** an item's position changes whenever an item above it is filtered out, inserted or removed, so an index cannot identify which item is which.
- **Fix:** give each item in your data a real unique `id` (like `'p1'`, `'p2'`) and use `key={product.id}` or `key={it.value.id}`.

## `LWC1044: for:each and for:item directives should be associated together`

Writing `<template for:each={products}>` without `for:item="..."` fails to deploy with:

```
LWC1044: for:each and for:item directives should be associated together. (4:9)
```

- **Fix:** add `for:item="product"` on the same `<template>` tag as `for:each={products}`.

## `LWC1503: Parsing error: Missing semicolon. (16:21) (16:21)`

Leaving out the round brackets `(` `)` around the object `{ id: ..., label: ... }` inside `.map((product) => ...)` in `productList.js` fails to deploy with:

```
LWC1503: Parsing error: Missing semicolon. (16:21) (16:21)
```

- **Why:** after an arrow `=>`, JavaScript sees `{` as the opening brace of a function body, not an object literal. Inside a function body, `id: product.id,` looks like a label followed by a comma instead of a semicolon.
- **Fix:** wrap the returned object in round brackets so JavaScript reads `{ ... }` as an object expression:

  ```js
  .map((product) => ({
      id: product.id,
      label: `${product.name}: ₹${product.price}`
  }))
  ```

## It deploys, but the list shows `: ₹` four times (or nothing under "In stock today")

- **Four lines that read only `: ₹`:** you wrote `{products.name}: ₹{products.price}` (the array's plural name `products`) instead of `{product.name}: ₹{product.price}` (the singular `for:item="product"` name). An array has no `.name` or `.price` property, so both evaluate to `undefined`.
- **"In stock today" with nothing under it:** check that `get inStockProducts()` has the word `return` before `this.products.filter(...)`.

## Where are the bullet points on `<ul>`?

Salesforce's base styles reset `<ul>` and `<li>` so they have no bullets or left indent, just as `<h1>` was reset in video 3. Video 8 introduces `lightning-card` and SLDS classes to style the desk.
