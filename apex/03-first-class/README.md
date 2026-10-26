# 03 · Your first Apex class and method

The code for **Apex from Zero #3**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

**`DeskGreeter`**, the first Apex class saved in your org for Sharma Traders' customer desk:

**`force-app/main/default/classes/DeskGreeter.cls`**

```apex
public with sharing class DeskGreeter {
    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Namaste, friend! Welcome to Sharma Traders.';
        }
        return 'Namaste, ' + customerName.trim() + '! Welcome to Sharma Traders.';
    }
}
```

## Deploy and run it

1. **Deploy the class to your org** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app/main/default/classes/DeskGreeter.cls --target-org desk-org
   ```

   *(Or in VS Code: open `DeskGreeter.cls` and run `SFDX: Deploy This Source to Org` from the Command Palette: `⇧⌘P` on Mac, `Ctrl+Shift+P` on Windows.)*

2. **Call it from anonymous Apex:**

   Run this line in `scripts/apex/hello.apex` with `SFDX: Execute Anonymous Apex with Editor Contents` (or `sf apex run --file scripts/apex/hello.apex --target-org desk-org`):

   ```apex
   System.debug(DeskGreeter.greet('Ravi Verma'));
   ```

## What you should see

```
|USER_DEBUG|[1]|DEBUG|Namaste, Ravi Verma! Welcome to Sharma Traders.
```

**Your small task:** add a second method `public static String farewell(String customerName)` that returns `'Dhanyavaad, ' + customerName + '! See you soon.'`, deploy the class, and call it.
