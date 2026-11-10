@IsTest
private class PincodeLookupServiceTest {
    private class PincodeMock implements HttpCalloutMock {
        private final Integer statusCode;
        private final String body;

        PincodeMock(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(this.statusCode);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.body);
            return res;
        }
    }

    @IsTest
    static void parses200JsonResponseAndHandlesNon200AndBlank() {
        Test.setMock(
            HttpCalloutMock.class,
            new PincodeMock(
                200,
                '{"pincode":"201310","city":"Greater Noida","state":"Uttar Pradesh"}'
            )
        );

        PincodeLookupService.PincodeResponse info = PincodeLookupService.lookupCityByPincode('201310');
        Assert.isNotNull(info);
        Assert.areEqual('Greater Noida', info.city);
        Assert.areEqual('Uttar Pradesh', info.state);
        Assert.isNull(PincodeLookupService.lookupCityByPincode(''));

        Test.setMock(HttpCalloutMock.class, new PincodeMock(404, '{"error":"Not found"}'));
        Assert.isNull(PincodeLookupService.lookupCityByPincode('000000'));
    }

    @IsTest
    static void invocableCreatesQuickDealsInBulkForFlow() {
        Account shop = new Account(Name = 'Verma Logistics');
        insert shop;

        DealFlowAction.Request req = new DealFlowAction.Request();
        req.accountId = shop.Id;
        req.dealName = 'Flow Auto-Renewal Deal';
        req.amount = 75000;

        List<DealFlowAction.Result> results = DealFlowAction.createQuickDeals(
            new List<DealFlowAction.Request>{ req }
        );
        Assert.areEqual(1, results.size());
        Assert.isNotNull(results[0].dealId);
        Assert.areEqual(0, DealFlowAction.createQuickDeals(new List<DealFlowAction.Request>()).size());
    }
}
