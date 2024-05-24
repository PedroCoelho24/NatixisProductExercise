public class ProductTableController {
    
    private static HttpResponse authResponse;
    private static HttpResponse productsResponse;
    
    @AuraEnabled
    public static Map<String, List<ProductsWrapper.IndividualProductWrapper>> doCallout() {
        try {
            
            String authToken = getAuth();
            ProductsWrapper apiProducts = getProducts(authToken);
            
            saveRecords(apiProducts.products);
            
            return dataTreatment(apiProducts);
            
        } catch(CustomException e) {
            throw new CustomException('do callout error: ' + e.getMessage());
        }
        
    }
    
    public static void saveRecords(List<ProductsWrapper.IndividualProductWrapper> listOfRecords) {
        List<Database.UpsertResult> results = new List<Database.UpsertResult>();
        try {
            List<Dummy_Product__c> recordsToSave = new List<Dummy_Product__c>();
            
            for (ProductsWrapper.IndividualProductWrapper record : listOfRecords) {
                if (!String.isBlank(record.id) && !String.isEmpty(record.id) && !String.isBlank(record.id)){
                    Dummy_Product__c temp = new Dummy_Product__c(
                        External_Id__c = record.id,
                        Name = record.title,
                        Description__c = record.description,
                        Price__c = record.price,
                        Rating__c = record.rating,
                        Stock__c = record.stock,
                        Brand__c = record.brand,
                        Category__c = record.category,
                        Thumbnail__c = record.thumbnail
                    );
                    recordsToSave.add(temp); 
                }          
            }
            results = Database.upsert(recordsToSave, Dummy_Product__c.External_Id__c);
            
        } catch (Exception e) {
            system.debug(e.getMessage());
        }
        
    }
    public static Map<String, List<ProductsWrapper.IndividualProductWrapper>> dataTreatment(ProductsWrapper apiProducts) {
        
        Map<String, List<ProductsWrapper.IndividualProductWrapper>> result = new Map<String, List<ProductsWrapper.IndividualProductWrapper>>();
        
        for(ProductsWrapper.IndividualProductWrapper cat : apiProducts.products) {
            if(!result.keySet().contains(cat.category)) {
                result.put(cat.category, new List<ProductsWrapper.IndividualProductWrapper>());
            }
            result.get(cat.category).add(cat);
        }
        
        for(String category : result.keySet()) {
            result.get(category).sort(new IndividualProductWrapperComparator());
        }
        
        
        return result;
        
    }
    
    public static String getAuth() {
        try{
            Dummy_JSON_Authentication_Info__mdt calloutInformation = [SELECT Endpoint__c, Method__c, Password__c, Username__c FROM Dummy_JSON_Authentication_Info__mdt LIMIT 1];
            String endpoint = calloutInformation.Endpoint__c;
            String method = calloutInformation.Method__c;
            Map<String, String> headers = new Map<String, String>{ 'Content-Type' => 'application/json' };
                EmailRequests.authRequestBody authBodyDTO = new EmailRequests.authRequestBody();
            authBodyDTO.username = calloutInformation.Username__c;
            authBodyDTO.password = calloutInformation.Password__c ;
            String body = JSON.serialize(authBodyDTO);
            
            authResponse = new HttpResponse();
            authResponse = SOAPCallout.doRequest(endpoint, method, headers, body);
            AuthorizationWrapper wrapper = AuthorizationWrapper.parse(authResponse.getBody());
            return wrapper.token;
            
        } catch(CalloutException e) {
            throw new CalloutException('getAuth error: ' + e.getMessage());
        }
    }
    
    public static ProductsWrapper getProducts(String authToken) {
        try{
            Dummy_JSON_Products_Info__mdt calloutInformation = [SELECT Endpoint__c, Method__c FROM Dummy_JSON_Products_Info__mdt LIMIT 1];
            String endpoint = calloutInformation.Endpoint__c;
            String method = calloutInformation.Method__c;
            
            productsResponse = new HttpResponse();
            productsResponse = SOAPCallout.doRequest(endpoint, method, null, '');
            ProductsWrapper wrapper = ProductsWrapper.parse(productsResponse.getBody().replace('limit', 'limit_x'));            
            
            return wrapper;
        } catch(CalloutException e) {
            throw new CalloutException('Error in getProduct: ' + e.getMessage());
        }
    }
    public class CustomException extends Exception {}
    
    
    public class IndividualProductWrapperComparator implements Comparator<ProductsWrapper.IndividualProductWrapper> {
        public Integer compare(ProductsWrapper.IndividualProductWrapper iPW1, ProductsWrapper.IndividualProductWrapper iPW2) {
            Integer returnValue = 0;
            
            if(iPW1 == null && iPW2 == null) {
                returnValue = 0;
            } else if(iPW1 == null) {
                returnValue = -1; 
            } else if(iPW2 == null) {
                returnValue = 1;
            } else if ((iPW1.price == null) && (iPW2.price == null)) {
                returnValue = 0;
            } else if (iPW1.price == null){
                returnValue = -1;
            } else if (iPW2.price == null){
                returnValue = 1;
            } else if (iPW1.price < iPW2.price) {
                returnValue = -1;
            } else if (iPW1.price > iPW2.price) {
                returnValue = 1;
            }
            return returnValue;
        }
        
    }  
}