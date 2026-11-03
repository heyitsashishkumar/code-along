# code-along

The code from the **Freestyle Cyber Hub** code-along playlists, one folder per video. Each folder holds the project exactly as it is at the end of its video, so you can check your work against it, or start the next video from it.

Today that's two companion playlists that build **Sharma Traders' customer desk** together from zero:
- **LWC from Zero: Code Along** (`lwc/`) — the front-end Lightning Web Components, one piece at a time.
- **Apex from Zero: Code Along** (`apex/`) — the Salesforce backend classes, SOQL queries, controllers, unit tests, and triggers that power the desk.

## LWC from Zero (`lwc/`)

| Video | What you build | Folder |
|---|---|---|
| 1 | Introduction: what you'll build and how to use the playlist | no code |
| 2 | Set up everything, free: your org, VS Code, the Salesforce CLI, Java, the Extension Pack, and the `customer-desk` project | [lwc/02-setup](lwc/02-setup/) |
| 3 | Your first component, on a real Salesforce page: `customerCard`, exposed, deployed and placed with Lightning App Builder | [lwc/03-first-component](lwc/03-first-component/) |
| 4 | Show data, and react to typing: `customerGreeting`, `{customerName}`, `lightning-input`, `onchange` and `this.` | [lwc/04-show-data](lwc/04-show-data/) |
| 5 | Calculated values with getters: `customerName`, `get fullName()`, and template literals | [lwc/05-getters](lwc/05-getters/) |
| 6 | Show or hide parts of the page: `customerStatus`, `lwc:if`, `lwc:elseif`, `lwc:else`, and `Number(event.target.value)` | [lwc/06-conditional](lwc/06-conditional/) |
| 7 | Lists: `productList`, `for:each`, `for:item`, `key`, `iterator:it`, `filter` and `map` | [lwc/07-lists](lwc/07-lists/) |
| 8 | Make it look like Salesforce: `lightning-card`, SLDS spacing & typography classes, `.css` files, and `:host` styling hooks | [lwc/08-look-like-salesforce](lwc/08-look-like-salesforce/) |
| 9 | Put one component inside another (composition): `customerDesk` holding `<c-customer-card>` and `<c-customer-greeting>`, kebab-case tags, and `<isExposed>` | [lwc/09-composition](lwc/09-composition/) |
| 10 | Pass data down (parent to child): `contactTile` (`@api contact`) repeated inside `contactList` | [lwc/10-parent-to-child](lwc/10-parent-to-child/) |
| 11 | Send a message up (child to parent): `new CustomEvent('select', { detail })`, `this.dispatchEvent`, and `onselect={handleSelect}` | [lwc/11-child-to-parent](lwc/11-child-to-parent/) |
| 12 | Event bubbling, `@api` setters, and calling a child method: `bubbles: true`, `@api get contact()` / `set contact(value)` initials badge, `@api clearSelection()`, and `lwc:ref` (`this.refs`) | [lwc/12-events-and-methods](lwc/12-events-and-methods/) |
| 13 | Build a working contact search (Part 1 capstone): `contactSearch` with 300 ms debounced `setTimeout`, case-insensitive filtering, and `<c-contact-tile>` selection | [lwc/13-contact-search](lwc/13-contact-search/) |
| 14 | Show and edit real Salesforce records: `customerForm` on a Contact record page (`lightning__RecordPage`, `@api recordId`, and `lightning-record-form`) | [lwc/14-record-forms](lwc/14-record-forms/) |
| 15 | Read a record into your own HTML: `customerSummary` with `@wire(getRecord, ...)`, `@salesforce/schema/Contact.*` imports, `'$recordId'`, and `getFieldValue` | [lwc/15-read-a-record](lwc/15-read-a-record/) |
| 16 | Create, update and delete a record from your own buttons: `newCustomer` (`createRecord`, `updateRecord`, `deleteRecord`, `ShowToastEvent`), `ldsUtils` (`reduceErrors`), and `errorPanel` | [lwc/16-create-update-delete](lwc/16-create-update-delete/) |
| 17 | Picklists and object info without hardcoding: `leadSourcePicker` chaining `@wire(getObjectInfo)` into `@wire(getPicklistValues)` with `'$objectInfo.data.defaultRecordTypeId'` | [lwc/17-picklists](lwc/17-picklists/) |

## Apex from Zero (`apex/`)

