# Troubleshooting · 23 · Calling an external REST API and exposing Apex to Flow

Every error we hit while making **Apex from Zero #23**, copied word-for-word from our practice org (`apex-rehearse`, API 68.0).

## `System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out`

- **Why:** Salesforce forbids making an HTTP callout after a DML statement (`insert`, `update`, `delete`) or async enqueue in the same transaction so database locks are never held open while waiting for an external server.
- **Fix:** Always make HTTP callouts **before** running DML in the transaction, or move the callout into a background `Queueable` class that implements `Database.AllowsCallouts`.

## `System.TypeException: Methods defined as TestMethod do not support Web service callouts`

- **Why:** Unit tests (`@IsTest`) are isolated from the outside internet and cannot make live HTTP callouts.
- **Fix:** Implement `HttpCalloutMock` and register your mock response before calling the service method:

  ```apex
  Test.setMock(HttpCalloutMock.class, new PincodeMock(200, '{"pincode":"201310","city":"Greater Noida","state":"Uttar Pradesh"}'));
  ```

## `System.CalloutException: Unauthorized endpoint, please check Setup->Security->Remote site settings`

- **Why:** In a live org (outside unit tests), Salesforce blocks callouts to any domain that has not been authorized in **Named Credentials** or **Remote Site Settings**.
- **Fix:** Configure a Named Credential (`callout:My_Named_Credential/...`) or add the domain in **Setup → Remote Site Settings**.
