# 047 · Your first Apex class

The code at the end of **video 47** of *LWC & Apex from Zero: Code Along*, "Your First Apex Class: Write It Once, Call It Anywhere". Type it yourself first, then compare your files with these.

## What you built

**`DeskGreeter.cls`**, with one static method:

```java
public with sharing class DeskGreeter {
    public static String greet(String customerName) {
        if (String.isBlank(customerName)) {
            return 'Hello, friend!';
        }
        return 'Hello, ' + customerName + '!';
    }
}
```

**`scripts/apex/047-greet.apex`** calls it:

```java
System.debug(DeskGreeter.greet('Ryan Walker'));
System.debug(DeskGreeter.greet(''));
```

## Deploy it

Open this folder in VS Code (File, Open Folder) and connect your org with `SFDX: Authorize an Org`, as in video 5. If you're coding along in your own `miller-desk` project, that's already done.

Then open the command palette (`⇧⌘P` on a Mac, `Ctrl+Shift+P` on Windows) and run `SFDX: Deploy This Source to Org` on the `force-app` folder, or, in the terminal, from inside this folder:

```bash
sf project deploy start --source-dir force-app --target-org desk-org
```

Then open `scripts/apex/047-greet.apex` and run `SFDX: Execute Anonymous Apex with Editor Contents`. The Output panel shows `Hello, Ryan Walker!` and `Hello, friend!`.
