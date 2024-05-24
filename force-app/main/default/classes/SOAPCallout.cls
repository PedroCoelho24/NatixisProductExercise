public without sharing class SOAPCallout {
    
    private static HttpRequest request;
    
    public static HttpResponse doRequest(String endpoint, String method, Map<String, String> headers, String body) {
        prepareRequest(endpoint, method, headers, body);
        HttpResponse response = new Http().send(request);
        return response;
    }
    
    private static void prepareRequest(String endpoint, String method, Map<String, String> headers, String body) {
        request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setTimeout(20000);
        
        if(headers != null && !(headers.keySet().isEmpty()))
        {
            setHeader(headers);
        }
        
        if(String.isNotBlank(body)) {
            request.setBody(body);
        }
    }
    
    private static void setHeader(Map<String, String> headers) {
        for(String header : headers.keySet()) {
            request.setHeader(header, headers.get(header));
        }
    }
}