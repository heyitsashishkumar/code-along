# Troubleshooting · 24 · Platform Events (`EventBus.publish`) and Custom Metadata Types (`getAll()`)

Every error we hit while making **Apex from Zero #24**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `DML operation Insert not allowed on ...__mdt`

- **Why:** Custom Metadata Type (`__mdt`) records are metadata, not database rows (`__c`), so Apex DML statements (`insert`, `update`, `delete`) cannot modify them—even inside `@IsTest`.
- **Fix:** Read Custom Metadata through a helper method backed by a `@TestVisible private static` override variable so unit tests can inject test configuration values in memory without DML.

## `System.DmlException: Insert failed. First exception on row 0; first error: FIELD_INTEGRITY_EXCEPTION, Name ID: id value of incorrect type: 001...` (`Task.WhoId` vs `Task.WhatId`)

- **Why:** On `Task`, `WhoId` only accepts a `Contact` (`003...`) or `Lead` (`00Q...`) ID, whereas `WhatId` accepts an `Account` (`001...`), `Opportunity` (`006...`), or custom object ID.
- **Fix:** Use `WhoId = contact.Id` when linking a `Task` to a person (`WelcomeEmailJob`), and `WhatId = deal.AccountId` when linking a `Task` to an Account or Opportunity (`DeskEventService`).
