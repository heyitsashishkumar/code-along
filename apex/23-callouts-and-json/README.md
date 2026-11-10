# 23 · Calling an external REST API (`Http`, `JSON`) and exposing Apex to Flow (`@InvocableMethod`)

The code for **Apex from Zero #23**. Stuck on an error? See [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## What you built

1. **`PincodeLookupService.cls`**, sending an HTTP `GET` request with `HttpRequest` and `Http` and deserializing the JSON response into `PincodeResponse` with `JSON.deserialize(res.getBody(), PincodeResponse.class)`:

```apex
public with sharing class PincodeLookupService {
    public class PincodeResponse {
        public String pincode;
        public String city;
        public String state;
    }

    public static PincodeResponse lookupCityByPincode(String pincode) {
        if (String.isBlank(pincode)) {
            return null;
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.sharmatraders.example/pincode/' + EncodingUtil.urlEncode(pincode.trim(), 'UTF-8'));
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            return (PincodeResponse) JSON.deserialize(res.getBody(), PincodeResponse.class);
        }
        return null;
    }
}
```

2. **`DealFlowAction.cls`**, exposing `@InvocableMethod(label='Create Quick Deal')` with bulkified `List<Request>` and `List<Result>` wrapper classes (`@InvocableVariable`) for Salesforce Flow.
3. **`PincodeLookupServiceTest.cls`**, testing `PincodeLookupService` offline with `HttpCalloutMock` and `Test.setMock` and testing `DealFlowAction` in bulk at **100% coverage**.

## Deploy and run the tests

1. **Deploy `force-app`** (Mac or Windows):

   ```bash
   sf project deploy start --source-dir force-app --target-org desk-org
   ```

2. **Run `PincodeLookupServiceTest` with code coverage:**

   ```bash
   sf apex run test --class-names PincodeLookupServiceTest --result-format human --code-coverage --target-org desk-org
   ```

## What you should see

Both test methods in `PincodeLookupServiceTest` pass with `100%` code coverage on `PincodeLookupService` and `DealFlowAction`.

**Your small task:** use `JSON.serialize(info)` in a test or anonymous script to convert a `PincodeResponse` object back into a JSON string and inspect the output.
