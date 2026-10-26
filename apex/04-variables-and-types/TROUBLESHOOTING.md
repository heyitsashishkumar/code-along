# Troubleshooting · 04 · Variables, types, dates, and `null`

Every error we hit while making **Apex from Zero #4**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Illegal assignment from Decimal to Integer` (or `from String to Integer`)

You write `Integer amount = 180000.50;` or `Integer count = '10';` and get:

```
Illegal assignment from Decimal to Integer
```

or:

```
Illegal assignment from String to Integer
```

- **Why:** Every variable in Apex has a fixed type. Any number with a decimal point (or the result of multiplying by `0.18`) is a `Decimal`, and text in single quotes is a `String`. Apex won't silently chop off paise or parse text into an `Integer`.
- **Fix:** Use `Decimal` for currency and percentages (`Decimal amount = 180000.50;`), or convert explicitly with `Integer.valueOf('10')`.

## `System.NullPointerException: Attempt to de-reference a null object`

Your code compiles and deploys, then crashes when run:

```
System.NullPointerException: Attempt to de-reference a null object
```

- **Why:** A variable holds `null` (an empty box), and your code tried to call a method on it (`customerName.toUpperCase()`) or read a field on it (`customer.MailingCity`) with a plain dot `.`.
- **Fix:** Use the safe navigation operator `?.` (`customer?.MailingCity`, which quietly evaluates to `null` instead of crashing when `customer` is `null`), or guard with `!= null` / `String.isBlank(...)`.
