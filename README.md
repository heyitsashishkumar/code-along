# code-along

The code from the **Freestyle Cyber Hub** code-along playlists, one folder per video. Each folder holds the project exactly as it is at the end of its video, so you can check your work against it, or start the next video from it.

Today that's two companion playlists that build **Sharma Traders' customer desk** together from zero, and a third series that teaches the platform administrator's job:
- **LWC from Zero: Code Along** (`lwc/`) — the front-end Lightning Web Components, one piece at a time.
- **Apex from Zero: Code Along** (`apex/`) — the Salesforce backend classes, SOQL queries, controllers, unit tests, and triggers that power the desk.
- **The Accidental Admin** (`admin/`) — the Salesforce admin series: Kestrel Industrial's practice org, one folder per episode, that you build in a free scratch org of your own.

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
| 18 | Wire an Apex method: `ContactController.cls` (`@AuraEnabled(cacheable=true)` `getContacts` and `findContacts`) and `contactSearch` wired with `@wire(findContacts, { searchKey: '$searchKey' })` | [lwc/18-wire-apex](lwc/18-wire-apex/) |
| 19 | Call Apex on a click: `DealController.cls` (`getDeals`) and `customerDeals` calling `await getDeals({ accountId: this.recordId })` imperatively with `lightning-spinner` and `try` / `catch` / `finally` | [lwc/19-call-apex](lwc/19-call-apex/) |
| 20 | Tables: `customerDeals` upgraded to `lightning-datatable` with inline editing (`editable: true`, `draftValues`, `Promise.all` + `updateRecord`) and `await refreshApex(this.deals)` | [lwc/20-datatable](lwc/20-datatable/) |
| 21 | Moving around the app: `customerSummary` with `NavigationMixin` (`standard__recordPage` and `standard__objectPage` for Open company, New customer, and All customers) | [lwc/21-navigation](lwc/21-navigation/) |
| 22 | Components that aren't related (Lightning Message Service): `Customer_Selected__c` message channel, `contactSearch` publishing `publish(this.messageContext, ...)`, and `customerForm` + `customerDeals` subscribing | [lwc/22-message-service](lwc/22-message-service/) |
| 23 | Modals, alerts, labels and static resources: `noteModal` (`LightningModal`), `LightningAlert`, `LightningConfirm`, and `deskHeader` (`@salesforce/label` + `@salesforce/resourceUrl`) | [lwc/23-modals-labels-resources](lwc/23-modals-labels-resources/) |
| 24 | Test your component: Jest unit tests (`@salesforce/sfdx-lwc-jest`) for `contactTile`, `contactSearch` (fake timers & wire adapter), and `customerDeals` | [lwc/24-jest](lwc/24-jest/) |
| 25 | Put it together: `customerDesk` combining `<c-desk-header>`, `<c-contact-search>`, `<c-customer-form>`, and `<c-customer-deals>` in a responsive two-column layout | [lwc/25-put-it-together](lwc/25-put-it-together/) |

## Apex from Zero (`apex/`)

