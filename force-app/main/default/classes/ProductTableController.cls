public class ProductTableController {
    
    private static HttpResponse authResponse;
    private static HttpResponse productsResponse;
    
    @AuraEnabled
    public static void doCallout() {
        try {
        	String authToken = getAuth();
            getProducts(authToken);
        } catch(CalloutException e) {
            throw new CalloutException('do callout error: ' + e.getMessage());
            
        }
            
    }
    
    public static String getAuth() {
        try{
            Dummy_JSON_Authentication_Info__mdt calloutInformation = [SELECT Endpoint__c, Method__c, Password__c, Username__c FROM Dummy_JSON_Authentication_Info__mdt LIMIT 1];
            system.debug(calloutInformation);
            String endpoint = calloutInformation.Endpoint__c;
            String method = calloutInformation.Method__c;
            Map<String, String> headers = new Map<String, String>{ 'Content-Type' => 'application/json' };
            EmailRequests.authRequestBody authBodyDTO = new EmailRequests.authRequestBody();
            authBodyDTO.username = calloutInformation.Username__c;
            authBodyDTO.password = calloutInformation.Password__c ;
            String body = JSON.serialize(authBodyDTO);
            
            authResponse = new HttpResponse();
            authResponse = SOAPCallout.doRequest(endpoint, method, headers, body);
            system.debug(authResponse.getBody());
            AuthorizationWrapper wrapper = AuthorizationWrapper.parse(authResponse.getBody());
            return wrapper.token;
            
        } catch(CalloutException e) {
            throw new CalloutException('getAuth error: ' + e.getMessage());
        }
    }
    
    public static void getProducts(String authToken) {
        try{
            Dummy_JSON_Products_Info__mdt calloutInformation = [SELECT Endpoint__c, Method__c FROM Dummy_JSON_Products_Info__mdt LIMIT 1];
            system.debug(calloutInformation);
            String endpoint = calloutInformation.Endpoint__c;
            String method = calloutInformation.Method__c;
            
            productsResponse = new HttpResponse();
            productsResponse = SOAPCallout.doRequest(endpoint, method, null, '');
            ProductsWrapper wrapper = ProductsWrapper.parse(productsResponse.getBody().replace('limit', 'limit_x'));            
            system.debug(wrapper);
        } catch(CalloutException e) {
            throw new CalloutException('Error in getProduct: ' + e.getMessage());
        }
    }
    
    
    
}