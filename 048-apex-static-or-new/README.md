# 048 · static or new?

The code at the end of **video 48** of *LWC & Apex from Zero: Code Along*, "static or new? Two Ways to Call a Method". Type it yourself first, then compare your files with these.

## What you built

**`DeskGreeter.cls`** gets a field, a constructor and a method that needs an object:

```java
public with sharing class DeskGreeter {
    String shopName;

    public DeskGreeter(String shopName) {
        this.shopName = shopName;
    }

    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Hello, friend!';
        }
        return 'Hello, ' + customerName + '!';
    }

    public String welcome(String customerName) {
        return 'Hello, ' + customerName
            + '! Welcome to ' + shopName + '.';
    }
}
```

**`scripts/apex/048-static-or-new.apex`** calls it both ways:

```java
System.debug(DeskGreeter.greet('Ryan Walker'));
DeskGreeter frontDesk = new DeskGreeter('Miller Supply');
System.debug(frontDesk.welcome('Ryan Walker'));
System.debug(frontDesk.welcome('Grace Walker'));
```

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org with `SFDX: Authorize an Org`, as in video 5. If you're coding along in your own `miller-desk` project, that's already done.

Then open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Deploy This Source to Org` on the `force-app` folder, or, in the terminal, from inside this folder:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```