| Video | What you build | Folder |
|---|---|---|
| 1 | Introduction: what Apex is, how it powers Sharma Traders' customer desk, and how to use the playlist | no code |
| 2 | Set up everything and run your first line of Apex: `scripts/apex/hello.apex` and `System.debug('Namaste from Sharma Traders!');` | [apex/02-setup](apex/02-setup/) |
| 3 | Your first Apex class and method: `DeskGreeter.cls`, `public with sharing`, `public static String greet(String customerName)` | [apex/03-first-class](apex/03-first-class/) |
| 4 | Variables, types, dates, and `null`: `DealCalculator.cls` (18% GST with `Decimal`, festival discounts with `Boolean`, follow-up `Date.today().addDays(30)`, and safe navigation `?.`) | [apex/04-variables-and-types](apex/04-variables-and-types/) |
| 5 | Lists and loops: `DealFilter.cls` (`List<Decimal>`, `.add()`, `.sort()`, `for (Decimal amount : amounts)`, filtering high-value deals and summing totals) | [apex/05-lists-and-loops](apex/05-lists-and-loops/) |
| 6 | Sets and Maps (fast lookup by ID): `AccountDirectory.cls` (`Set<Id>`, `Map<Id, Account>`, `new Map<Id, Account>(accounts)`, `.containsKey()`, `.get()`) | [apex/06-sets-and-maps](apex/06-sets-and-maps/) |
| 7 | sObjects and saving records with DML: `CustomerOnboarding.cls` (`onboardShopWithContacts` creating an `Account` and bulk-inserting linked `Contact` records outside the loop) | [apex/07-sobjects-and-dml](apex/07-sobjects-and-dml/) |
| 8 | Partial saves and `try` / `catch` (`Database.insert`): `insertContactsAllowingPartialSuccess` (`Database.insert(contacts, false)` + `Database.SaveResult`) and `onboardWithRollbackOnError` (`Savepoint` and `Database.rollback`) | [apex/08-database-methods](apex/08-database-methods/) |
| 9 | SOQL: querying your org's database: `CustomerQueries.cls` (`getContactsByCity` with `:city` bind variable, `Account.Name`, `WITH USER_MODE`, `ORDER BY`, and `LIMIT`) | [apex/09-soql-basics](apex/09-soql-basics/) |
| 10 | Parent-to-child, child-to-parent, and aggregates: `getShopsWithContacts` (`(SELECT ... FROM Contacts)`) and `getTotalWonDealAmount` (`SUM(Amount)` with `AggregateResult`) | [apex/10-soql-relationships](apex/10-soql-relationships/) |
| 11 | Security in Apex (`with sharing` and `WITH USER_MODE`): auditing `CustomerQueries` and `CustomerOnboarding` (`WITH USER_MODE` and `insert as user`) | [apex/11-security-and-user-mode](apex/11-security-and-user-mode/) |
| 12 | Write `ContactController` for LWC `@wire`: `ContactController.cls` (`@AuraEnabled(cacheable=true)` `getContacts` and `findContacts` for LWC #18) | [apex/12-contact-controller](apex/12-contact-controller/) |
| 13 | Write `DealController` and throw readable errors: `DealController.cls` (`getDeals`, `createQuickDeal`, `insert as user`, and `AuraHandledException` for LWC #19–#20) | [apex/13-deal-controller](apex/13-deal-controller/) |
| 14 | Write your first Apex unit test (`@IsTest`, `@TestSetup`, and `Assert`): `ContactControllerTest.cls` testing `getContacts`, `findContacts`, `System.runAs(salesRep)`, `AccountDirectory`, `CustomerOnboarding`, and `CustomerQueries` | [apex/14-contact-controller-test](apex/14-contact-controller-test/) |
| 15 | Test data, users, and exceptions: `DealControllerTest.cls` testing `getDeals`, `createQuickDeal`, and negative `AuraHandledException` assertions | [apex/15-deal-controller-test](apex/15-deal-controller-test/) |
| 16 | Your first Apex trigger (`before` vs `after`): `ContactTrigger.trigger` (`before insert, before update` on `Trigger.new` setting default `LeadSource` and `MailingCountry` with zero extra DML) | [apex/16-first-trigger](apex/16-first-trigger/) |
| 17 | `after` triggers (updating related records): `OpportunityTrigger.trigger` (`Trigger.isBefore` defaults + `Trigger.isAfter` aggregate rollup of `'Closed Won'` totals onto `Account.AnnualRevenue`) | [apex/17-after-trigger](apex/17-after-trigger/) |
| 18 | Trigger context variables, `Trigger.old`, and reparenting: handling `after delete`, `after undelete`, and reparented deals across `Trigger.new` and `Trigger.old` | [apex/18-trigger-oldmap](apex/18-trigger-oldmap/) |
| 19 | Bulkifying triggers (the 200-record rule and `addError`): `deal.Amount.addError('Deal amount cannot be negative.')` and 200-record bulk rollup in 1 SOQL query and 1 DML statement | [apex/19-bulk-triggers](apex/19-bulk-triggers/) |
| 20 | The Trigger Handler pattern and trigger tests: `OpportunityTrigger.trigger` + `OpportunityTriggerHandler.cls` (`beforeSave`, `afterChange`) + `OpportunityTriggerTest.cls` (200-record bulk test, reparent/delete/undelete, and `addError` at 100% coverage) | [apex/20-trigger-handler](apex/20-trigger-handler/) |
| 21 | Async Apex part 1 (`Queueable` and `@future`): `WelcomeEmailJob.cls` (`implements Queueable`, `System.enqueueJob`, `@future stampOnboardingNoteAsync`) and `WelcomeEmailJobTest.cls` (`Test.startTest()` / `Test.stopTest()`) | [apex/21-queueable-and-future](apex/21-queueable-and-future/) |
| 22 | Async Apex part 2 (`Database.Batchable` and `Schedulable`): `StaleDealBatch.cls` (`Database.Batchable<SObject>`, `Database.Stateful`), `StaleDealScheduler.cls` (`Schedulable`, `System.schedule`), and `StaleDealBatchTest.cls` | [apex/22-batch-and-scheduled](apex/22-batch-and-scheduled/) |
| 23 | Calling an external REST API (`Http`, `JSON`) and exposing Apex to Flow (`@InvocableMethod`): `PincodeLookupService.cls` (`HttpRequest`, `JSON.deserialize`), `DealFlowAction.cls` (`@InvocableMethod`, `@InvocableVariable`), and `PincodeLookupServiceTest.cls` (`HttpCalloutMock`, `Test.setMock`) | [apex/23-callouts-and-json](apex/23-callouts-and-json/) |
| 24 | Platform Events (`EventBus.publish`) and Custom Metadata Types (`getAll()`): `DeskEventService.cls` (0-SOQL threshold lookup, `@TestVisible` override, high-value deal alerts) and `DeskEventServiceTest.cls` | [apex/24-invocable-and-events](apex/24-invocable-and-events/) |
| 25 | Put the whole customer-desk backend together, run the full test suite, and ship: `ApexDeskTestSuite.cls` + `DeskGreeterTest.cls` + `DealCalculatorTest.cls` (end-to-end integration test and 100% org-wide coverage across all 17 classes and triggers) | [apex/25-put-it-together](apex/25-put-it-together/) |

When the videos work with records, each folder also includes a `data/` folder with Sharma Traders' made-up customers, companies and deals (standard Account, Contact and Opportunity records). Load them into your org once with:

```bash
sf data import tree --plan data/plan.json
```

## The Accidental Admin (`admin/`)

Each folder is Kestrel Industrial's practice org **at the end of one episode**, as a complete Salesforce DX project. Episode N starts from the folder of episode N-1. More rows appear here as each episode is recorded. See [admin/README.md](admin/README.md).

| Video | What it holds | Folder |
|---|---|---|
| Before episode 1 | Set up your own free practice org: Dev Hub, the Salesforce CLI, a scratch org from `config/project-scratch-def.json`, and the `Kestrel_Practice` permission set | [admin/ep-00](admin/ep-00/) |
| Episode 1: You're the Salesforce guy now. Same metadata as `ep-00`, plus the account Brookfield Water and a script that renames you to Owen Hartley | [admin/ep-01](admin/ep-01/) |

## How to use it with the playlists

1. **Code along in your own project.** Pause the video and type it yourself. That's what makes it stick. Video 2 shows how to make the project.
2. **Check against the video's folder.** When your screen doesn't match the video, compare your files with that video's folder here.
3. **Stuck on an error?** Every folder has a `TROUBLESHOOTING.md` with each error from its video: the exact message, why it happens, and the fix. If yours isn't there, paste the exact error in the video's comments, and say whether you're on Windows or Mac.
4. **Lost your project?** Copy the previous video's folder somewhere of your own, open that copy in VS Code (File, Open Folder), connect your org (`SFDX: Authorize an Org`), and carry on from there.

Each folder is a complete Salesforce DX project that opens and deploys on its own. Each folder's README explains how to deploy or run it and what you should see.

## Before you start

Use a free practice org, never a work org. A Developer Edition org is free: sign up at `developer.salesforce.com/signup`. Video 2 sets up everything else: VS Code, the Salesforce CLI, Java 21 and the Salesforce Extension Pack. For The Accidental Admin, the setup video (folder `admin/ep-00`) also turns on Dev Hub and makes your scratch org.

The videos are recorded on a Mac with Salesforce CLI 2.155.7 and the Salesforce Extension Pack 68.4.0, at API version 68.0. On Windows, the steps are the same unless a folder's README says otherwise.

## Where the topics come from

The topics and their order follow Salesforce's own sample galleries, [trailheadapps/lwc-recipes](https://github.com/trailheadapps/lwc-recipes) and [trailheadapps/apex-recipes](https://github.com/trailheadapps/apex-recipes) (both CC0-1.0). The classes, components, the app and the explanations here are our own.

## Licence

[MIT](LICENSE): fork it, use it, change it, share it. Keep the licence notice.

---

Salesforce, Lightning and Apex are trademarks of Salesforce, Inc. This repo and the channel are not affiliated with, sponsored or endorsed by Salesforce. Sharma Traders and its customers are made up.
