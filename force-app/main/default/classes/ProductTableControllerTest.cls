@IsTest
private class ProductTableControllerTest {
    
    @IsTest
    static void testDoCallout() {
        // Set up mock callout responses
        Test.setMock(HttpCalloutMock.class, new ProductTableControllerMock());

        
        Dummy_JSON_Authentication_Info__mdt authInfo = [SELECT MasterLabel, Endpoint__c, Method__c, Password__c, Username__c FROM Dummy_JSON_Authentication_Info__mdt LIMIT 1];
     
        Dummy_JSON_Products_Info__mdt productsInfo = [SELECT MasterLabel, Endpoint__c, Method__c FROM Dummy_JSON_Products_Info__mdt LIMIT 1];
        

        // Perform the callout
        Test.startTest();
        Map<String, List<ProductsWrapper.IndividualProductWrapper>> result = ProductTableController.doCallout();
        Test.stopTest();

        // Assert the result
        System.assertNotEquals(null, result);
        System.assertEquals(true, result.containsKey('electronics'));
        System.assertEquals(2, result.get('electronics').size());
        System.assertEquals('Laptop', result.get('electronics')[0].brand);
        System.assertEquals('Phone', result.get('electronics')[1].brand);
    }

    @IsTest
    static void testDataTreatment() {
        // Create sample product data
        ProductsWrapper.IndividualProductWrapper product1 = new ProductsWrapper.IndividualProductWrapper();
        product1.category = 'electronics';
        product1.brand = 'Laptop';
        product1.price = 999.99;

        ProductsWrapper.IndividualProductWrapper product2 = new ProductsWrapper.IndividualProductWrapper();
        product2.category = 'electronics';
        product2.brand = 'Phone';
        product2.price = 499.99;

        ProductsWrapper wrapper = new ProductsWrapper();
        wrapper.products = new List<ProductsWrapper.IndividualProductWrapper>{ product1, product2 };

        // Perform data treatment
        Map<String, List<ProductsWrapper.IndividualProductWrapper>> result = ProductTableController.dataTreatment(wrapper);

        // Assert the result
        System.assertNotEquals(null, result);
        System.assertEquals(1, result.size());
        System.assertEquals(true, result.containsKey('electronics'));
        System.assertEquals(2, result.get('electronics').size());
        System.assertEquals('Phone', result.get('electronics')[0].brand);  // sorted by price
        System.assertEquals('Laptop', result.get('electronics')[1].brand); // sorted by price
    }
    
    @IsTest
    static void testComparator() {
        // Create sample product data
        ProductsWrapper.IndividualProductWrapper product1 = new ProductsWrapper.IndividualProductWrapper();
        product1.price = 100.0;
        
        ProductsWrapper.IndividualProductWrapper product2 = new ProductsWrapper.IndividualProductWrapper();
        product2.price = 200.0;

        ProductTableController.IndividualProductWrapperComparator comparator = new ProductTableController.IndividualProductWrapperComparator();
        
        // Perform comparison
        Integer result = comparator.compare(product1, product2);
        
        // Assert the result
        System.assertEquals(-1, result); // product1 < product2
    }
    
    private class ProductTableControllerMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            if (req.getEndpoint().contains('auth')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"token": "mockToken"}');
                res.setStatusCode(200);
            } else if (req.getEndpoint().contains('products')) {
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"products": [{"category": "electronics", "brand": "Laptop", "price": 999.99, "id": 1}, {"category": "electronics", "brand": "Phone", "price": 499.99, "id": 2}]}');
                res.setStatusCode(200);
            }
            return res;
        }
    }
}