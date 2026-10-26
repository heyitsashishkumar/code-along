# Troubleshooting · 02 · Set up and your first line of Apex

Every error we hit while making **Apex from Zero #2**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## Missing semicolon `;` at the end of a line

You run `System.debug('Namaste from Sharma Traders!')` without the `;` at the end and see:

```
Compilation failed at Line 1 column 13 with the error:

Unexpected token '('.
```

Or on a two-line script where the first line (`String customerName = 'Ravi'`) is missing `;`:

```
Compilation failed at Line 1 column 8 with the error:

Unexpected token 'customerName'.
```

- **Why:** Unlike JavaScript, Apex requires a semicolon `;` at the end of every statement. Without it, the compiler tries to join the line to whatever comes next and points near the start of the expression.
- **Fix:** Put `;` at the end of every statement:

  ```apex
  System.debug('Namaste from Sharma Traders!');
  ```

## Double quotes `"` instead of single quotes `'`

You write `System.debug("Namaste from Sharma Traders!");` with double quotes.

- **Why:** In Apex, strings **always** use single quotes `'...'`, never double quotes.
- **Fix:** Replace `"` with `'`: `System.debug('Namaste from Sharma Traders!');`.

## `zsh: command not found: sf`

- **Why:** The terminal was opened before the Salesforce CLI finished installing.
- **Fix:** Close the terminal (or restart VS Code), open a new terminal, and run `sf --version` again. On Windows, close and reopen PowerShell and VS Code.
