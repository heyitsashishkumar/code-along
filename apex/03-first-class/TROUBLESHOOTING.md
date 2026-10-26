# Troubleshooting · 03 · Your first Apex class and method

Every error we hit while making **Apex from Zero #3**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `Non static method cannot be referenced from a static context: String DeskGreeter.greet(String)`

You deploy `DeskGreeter.cls`, call `DeskGreeter.greet('Ravi')` in anonymous Apex, and get:

```
Non static method cannot be referenced from a static context: String DeskGreeter.greet(String)
```

- **Why:** You wrote `public String greet(String customerName)` without the word `static`. Without `static`, the method can only be called on an instance (`new DeskGreeter().greet('Ravi')`), not on the class name `DeskGreeter`.
- **Fix:** Add `static` to the method signature and deploy `DeskGreeter.cls` again:

  ```apex
  public static String greet(String customerName)
  ```

## `Missing ';' at '}' (4:5)`

The deploy fails with:

```
Missing ';' at '}' (4:5)
```

- **Why:** The `return` statement on the line before `}` is missing its trailing semicolon `;`.
- **Fix:** Add `;` at the end of the `return` line, save, and deploy again.

## You edited `DeskGreeter.cls`, ran your script, and still got the old output

- **Why:** Anonymous Apex runs in your org on Salesforce's servers. Editing `DeskGreeter.cls` on your laptop doesn't change the org's copy until you deploy.
- **Fix:** Save `DeskGreeter.cls` and run `SFDX: Deploy This Source to Org` (or `sf project deploy start`) before running your anonymous script.
