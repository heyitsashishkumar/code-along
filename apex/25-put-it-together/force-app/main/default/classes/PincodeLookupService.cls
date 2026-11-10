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
