# Troubleshooting · 05 · Lists and loops

Every error we hit while making **Apex from Zero #5**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.ListException: List index out of bounds: 2`

You create a list with 2 items and read `amounts[2]`:

```apex
List<Decimal> amounts = new List<Decimal>{ 180000, 95000 };
System.debug(amounts[2]);
```

And the run fails with:

```
System.ListException: List index out of bounds: 2
```

- **Why:** Apex lists start counting at `0`. A 2-item list only has positions `0` and `1` (`amounts.size() - 1`). Reading `amounts[0]` on an empty list throws `System.ListException: List index out of bounds: 0`.
- **Fix:** Check `!amounts.isEmpty()` (or `index < amounts.size()`) before reading by index, or loop over the list with `for (Decimal amount : amounts)`.

## `System.NullPointerException: Attempt to de-reference a null object` when calling `.add()` or looping

- **Why:** You declared `List<Decimal> result;` without `= new List<Decimal>()`, or someone passed `null` into your method parameter `List<Decimal> amounts`.
- **Fix:** Always initialize a new list with `new List<Decimal>()`, and check `if (amounts == null) return result;` before looping.
