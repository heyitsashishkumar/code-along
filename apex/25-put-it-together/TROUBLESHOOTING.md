# Troubleshooting · 25 · Put the whole customer-desk backend together, run the full test suite, and ship

Every error we hit while making **Apex from Zero #25**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.SObjectException: SObject row was retrieved via SOQL without querying the requested field: Contact.LastName` (`E07`)

- **Why:** `ContactController.findContacts('Verma')` queries `SELECT Id, Name, Title, Phone, Email, AccountId FROM Contact` (which selects `Name`, not `LastName`). Passing that row into `WelcomeEmailJob` (which reads `c.LastName`) throws `System.SObjectException` unless `LastName` was explicitly queried.
- **Fix:** Include `Id, LastName` in the `SELECT` list of `savedContact` (or any `Contact` list passed to `WelcomeEmailJob`).

## Code coverage below 75% blocks production deployment (`Code coverage issue`)

- **Why:** Salesforce requires at least **75% org-wide Apex code coverage**—and every trigger must have > 0% coverage—when deploying with `--test-level RunLocalTests` to production.
- **Fix:** Run `sf apex run test --test-level RunLocalTests --code-coverage --result-format human` before deploying, inspect the `UNCOVERED LINES` column, and add unit assertions for any uncovered branches.
