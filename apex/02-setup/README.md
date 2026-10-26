# 02 · Set up everything, and run your first line of Apex

The code for **Apex from Zero #2**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

- Your free Salesforce **Developer Edition** org, **VS Code**, **Java 21**, the **Salesforce CLI**, and the **Salesforce Extension Pack**.
- A Salesforce DX project called **`customer-desk`**, connected to your org under the alias `desk-org`.
- Your first line of anonymous Apex in **`scripts/apex/hello.apex`**:

```apex
// Video 2: Run your first line of anonymous Apex in Sharma Traders' org.
System.debug('Namaste from Sharma Traders!');
```

## Run it in your org

Open this folder in VS Code (File, Open Folder) and connect your org (`SFDX: Authorize an Org`, alias `desk-org`).

Then run `scripts/apex/hello.apex` either way:

- **In VS Code:** open `scripts/apex/hello.apex`, open the Command Palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows), and run **`SFDX: Execute Anonymous Apex with Editor Contents`**.
- **Or in the terminal** (Mac or Windows PowerShell), from inside the project folder:

  ```bash
  sf apex run --file scripts/apex/hello.apex --target-org desk-org
  ```

## What you should see

In the Output panel (or terminal), Salesforce compiles and executes your line and prints a debug log containing:

```
Compiled successfully.
Executed successfully.
...
|USER_DEBUG|[2]|DEBUG|Namaste from Sharma Traders!
```

**Your small task:** add a second `System.debug(...)` line that prints `'Deals today: ' + 3`, run the file again, and find both `USER_DEBUG` lines in the log.