| Video | What you build | Folder |
|---|---|---|
| 1 | Introduction: what Apex is, how it powers Sharma Traders' customer desk, and how to use the playlist | no code |
| 2 | Set up everything and run your first line of Apex: `scripts/apex/hello.apex` and `System.debug('Namaste from Sharma Traders!');` | [apex/02-setup](apex/02-setup/) |
| 3 | Your first Apex class and method: `DeskGreeter.cls`, `public with sharing`, `public static String greet(String customerName)` | [apex/03-first-class](apex/03-first-class/) |
| 4 | Variables, types, dates, and `null`: `DealCalculator.cls` (18% GST with `Decimal`, festival discounts with `Boolean`, follow-up `Date.today().addDays(30)`, and safe navigation `?.`) | [apex/04-variables-and-types](apex/04-variables-and-types/) |
| 5 | Lists and loops: `DealFilter.cls` (`List<Decimal>`, `.add()`, `.sort()`, `for (Decimal amount : amounts)`, filtering high-value deals and summing totals) | [apex/05-lists-and-loops](apex/05-lists-and-loops/) |
| 6 | Sets and Maps (instant lookup by key): `CityDirectory.cls` (`Set<String>`, `Map<String, String>`, `.containsKey()`, `.get()`) | [apex/06-sets-and-maps](apex/06-sets-and-maps/) |
| 7 | SObjects and DML (`insert`, `update`, `delete` in bulk): `CustomerOnboarding.cls` creating, updating, and cleaning up `Account` and `Contact` records with one DML statement per list | [apex/07-sobjects-and-dml](apex/07-sobjects-and-dml/) |
| 8 | Partial saves and handling DML errors: `Database.insert(contacts, false)`, `Database.SaveResult`, `Database.Error`, and `try` / `catch (DmlException e)` | [apex/08-database-methods](apex/08-database-methods/) |
| 9 | Read records with SOQL (`WHERE`, `:bind`, `ORDER BY`, `LIMIT`): `CustomerQueries.cls` (`getContactsByCity` and `getTopContacts`) | [apex/09-soql-basics](apex/09-soql-basics/) |
| 10 | Query related records and totals in SOQL: child-to-parent `Account.Name`, parent-to-child `(SELECT ... FROM Contacts)`, and `SUM(Amount)` with `AggregateResult` | [apex/10-soql-relationships](apex/10-soql-relationships/) |
| 11 | Keep every query and save safe (`with sharing` and `WITH USER_MODE`): upgrading `CustomerQueries` and `CustomerOnboarding` to enforce object, field, and sharing rules | [apex/11-security-and-user-mode](apex/11-security-and-user-mode/) |
| 12 | Expose Apex to LWC (`@AuraEnabled` and `ContactController`): `@AuraEnabled(cacheable=true)` (`getContactList` and `findContacts` for `@wire` in LWC #18–#19) and `AuraHandledException` | [apex/12-contact-controller](apex/12-contact-controller/) |
| 13 | Write data from LWC (`DealController`): `getDealsForContact`, `createFollowUpDeal`, and `markDealWon` for imperative Apex calls and `refreshApex` in LWC #20–#21 | [apex/13-deal-controller](apex/13-deal-controller/) |
| 14 | Test your Apex (`@IsTest`, `@TestSetup`, and `Assert`): `ContactControllerTest.cls` with positive, negative, and `AuraHandledException` tests | [apex/14-contact-controller-test](apex/14-contact-controller-test/) |
| 15 | Test DML, exceptions, and permissions (`System.runAs`): `DealControllerTest.cls` testing `createFollowUpDeal`, `markDealWon`, validation errors, and Standard User access | [apex/15-deal-controller-test](apex/15-deal-controller-test/) |

More folders are added as the videos come out. When the videos work with records, each folder also includes a `data/` folder with Sharma Traders' made-up customers, companies and deals (standard Account, Contact and Opportunity records). Load them into your org once with:

```bash
sf data import tree --plan data/plan.json
```

## How to use it with the playlists

1. **Code along in your own project.** Pause the video and type it yourself. That's what makes it stick. Video 2 shows how to make the project.
2. **Check against the video's folder.** When your screen doesn't match the video, compare your files with that video's folder here.
3. **Stuck on an error?** Every folder has a `TROUBLESHOOTING.md` with each error from its video: the exact message, why it happens, and the fix. If yours isn't there, paste the exact error in the video's comments, and say whether you're on Windows or Mac.
4. **Lost your project?** Copy the previous video's folder somewhere of your own, open that copy in VS Code (File, Open Folder), connect your org (`SFDX: Authorize an Org`), and carry on from there.

Each folder is a complete Salesforce DX project that opens and deploys on its own. Each folder's README explains how to deploy or run it and what you should see.

## Before you start

Use a free practice org, never a work org. A Developer Edition org is free: sign up at `developer.salesforce.com/signup`. Video 2 sets up everything else: VS Code, the Salesforce CLI, Java 21 and the Salesforce Extension Pack.

The videos are recorded on a Mac with Salesforce CLI 2.155.7 and the Salesforce Extension Pack 68.4.0, at API version 68.0. On Windows, the steps are the same unless a folder's README says otherwise.

## Where the topics come from

The topics and their order follow Salesforce's own sample galleries, [trailheadapps/lwc-recipes](https://github.com/trailheadapps/lwc-recipes) and [trailheadapps/apex-recipes](https://github.com/trailheadapps/apex-recipes) (both CC0-1.0). The classes, components, the app and the explanations here are our own.

## Licence

[MIT](LICENSE): fork it, use it, change it, share it. Keep the licence notice.

---

Salesforce, Lightning and Apex are trademarks of Salesforce, Inc. This repo and the channel are not affiliated with, sponsored or endorsed by Salesforce. Sharma Traders and its customers are made up.
