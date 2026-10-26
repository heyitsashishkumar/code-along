# Troubleshooting · 05 · Calculated values with getters

These are all the errors and silent failures we hit while making **LWC from Zero #5**, each re-run with this video's `customerName` at API version `68.0`. If your error isn't listed, paste its exact text in the video's comments.

## `Full name:` stays empty when you type (no error)

Check two things:

1. **The getter has `return`.**
   - Writing ``get fullName() { `${this.firstName} ${this.lastName}`; }`` without `return` returns `undefined`, so LWC renders nothing after `Full name:`.
   - **Fix:** `return \`${this.firstName} ${this.lastName}\`;`.
2. **`{fullName}` in `.html` is spelt with the exact same name and capitals as `get fullName()` in `.js`.**
   - A typo like `{fulName}` deploys without an error and always shows nothing.

## The page shows "A Component Error has occurred!" with `firstName is not defined`

When the component renders or when you type, Salesforce shows the **A Component Error has occurred!** dialog with:

```
firstName is not defined
```

- **Why:** inside `get fullName()`, `firstName` or `lastName` was written without `this.` (`return \`${firstName} ${lastName}\`;`).
- **Fix:** write `this.firstName` and `this.lastName`:

  ```js
  get fullName() {
      return `${this.firstName} ${this.lastName}`;
  }
  ```

## The page shows "A Component Error has occurred!" with `t.fullName is not a function`

When the page loads, Salesforce shows **A Component Error has occurred!** with:

```
t.fullName is not a function
```

(`t` is the minified variable name in Salesforce's compiled template code.)

- **Why:** the template called the getter with round brackets, `<p>Full name: {fullName()}</p>`. A getter is read like a field, without brackets.
- **Fix:** remove the brackets in `.html`: `<p>Full name: {fullName}</p>`.

## The page prints `Full name: fullName(){return ...}`

Instead of the customer's name, the page prints your JavaScript function's source code:

```
Full name: fullName(){return`${this.firstName} ${this.lastName}`}
```

- **Why:** the keyword `get` was left out before `fullName()` in `.js`, so `fullName` is a normal method, and `{fullName}` in the template converts the function itself to text.
- **Fix:** put `get` in front: `get fullName() { ... }`.

## The page prints `Full name: ${this.firstName} ${this.lastName}` literally

- **Why:** the getter used single quotes `'...'` or double quotes `"..."` instead of backticks `` `...` ``. Only backticks make a template literal in JavaScript.
- **Fix:** wrap the string in backticks: `` return `${this.firstName} ${this.lastName}`; ``.

## `LWC1210: Template expression doesn't allow BinaryExpression`

In a project with `apiVersion` `65.0` or lower in `.js-meta.xml`, writing `<p>Full name: {firstName + lastName}</p>` in the template fails to deploy with:

```
LWC1535: Unexpected plugin compilation error: Plugin - lwc, Hook - transform, Cause - Invalid expression {firstName + lastName} - LWC1210: Template expression doesn't allow BinaryExpression. The current component API version (65) is insufficient and must be increased to at least 66 for this type of expression. (2:8)
```

- **Why:** LWC templates at API `65.0` and lower allow only a property or getter name inside `{...}`. At API `66.0` and higher (`68.0` in new components), `{firstName + lastName}` deploys, though Salesforce's LWC Developer Guide still recommends getters because they have a name, can hold real logic, can be unit-tested, and work in directives like `lwc:if`.
- **Fix:** compute the value in a getter (`get fullName()`) and bind `{fullName}` in the template.
